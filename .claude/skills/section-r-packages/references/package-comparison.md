# R 包功能速查表

本文档提供常用R包的核心函数速查,帮助快速选择合适的工具。

## 数据处理包对比

### 核心数据处理包

| 包名 | 核心优势 | 适用数据规模 | 学习曲线 | 速度 |
|------|---------|------------|---------|------|
| **dplyr** | 直观、管道友好 | 小-中(< 1GB) | ⭐ | ⭐⭐⭐ |
| **data.table** | 极快、内存高效 | 大(> 1GB) | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **tidytable** | data.table引擎+dplyr语法 | 大 | ⭐ | ⭐⭐⭐⭐ |
| **duckplyr** | DuckDB后端+dplyr语法 | 超大(> 10GB) | ⭐ | ⭐⭐⭐⭐⭐ |
| **dtplyr** | dplyr转data.table | 大 | ⭐ | ⭐⭐⭐⭐ |

### 功能对比

| 操作 | dplyr | data.table | tidytable |
|------|-------|-----------|-----------|
| **筛选行** | `filter()` | `DT[i]` | `filter()` |
| **选择列** | `select()` | `DT[, j]` | `select()` |
| **新增列** | `mutate()` | `DT[, x := ...]` | `mutate()` |
| **分组汇总** | `group_by() %>% summarise()` | `DT[, .(stat), by=...]` | `summarise(.by=...)` |
| **连接** | `left_join()` | `merge()` 或 `DT[DT2, on=...]` | `left_join()` |
| **排序** | `arrange()` | `setorder()` | `arrange()` |

---

## 表格制作包对比

### 论文表格包

| 包名 | 适用场景 | 输出格式 | 自动化程度 | 定制性 |
|------|---------|---------|-----------|-------|
| **gtsummary** | 统计表格(Table 1) | HTML/Word/LaTeX | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **gt** | 通用表格美化 | HTML/LaTeX/RTF | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **flextable** | Word/PowerPoint | Word/PPT/HTML | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **kableExtra** | RMarkdown表格 | HTML/PDF | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **DT** | 交互式表格 | HTML | ⭐⭐⭐⭐ | ⭐⭐⭐ |

### 使用建议

**场景1:论文基线表(Table 1)**
```r
library(gtsummary)
tbl_summary(data, by = group) %>%
  add_p() %>%
  bold_labels()
```
→ **推荐**: gtsummary(最快)

**场景2:回归结果表**
```r
library(gtsummary)
tbl_regression(model) %>%
  add_global_p()
```
→ **推荐**: gtsummary

**场景3:复杂排版表格**
```r
library(gt)
gt(data) %>%
  tab_header(title = "...") %>%
  tab_spanner(label = "Group", columns = c(col1, col2))
```
→ **推荐**: gt(灵活性高)

**场景4:Word文档嵌入**
```r
library(flextable)
flextable(data) %>%
  theme_vanilla() %>%
  save_as_docx(path = "table.docx")
```
→ **推荐**: flextable

---

## 可视化包对比

### ggplot2扩展包

| 包名 | 核心功能 | 典型用途 |
|------|---------|---------|
| **ggpubr** | 快速统计图+显著性标记 | 组间比较、添加p值 |
| **patchwork** | 图形组合 | 多图拼接 |
| **ggsci** | 期刊配色 | Lancet/NEJM/Nature配色 |
| **ggrepel** | 标签防重叠 | 散点图标签 |
| **ggridges** | 山脊图(ridge plot) | 分布对比 |
| **ggforce** | 高级几何对象 | 圆形、椭圆、缩放 |
| **ggtext** | 富文本支持 | Markdown/HTML标签 |
| **gganimate** | 动画 | 时间序列动画 |

### 专业图表包

| 图表类型 | 推荐包 | 核心函数 |
|---------|-------|---------|
| **森林图** | `forestplot` | `forestplot()` |
| **生存曲线** | `survminer` | `ggsurvplot()` |
| **相关矩阵** | `corrplot` | `corrplot()` |
| **热图** | `pheatmap` | `pheatmap()` |
| **桑基图** | `ggalluvial` | `geom_alluvium()` |
| **韦恩图** | `ggvenn` | `ggvenn()` |
| **网络图** | `ggraph` | `ggraph() + geom_edge_*()` |
| **地图** | `sf` + `ggplot2` | `geom_sf()` |

---

## 统计分析包对比

### 回归分析

| 任务 | Base R | 现代包 | 增强功能 |
|------|--------|-------|---------|
| **线性回归** | `lm()` | `lm()` | - |
| **Logistic** | `glm()` | `glm()` | - |
| **混合模型** | - | `lme4::lmer()` | 随机效应 |
| **生存分析** | - | `survival::coxph()` | Cox模型 |
| **因果推断** | - | `MatchIt`, `WeightIt` | PSM/IPW |

### 模型辅助包

| 包名 | 核心功能 | 典型使用 |
|------|---------|---------|
| **broom** | 模型结果整理 | `tidy()`, `glance()`, `augment()` |
| **performance** | 模型诊断 | `check_model()`, `r2()` |
| **easystats** | 统计全家桶 | 报告、贝叶斯、诊断 |
| **marginaleffects** | 边际效应 | `marginaleffects()`, `predictions()` |

---

## 机器学习框架对比

### 核心框架

