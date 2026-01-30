# 数据清洗工作流程规范

本文档提供标准化的数据清洗流程和常见问题解决方案。

## 标准数据清洗流程

### 阶段1:数据导入与初步检查

#### 1.1 导入数据
```r
library(tidyverse)

# 根据格式选择合适的函数
data_raw <- readr::read_csv("data.csv")        # CSV
# data_raw <- readxl::read_excel("data.xlsx")  # Excel
# data_raw <- haven::read_sav("data.sav")      # SPSS
```

#### 1.2 数据概览
```r
# 基本信息
glimpse(data_raw)        # 查看结构
head(data_raw, 20)       # 前20行
tail(data_raw, 20)       # 后20行
dim(data_raw)            # 维度

# 变量类型检查
sapply(data_raw, class)  # 每列的类型
```

#### 1.3 快速质量检查
```r
# 缺失值概览
naniar::miss_var_summary(data_raw)

# 重复行检查
sum(duplicated(data_raw))

# 唯一ID检查(如有ID列)
length(unique(data_raw$id)) == nrow(data_raw)
```

---

### 阶段2:变量类型处理

#### 2.1 数值型变量
```r
# 检查数值型变量的异常值
summary(data_raw$age)

# 转换为数值型(处理"NA"字符串等)
data <- data_raw %>%
  mutate(
    age = as.numeric(age),
    weight = parse_number(weight)  # 自动去除非数字字符
  )

# 范围检查
data %>%
  filter(age < 0 | age > 120) %>%  # 不合理的年龄
  select(id, age)
```

#### 2.2 因子型变量
```r
# 转换为因子
data <- data %>%
  mutate(
    gender = factor(gender, levels = c("Male", "Female")),
    education = factor(education, 
                      levels = c("Primary", "Secondary", "University"),
                      ordered = TRUE)
  )

# 检查因子水平
levels(data$gender)
table(data$gender)  # 频数统计
```

#### 2.3 日期时间变量
```r
library(lubridate)

data <- data %>%
  mutate(
    # 不同日期格式
    date1 = ymd(date_column1),           # 2024-01-15
    date2 = mdy(date_column2),           # 01/15/2024
    date3 = dmy(date_column3),           # 15-01-2024
    
    # 日期时间
    datetime = ymd_hms(datetime_column)  # 2024-01-15 14:30:00
  )

# 计算年龄(从出生日期)
data <- data %>%
  mutate(
    age_calculated = as.numeric(difftime(Sys.Date(), birth_date, units = "days")) / 365.25
  )
```

#### 2.4 字符串变量
```r
data <- data %>%
  mutate(
    # 去除首尾空格
    name = str_trim(name),
    
    # 统一大小写
    city = str_to_title(city),
    
    # 替换特殊字符
    comment = str_replace_all(comment, "[^[:alnum:][:space:]]", "")
  )
```

---

### 阶段3:缺失值处理

#### 3.1 缺失值探索
```r
library(naniar)

# 缺失值可视化
gg_miss_var(data)                    # 每列缺失比例
gg_miss_upset(data)                  # 缺失模式
vis_miss(data)                       # 缺失热图

# 缺失值模式
miss_pattern <- md.pattern(data, plot = FALSE)
```

#### 3.2 缺失值处理策略

**策略1:删除(适用于MCAR)**
```r
# 删除任意列有缺失的行
data_complete <- data %>%
  drop_na()

# 删除特定列有缺失的行
data_clean <- data %>%
  drop_na(age, gender)

# 删除缺失率>50%的变量
data_clean <- data %>%
  select(where(~mean(is.na(.)) < 0.5))
```

**策略2:单一插补**
```r
data_imputed <- data %>%
  mutate(
    # 数值型:均值/中位数
    age = ifelse(is.na(age), median(age, na.rm = TRUE), age),
    
    # 分类型:众数
    gender = fct_explicit_na(gender, na_level = "Unknown")
  )
```

