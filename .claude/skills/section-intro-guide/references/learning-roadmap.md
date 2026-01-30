# R 语言学习路线图

本文档提供从零基础到高级应用的完整R语言学习路径。

## 学习路线总览

```
阶段1        阶段2           阶段3          阶段4           阶段5
基础入门 →  数据处理   →   统计分析   →  专业方向    →   进阶应用
(2-4周)    (4-6周)        (8-12周)      (12-24周)       (持续)
  ↓           ↓             ↓             ↓              ↓
R语法      tidyverse     常用统计     领域深化      工具集成
RStudio    ggplot2       回归分析     流行病学      Quarto
基础操作    数据清洗      假设检验     因果推断      Shiny
                                      机器学习      R包开发
```

---

## 阶段1:基础入门(2-4周)

### 目标
- 掌握R基本语法
- 熟悉RStudio界面
- 理解数据结构
- 能进行简单数据操作

### 学习内容

#### 1.1 环境配置
- [ ] 安装R(≥4.3)
- [ ] 安装RStudio/Positron
- [ ] 配置CRAN镜像
- [ ] 安装常用包:`tidyverse`, `here`, `renv`

**推荐教程**: 
- 本库: `doc/0013-positron.qmd`(Positron IDE配置)
- 官方: [R安装指南](https://cloud.r-project.org/)

#### 1.2 基础语法
```r
# 向量
x <- c(1, 2, 3, 4, 5)

# 数据框
df <- data.frame(
  id = 1:5,
  name = c("A", "B", "C", "D", "E"),
  score = c(85, 90, 78, 92, 88)
)

# 条件判断
if (x > 0) {
  print("Positive")
} else {
  print("Non-positive")
}

# 循环
for (i in 1:5) {
  print(i)
}

# 函数
my_mean <- function(x) {
  sum(x) / length(x)
}
```

#### 1.3 数据结构
| 类型 | 维度 | 同质性 | 示例 |
|------|------|-------|------|
| **向量** | 1D | 同质 | `c(1,2,3)` |
| **矩阵** | 2D | 同质 | `matrix(1:6, nrow=2)` |
| **数据框** | 2D | 异质 | `data.frame(x=1:3, y=c("a","b","c"))` |
| **列表** | 1D | 异质 | `list(a=1, b="text", c=df)` |

#### 1.4 必学操作
```r
# 索引
df[1, ]        # 第1行
df[, 2]        # 第2列
df$name        # name列
df[df$score > 85, ]  # 筛选

# 缺失值
is.na(x)       # 检测缺失
na.omit(df)    # 删除缺失行

# 读写文件
df <- read.csv("data.csv")
write.csv(df, "output.csv", row.names = FALSE)
```

### 练习项目
1. 读取CSV文件,计算均值、标准差
2. 创建函数计算BMI
3. 使用`plot()`绘制散点图

### 学习资源
- **R for Data Science**: https://r4ds.hadley.nz/ (免费在线)
- **Swirl交互式教程**: `install.packages("swirl"); library(swirl); swirl()`
- 本库入门指南: `doc/0001-guide.rmd`

---

## 阶段2:数据处理(4-6周)

### 目标
- 熟练使用tidyverse
- 掌握数据清洗技巧
- 能处理缺失值、异常值
- 绘制基础图表

### 学习内容

#### 2.1 tidyverse核心包
```r
library(tidyverse)

# dplyr:数据操作
data %>%
  filter(age > 18) %>%          # 筛选
  select(id, age, gender) %>%   # 选列
  mutate(bmi = weight/height^2) %>%  # 新增列
  arrange(desc(age)) %>%        # 排序
  group_by(gender) %>%          # 分组
  summarise(mean_age = mean(age))  # 汇总

# tidyr:数据整形
data_long <- data %>%
  pivot_longer(cols = c(visit1, visit2), 
               names_to = "visit", 
               values_to = "value")

data_wide <- data_long %>%
  pivot_wider(names_from = visit, 
              values_from = value)
```

**推荐教程**:
- 本库: `doc/3003-dplyr-tidyr.rmd`

#### 2.2 ggplot2可视化
```r
# 基础模板
ggplot(data, aes(x = var1, y = var2)) +
  geom_point() +                      # 几何对象
  labs(title = "Title", x = "X", y = "Y") +  # 标签
  theme_minimal()                     # 主题

# 常用图表
ggplot(data, aes(x = group, y = value)) +
  geom_boxplot()                      # 箱线图

ggplot(data, aes(x = value)) +
  geom_histogram()                    # 直方图

ggplot(data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm")          # 散点图+趋势线
```

**推荐教程**:
- 本库: `doc/2025-bindboxplot.rmd`(箱线图)
- 本库: `doc/2026-bindscatterplot.rmd`(散点图)

#### 2.3 数据清洗
```r
# 缺失值
library(naniar)
gg_miss_var(data)           # 缺失值可视化
data_clean <- data %>%
  drop_na(key_variable)     # 删除缺失

# 重复值
data <- data %>%
  distinct()                # 去重

# 字符串处理
library(stringr)
data <- data %>%
  mutate(
    name = str_trim(name),           # 去空格
    city = str_to_upper(city)        # 转大写
  )

# 日期处理
library(lubridate)
data <- data %>%
  mutate(
    date = ymd(date_column),
    year = year(date),
    month = month(date)
  )
```

**推荐教程**:
- 本库: `doc/3010-stringr.rmd`(字符串)
- 本库: `doc/3009-datetime.rmd`(日期时间)

### 练习项目
1. 清洗真实数据集(如mtcars)
2. 绘制3种以上图表类型
3. 生成描述性统计表格

### 学习资源
- **ggplot2: Elegant Graphics for Data Analysis**: https://ggplot2-book.org/
- 本库数据可视化章节(20xx系列)

---

## 阶段3:统计分析(8-12周)

### 目标
- 理解常用统计方法
- 能进行假设检验
- 掌握回归分析
- 理解统计结果解读

### 学习内容

#### 3.1 描述性统计
```r
# 基础统计量
summary(data)
mean(data$age, na.rm = TRUE)
sd(data$age, na.rm = TRUE)

# 分组统计
data %>%
  group_by(gender) %>%
  summarise(
    n = n(),
    mean = mean(age),
    sd = sd(age),
    median = median(age)
  )

# 制表
library(gtsummary)
tbl_summary(data, by = gender) %>%
  add_p()
```

**推荐教程**:
- 本库: `doc/1053-gtsummary.rmd`

#### 3.2 假设检验
```r
# t检验
t.test(data$score ~ data$gender)

# 卡方检验
chisq.test(table(data$gender, data$education))

# 方差分析
aov_result <- aov(score ~ group, data = data)
summary(aov_result)

# 非参数检验
wilcox.test(data$score ~ data$gender)  # Wilcoxon
kruskal.test(score ~ group, data = data)  # Kruskal-Wallis
```

**推荐教程**:
- 本库: `doc/1036-anova.rmd`

#### 3.3 回归分析
```r
# 线性回归
lm_model <- lm(y ~ x1 + x2 + x3, data = data)
summary(lm_model)

# 模型诊断
plot(lm_model)  # 诊断图
library(performance)
check_model(lm_model)

# Logistic回归
glm_model <- glm(outcome ~ x1 + x2, 
                 data = data, 
                 family = binomial)
summary(glm_model)

# 结果整理
library(broom)
tidy(glm_model)     # 系数表
glance(glm_model)   # 模型统计量
augment(glm_model)  # 预测值与残差
```

**推荐教程**:
- 本库: `doc/1021-linear-regression.rmd`(线性回归)
- 本库: `doc/1019-logistic.rmd`(Logistic回归)
- 本库: `doc/1043-broom.rmd`(模型整理)

#### 3.4 生存分析
```r
library(survival)
library(survminer)

# Kaplan-Meier曲线
surv_obj <- Surv(time = data$time, event = data$status)
km_fit <- survfit(surv_obj ~ group, data = data)
ggsurvplot(km_fit, pval = TRUE, risk.table = TRUE)

# Cox回归
cox_model <- coxph(Surv(time, status) ~ age + gender + treatment, 
                   data = data)
summary(cox_model)

# 森林图
library(forestplot)
ggforest(cox_model, data = data)
```

**推荐教程**:
- 本库: `doc/1020-survival.rmd`
- 本库: `doc/2016-forestplot.rmd`

### 练习项目
1. 完成一个完整的回归分析报告
2. 绘制生存曲线与森林图
3. 使用gtsummary生成Table 1

### 学习资源
- **Statistical Inference via Data Science**: https://moderndive.com/
- 本库统计分析章节(10xx系列)

---

## 阶段4:专业方向(12-24周)

根据研究方向选择深化学习:

### 方向A:流行病学与因果推断

#### 核心方法
- 倾向性得分匹配(PSM)
- 工具变量(IV)
- 双重差分(DiD)
- 中介效应分析
- 敏感性分析

**推荐学习路径**:
1. `doc/1018-psm.rmd` - PSM基础
2. `doc/1060-instrumental-variables.rmd` - 工具变量
3. `doc/1028-did.rmd` - 双重差分
4. `doc/1023-mediation.rmd` - 中介效应
5. `doc/1056-dag.rmd` - 因果图

**必读书籍**:
- Hernán & Robins. *Causal Inference: What If* (免费PDF)

---

### 方向B:机器学习

#### 核心框架
- **mlr3**: 现代机器学习框架
- **tidymodels**: tidyverse风格ML
- **caret**: 传统ML框架(维护较少)

**学习路径**:
```
基础 → 算法 → 调参 → 集成 → 深度学习
  ↓      ↓      ↓      ↓        ↓
框架  随机森林  交叉验证 Stacking  torch
     XGBoost   网格搜索 Bagging   keras
     SVM      贝叶斯优化
```

**推荐教程**:
1. `doc/1016-mlr3.rmd` - mlr3完整教程
2. `doc/1042-tidymodels.rmd` - tidymodels框架
3. `doc/1080-random-forest.rmd` - 随机森林
4. `doc/1081-svm.rmd` - SVM
5. `doc/1082-ensemble-learning.rmd` - 集成学习

**书籍**:
- **mlr3book**: https://mlr3book.mlr-org.com/
- **Tidy Modeling with R**: https://www.tmwr.org/

---

### 方向C:数据可视化

#### 进阶技能
- 定制ggplot2主题
- 复杂图形组合
- 交互式图表(plotly)
- 动画图表(gganimate)
- 地理数据可视化

**学习路径**:
1. 基础图表(箱线图、散点图、直方图)
2. 专业图表(森林图、生存曲线、热图)
3. 图表美化(配色、主题、排版)
4. 高级组合(patchwork、cowplot)
5. 交互与动画

**推荐教程**: 本库20xx系列全部50+篇

---

### 方向D:特殊应用

#### 卫生经济学
- 成本效果分析(CEA)
- 马尔科夫模型
- 决策树
- 敏感性分析

**推荐**:
- `doc/1015-health-economics.rmd`
- `doc/1062-treeage-pro.rmd`

#### 生物信号处理
- ECG/EEG分析
- 心率变异性(HRV)
- 小波变换
- 频谱分析

**推荐**:
- `doc/1096-wavelet-transform.rmd`
- `doc/1034-nvmd.rmd`

---

## 阶段5:进阶应用(持续)

### 5.1 可重复研究
```r
# RMarkdown/Quarto报告
# 版本控制(Git)
# 环境管理(renv)
# 项目组织(here包)
```

**推荐教程**:
- `doc/0011-rmarkdown.rmd`
- `doc/0012-quarto-vs-rmd.md`
- `doc/3006-reproducible-research.rmd`

### 5.2 Shiny应用开发
```r
library(shiny)

ui <- fluidPage(
  titlePanel("My App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Sample size:", 10, 1000, 100)
    ),
    mainPanel(
      plotOutput("histogram")
    )
  )
)

server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(rnorm(input$n))
  })
}

shinyApp(ui, server)
```

**推荐教程**:
- `doc/4001-shiny.rmd`
- **Mastering Shiny**: https://mastering-shiny.org/

### 5.3 R包开发
- 使用`usethis`创建包
- 编写函数文档(roxygen2)
- 单元测试(testthat)
- CRAN提交

**资源**:
- **R Packages**: https://r-pkgs.org/

---

## 学习方法建议

### 1. 项目驱动学习
- ❌ 不要:看完所有教程再动手
- ✅ 推荐:有实际项目需求时,边学边做

### 2. 代码复现
```r
# 每个教程的代码都手动运行一遍
# 修改参数,观察结果变化
# 用自己的数据替换示例数据
```

### 3. 建立知识库
```r
# 保存常用代码片段
# 记录遇到的错误与解决方案
# 整理个人笔记
```

### 4. 社区参与
- **RStudio Community**: https://community.rstudio.com/
- **Stack Overflow**: 搜索R相关问题
- **GitHub**: 阅读优秀R包源码

---

## 学习时间估算

| 阶段 | 内容 | 每周学习时间 | 总周数 |
|------|------|------------|--------|
| 阶段1 | 基础语法 | 10-15小时 | 2-4周 |
| 阶段2 | 数据处理 | 10小时 | 4-6周 |
| 阶段3 | 统计分析 | 8-10小时 | 8-12周 |
| 阶段4 | 专业方向 | 6-8小时 | 12-24周 |
| 阶段5 | 进阶应用 | 灵活 | 持续 |

**总计**: 约6-12个月达到熟练水平

---

## 常见问题

**Q: 零基础需要先学其他编程语言吗?**

A: 不需要。R语法相对友好,可直接学习。

**Q: 应该学Base R还是tidyverse?**

A: 优先学tidyverse(更直观),但Base R基础也要掌握。

**Q: Python vs R,应该学哪个?**

A: 看应用场景:
- 统计分析、学术研究 → R
- Web开发、深度学习 → Python
- 数据科学 → 两者都学

**Q: 如何选择学习资源?**

A: 优先顺序:
1. 本库教程(针对流行病学/生物统计)
2. 官方文档与书籍(R4DS, mlr3book等)
3. 在线课程(DataCamp, Coursera)

---

## 检查清单

### 阶段1完成标准
- [ ] 能熟练使用RStudio
- [ ] 理解向量、数据框等数据结构
- [ ] 会写简单函数
- [ ] 能读取CSV文件并进行基本操作

### 阶段2完成标准
- [ ] 熟练使用dplyr五大动词
- [ ] 能用ggplot2绘制5种以上图表
- [ ] 掌握数据清洗基本流程
- [ ] 能处理缺失值与异常值

### 阶段3完成标准
- [ ] 理解t检验、卡方检验等假设检验
- [ ] 能进行线性回归与Logistic回归
- [ ] 会解读回归结果
- [ ] 能生成基本的统计表格

### 阶段4完成标准
- [ ] 掌握至少2种专业方向的核心方法
- [ ] 能独立完成完整分析报告
- [ ] 理解所用方法的假设与局限
- [ ] 能解读复杂模型结果

---

## 推荐学习顺序(本库教程)

### 第1-2月:入门
1. `0001-guide.rmd` - 学习路线总览
2. `0013-positron.qmd` - IDE配置
3. `3003-dplyr-tidyr.rmd` - 数据处理
4. `2025-bindboxplot.rmd` - 基础可视化

### 第3-4月:进阶
5. `1053-gtsummary.rmd` - 统计表格
6. `1021-linear-regression.rmd` - 线性回归
7. `1019-logistic.rmd` - Logistic回归
8. `1043-broom.rmd` - 模型结果整理

### 第5-6月:专业化
**流行病学方向**:
9. `1018-psm.rmd` - 倾向性得分匹配
10. `1020-survival.rmd` - 生存分析
11. `1022-meta-analysis.rmd` - Meta分析

**机器学习方向**:
9. `1016-mlr3.rmd` - mlr3框架
10. `1080-random-forest.rmd` - 随机森林
11. `1082-ensemble-learning.rmd` - 集成学习

---

## 参考资源汇总

### 书籍(免费)
- [R for Data Science (2e)](https://r4ds.hadley.nz/)
- [Advanced R](https://adv-r.hadley.nz/)
- [R Packages](https://r-pkgs.org/)
- [ggplot2: Elegant Graphics](https://ggplot2-book.org/)
- [Statistical Inference via Data Science](https://moderndive.com/)
- [Causal Inference: What If](https://www.hsph.harvard.edu/miguel-hernan/causal-inference-book/)

### 网站
- **CRAN**: https://cran.r-project.org/
- **RStudio**: https://posit.co/
- **tidyverse**: https://www.tidyverse.org/
- **R-bloggers**: https://www.r-bloggers.com/

### 社区
- **RStudio Community**: https://community.rstudio.com/
- **Stack Overflow [r]**: https://stackoverflow.com/questions/tagged/r
- **Reddit r/rstats**: https://www.reddit.com/r/rstats/

### 在线课程
- **DataCamp**: R编程互动课程
- **Coursera**: Johns Hopkins R Programming
- **edX**: Harvard Data Science