| 框架 | 哲学 | 优点 | 缺点 | 推荐场景 |
|------|------|------|------|---------|
| **mlr3** | 面向对象 | 强大、灵活、可扩展 | 学习曲线陡 | 复杂项目、科研 |
| **tidymodels** | tidyverse风格 | 直观、管道友好 | 性能略逊 | 快速原型、教学 |
| **caret** | 统一接口(旧) | 成熟、稳定 | 维护较少 | 遗留项目 |

### 学习器对比

| 算法 | mlr3 | tidymodels | 原生包 |
|------|------|-----------|--------|
| **随机森林** | `lrn("classif.ranger")` | `rand_forest()` | `ranger::ranger()` |
| **XGBoost** | `lrn("classif.xgboost")` | `boost_tree()` | `xgboost::xgb.train()` |
| **SVM** | `lrn("classif.svm")` | `svm_*()` | `e1071::svm()` |
| **神经网络** | `lrn("classif.nnet")` | `mlp()` | `nnet::nnet()` |

---

## 字符串处理包

### stringr vs stringi

| 任务 | stringr(简单) | stringi(高级) |
|------|--------------|--------------|
| **检测匹配** | `str_detect()` | `stri_detect()` |
| **提取** | `str_extract()` | `stri_extract()` |
| **替换** | `str_replace()` | `stri_replace()` |
| **分割** | `str_split()` | `stri_split()` |
| **编码** | - | `stri_enc_*()` |
| **Unicode** | - | `stri_trans_*()` |

**建议**: 日常使用stringr,复杂需求(编码、Unicode)用stringi

---

## 数据导入导出包

### 文件格式对应包

| 格式 | 推荐包 | 核心函数 | 说明 |
|------|-------|---------|------|
| **CSV** | `readr` | `read_csv()` | 快速、类型推断 |
| **Excel** | `readxl` | `read_excel()` | 读取 |
| | `writexl` | `write_xlsx()` | 写入 |
| | `openxlsx` | `write.xlsx()` | 复杂格式 |
| **SPSS/Stata/SAS** | `haven` | `read_sav()`, `read_dta()` | 保留标签 |
| **JSON** | `jsonlite` | `fromJSON()`, `toJSON()` | Web API |
| **数据库** | `DBI` + driver | `dbReadTable()` | 通用接口 |
| | `dbplyr` | - | dplyr语法查询 |
| **大文件** | `vroom` | `vroom()` | 极快读取 |
| | `arrow` | `read_parquet()` | Parquet格式 |

---

## 并行计算包

### 并行框架对比

| 包名 | 后端类型 | 适用场景 | 易用性 |
|------|---------|---------|-------|
| **parallel** | Base R | 简单并行 | ⭐⭐ |
| **future** | 统一接口 | 通用并行 | ⭐⭐⭐⭐⭐ |
| **furrr** | future + purrr | 函数式并行 | ⭐⭐⭐⭐ |
| **foreach** | 循环并行 | 传统循环改写 | ⭐⭐⭐ |

### future使用示例
```r
library(future)
library(furrr)

# 设置并行后端
plan(multisession, workers = 4)

# purrr风格并行
result <- future_map(data, expensive_function)
```

---

## 快速选择指南

### 场景1:10GB CSV文件处理
```r
library(arrow)
library(duckplyr)

# 读取Parquet(或转换CSV到Parquet)
data <- arrow::read_parquet("large.parquet")

# duckplyr处理
data %>%
  filter(condition) %>%
  group_by(var) %>%
  summarise(mean = mean(value))
```

### 场景2:论文Table 1制作
```r
library(gtsummary)

tbl_summary(
  data, 
  by = group,
  statistic = list(all_continuous() ~ "{mean} ({sd})")
) %>%
  add_p() %>%
  modify_header(label ~ "**Variable**") %>%
  as_gt() %>%
  gt::gtsave("table1.docx")
```

### 场景3:机器学习全流程
```r
library(tidymodels)

# 数据分割
split <- initial_split(data)
train <- training(split)
test <- testing(split)

# 配方(预处理)
recipe <- recipe(target ~ ., data = train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors())

# 模型
model <- rand_forest() %>%
  set_engine("ranger") %>%
  set_mode("classification")

# 工作流
workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(model)

# 训练+评估
fit <- fit(workflow, train)
predict(fit, test)
```

---

## 包维护状态检查

### 活跃维护的现代包(推荐)
✅ tidyverse生态(dplyr, ggplot2, purrr等)
✅ mlr3, tidymodels
✅ gtsummary, gt
✅ data.table
✅ arrow, duckdb

### 维护较少但稳定的包
⚠️ caret(被tidymodels替代)
⚠️ reshape2(被tidyr替代)
⚠️ plyr(被dplyr替代)

### 检查包状态
```r
# 查看CRAN更新时间
tools::CRAN_package_db() %>%
  filter(Package == "包名") %>%
  select(Package, Published)

# 查看GitHub活跃度
# 访问 https://github.com/作者/包名
```

---

## 参考资源

- **tidyverse**: https://www.tidyverse.org/
- **mlr3book**: https://mlr3book.mlr-org.com/
- **tidymodels**: https://www.tidymodels.org/
- **data.table**: https://rdatatable.gitlab.io/data.table/
- **CRAN Task Views**: https://cran.r-project.org/web/views/