**策略3:多重插补(推荐)**
```r
library(mice)

# 执行多重插补
imp <- mice(data, m = 5, method = "pmm", seed = 2026)

# 提取完整数据集
data_imputed <- complete(imp, 1)  # 第1个插补数据集

# 或合并分析
fit <- with(imp, lm(y ~ x1 + x2))
pooled <- pool(fit)
summary(pooled)
```

---

### 阶段4:异常值检测与处理

#### 4.1 单变量异常值

**方法1:IQR法**
```r
detect_outliers_iqr <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  
  lower <- Q1 - 1.5 * IQR
  upper <- Q3 + 1.5 * IQR
  
  x < lower | x > upper
}

data <- data %>%
  mutate(
    age_outlier = detect_outliers_iqr(age),
    weight_outlier = detect_outliers_iqr(weight)
  )

# 查看异常值
data %>% filter(age_outlier)
```

**方法2:Z-score法**
```r
data <- data %>%
  mutate(
    age_z = (age - mean(age, na.rm = TRUE)) / sd(age, na.rm = TRUE),
    age_outlier_z = abs(age_z) > 3  # |Z| > 3 为异常
  )
```

#### 4.2 多变量异常值(Mahalanobis距离)
```r
# 选择数值型变量
numeric_vars <- data %>% select(where(is.numeric))

# 计算Mahalanobis距离
maha_dist <- mahalanobis(
  numeric_vars, 
  center = colMeans(numeric_vars, na.rm = TRUE),
  cov = cov(numeric_vars, use = "complete.obs")
)

# 卡方检验阈值
threshold <- qchisq(0.999, df = ncol(numeric_vars))
data$multivariate_outlier <- maha_dist > threshold
```

#### 4.3 异常值处理
```r
# 方法1:删除
data_clean <- data %>%
  filter(!age_outlier, !weight_outlier)

# 方法2:截断(Winsorization)
winsorize <- function(x, probs = c(0.01, 0.99)) {
  limits <- quantile(x, probs = probs, na.rm = TRUE)
  x[x < limits[1]] <- limits[1]
  x[x > limits[2]] <- limits[2]
  x
}

data <- data %>%
  mutate(
    age_win = winsorize(age),
    weight_win = winsorize(weight)
  )

# 方法3:设为缺失(后续插补)
data <- data %>%
  mutate(
    age = ifelse(age_outlier, NA, age)
  )
```

---

### 阶段5:数据一致性检查

#### 5.1 逻辑一致性
```r
# 检查不合理的组合
inconsistent <- data %>%
  filter(
    # 年龄<18但已婚
    (age < 18 & marital_status == "Married") |
    # 怀孕但性别为男
    (gender == "Male" & pregnant == "Yes") |
    # 体重异常(与身高不符)
    (weight / (height/100)^2 < 10 | weight / (height/100)^2 > 60)
  )

nrow(inconsistent)  # 不一致记录数
```

#### 5.2 时间一致性
```r
# 出生日期晚于调查日期
data %>%
  filter(birth_date > survey_date)

# 开始日期晚于结束日期
data %>%
  filter(start_date > end_date)
```

#### 5.3 跨变量一致性
```r
# BMI计算验证
data <- data %>%
  mutate(
    bmi_calculated = weight / (height/100)^2,
    bmi_diff = abs(bmi - bmi_calculated)
  )

# 检查差异>1的记录
data %>% filter(bmi_diff > 1)
```

---

### 阶段6:重复记录处理

#### 6.1 完全重复
```r
# 检测
duplicates <- data %>%
  group_by_all() %>%
  filter(n() > 1) %>%
  ungroup()

# 删除
data_dedup <- data %>%
  distinct()
```

#### 6.2 基于ID的重复
```r
# 保留第一条
data_dedup <- data %>%
  distinct(id, .keep_all = TRUE)

# 保留最新记录
data_dedup <- data %>%
  arrange(id, desc(date)) %>%
  distinct(id, .keep_all = TRUE)

# 聚合重复记录
data_agg <- data %>%
  group_by(id) %>%
  summarise(
    age = first(age),
    visits = n(),
    last_visit = max(date)
  )
```

---

### 阶段7:变量变换与标准化

#### 7.1 数值变换
```r
data <- data %>%
  mutate(
    # 对数变换(右偏分布)
    income_log = log(income + 1),
    
    # 平方根变换(计数数据)
    count_sqrt = sqrt(count),
    
    # Box-Cox变换
    # value_bc = forecast::BoxCox(value, lambda = "auto")
  )
```

#### 7.2 标准化
```r
# Z-score标准化
data <- data %>%
  mutate(
    age_z = (age - mean(age)) / sd(age),
    weight_z = (weight - mean(weight)) / sd(weight)
  )

# Min-Max归一化[0, 1]
normalize <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

data <- data %>%
  mutate(across(where(is.numeric), normalize, .names = "{.col}_norm"))
```

---

### 阶段8:数据验证与导出

#### 8.1 最终质量检查
```r
# 检查清单
checks <- tibble(
  Check = c(
    "总行数",
    "总列数",
    "缺失值总数",
    "重复行数",
    "数值型变量数",
    "因子型变量数"
  ),
  Result = c(
    nrow(data),
    ncol(data),
    sum(is.na(data)),
    sum(duplicated(data)),
    sum(sapply(data, is.numeric)),
    sum(sapply(data, is.factor))
  )
)

print(checks)
```

#### 8.2 生成数据清洗报告
```r
library(DataExplorer)

# 自动生成HTML报告
create_report(data, output_file = "data_quality_report.html")
```

#### 8.3 导出清洗后数据
```r
# CSV格式
write_csv(data, "data_cleaned.csv")

# RDS格式(保留R对象属性)
saveRDS(data, "data_cleaned.rds")

# Excel格式
writexl::write_xlsx(data, "data_cleaned.xlsx")
```

---

## 常见问题解决方案

### 问题1:中文乱码
```r
# 读取时指定编码
data <- read_csv("data.csv", locale = locale(encoding = "GBK"))

# 或
data <- read_csv("data.csv", locale = locale(encoding = "UTF-8"))
```

### 问题2:日期解析失败
```r
# 手动解析复杂日期格式
data <- data %>%
  mutate(
    date_parsed = parse_date_time(date_column, 
                                   orders = c("ymd", "mdy", "dmy"))
  )
```

### 问题3:因子水平不一致
```r
# 统一因子水平
data <- data %>%
  mutate(
    gender = fct_recode(gender,
                        "Male" = "M",
                        "Male" = "male",
                        "Female" = "F",
                        "Female" = "female")
  )
```

### 问题4:列名不规范
```r
# 清理列名
library(janitor)

data <- data %>%
  clean_names()  # 自动转为snake_case,去除特殊字符

# 手动重命名
data <- data %>%
  rename(
    patient_id = `Patient ID`,
    date_visit = `Date of Visit`
  )
```

---

## 数据清洗模板

```r
# 完整数据清洗模板
clean_data <- function(raw_data) {
  raw_data %>%
    # 1. 列名清理
    janitor::clean_names() %>%
    
    # 2. 变量类型转换
    mutate(
      date = ymd(date),
      age = as.numeric(age),
      gender = factor(gender)
    ) %>%
    
    # 3. 去除完全重复行
    distinct() %>%
    
    # 4. 删除关键变量缺失的行
    drop_na(id, date) %>%
    
    # 5. 异常值处理
    filter(
      age >= 0 & age <= 120,
      between(bmi, 10, 60)
    ) %>%
    
    # 6. 派生变量
    mutate(
      bmi_category = case_when(
        bmi < 18.5 ~ "Underweight",
        bmi < 25 ~ "Normal",
        bmi < 30 ~ "Overweight",
        TRUE ~ "Obese"
      )
    ) %>%
    
    # 7. 排序
    arrange(id, date)
}

# 使用
data_clean <- clean_data(data_raw)
```

---

## 参考资源

- **tidyverse数据清洗**: https://r4ds.hadley.nz/data-tidy.html
- **naniar缺失值**: https://naniar.njtierney.com/
- **mice多重插补**: https://amices.org/mice/
- **DataExplorer**: https://cran.r-project.org/package=DataExplorer
