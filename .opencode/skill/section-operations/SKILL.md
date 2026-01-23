---
name: section-operations
description: 生成"实用操作"类页面的超详细教程内容。触发条件:(1)用户要求编写数据导入导出、清洗、转换、正则表达式、Web爬虫教程;(2)用户需要讲解文档写作工具(RMarkdown/Quarto)、开发环境(RStudio/Positron)配置;(3)涉及readr、readxl、stringr、lubridate、rvest等实用工具包;(4)用户提到CSV/Excel读取、字符串处理、日期时间、可重复研究工作流。生成实用操作教程,强调"任务目标→工具选择→操作步骤→结果验证",提供完整的可操作流程和常见问题解决方案。
---

## 核心任务

生成实用操作类教程(.rmd/.qmd),涵盖数据处理、工具使用、工作流优化。

## 必备内容结构

### YAML头部与setup代码块

```yaml
---
title: '[操作/工具名称]实战指南'
date: 'YYYY-MM-DD'
categories:
- 实用操作
- [具体分类]
image: images/[topic]-cover.svg
description: 一句话概括操作目标
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE, 
                      fig.width=8, fig.height=5, fig.retina=2, 
                      out.width="100%", dpi=150)
```
```

### 标题层次结构(CRITICAL)

**MUST使用正确的标题层次**:

```markdown
## 一级标题(章节)  # 用于主要章节,生成目录
### 二级标题(小节)  # 用于子主题
#### 三级标题(详细步骤)  # 用于具体操作步骤
```

**CRITICAL RULE**:
- 一级标题(`##`)是生成目录的**唯一**途径
- 文章必须包含至少3个一级标题才会显示目录
- 单个`#`标题由Quarto从YAML的title字段自动生成,**NEVER手动添加**
- 如果文章只有`###`标题而无`##`标题,将**不会显示目录**

**正确示例**:
```markdown
## 任务目标  # ✅ 一级标题,会出现在目录中
### 典型场景  # ✅ 二级标题,不会出现在目录中但有层次结构
```

**错误示例**:
```markdown
### 任务目标  # ❌ 只用三级标题,目录不会生成
#### 典型场景  # ❌ 层次混乱
```

### 任务目标与典型场景

**必须包含**:
```markdown
## 任务目标

本教程解决[具体问题],适用于[应用场景]。

**典型场景**
- [场景1:具体描述]
- [场景2]

**实际应用案例**
- [案例1:研究中的应用]
- [案例2]

**工具对比**

| 工具/方法 | 适用场景 | 优点 | 缺点 | 推荐度 |
|---------|---------|------|------|-------|
| [方法1] | | | | ⭐⭐⭐ |
| [方法2] | | | | ⭐⭐ |
```

### 环境准备

**工具与依赖**:
```markdown
## 准备工作

### 必要工具

- **R**: >= 4.0
- **RStudio/Positron**: [版本要求]
- **系统要求**: [Windows/Mac/Linux特殊说明]

### R包安装

{r install, eval=FALSE}
install.packages(c(
  "package1",  # 用途说明
  "package2"   # 用途说明
))

### 外部依赖(如适用)

- [工具1]: 下载地址与安装说明
- [工具2]: 配置方法
```

### 基础操作流程

**分步骤详解**:
```markdown
## 基础操作

### 步骤1:[操作名称]

**目标**: [这步要实现什么]

{r step1}
# 代码实现

**说明**:
- [代码逻辑解释]
- [参数含义]
- [注意事项]

**输出检查**:
```r
# 如何验证结果正确
str(output)
head(output)
```

### 步骤2:[下一步操作]

[同上结构]

### 步骤3:[结果验证]

{r verify}
# 验证代码正确性

**验证清单**:
- [ ] [检查项1]
- [ ] [检查项2]
```

### 实战案例

**提供完整的真实案例**:
```markdown
## 实战案例

### 案例:[具体任务描述]

#### 背景

[实际研究场景描述]

#### 数据来源

[数据格式、大小、特点]

#### 完整流程

{r case-full}
# 第1步:导入数据
data_raw <- readr::read_csv(
  "path/to/file.csv",
  col_types = cols(...)  # 指定列类型
)

# 第2步:数据清洗
data_clean <- data_raw %>%
  # [具体操作]
  
# 第3步:数据转换
data_final <- data_clean %>%
  # [具体操作]

# 第4步:结果输出
write_csv(data_final, "output/result.csv")

#### 结果说明

[输出文件的内容、格式、用途]
```

### 进阶技巧

**高级用法与优化**:
```markdown
## 进阶技巧

### 技巧1:批量处理

{r batch}
# 处理多个文件
files <- list.files("data/", pattern = "\\.csv$")
results <- purrr::map_dfr(files, ~{
  read_csv(.x) %>%
    # 处理流程
})

### 技巧2:错误处理

{r error-handling}
# 安全读取
safe_read <- purrr::safely(read_csv)

result <- safe_read("file.csv")
if (is.null(result$error)) {
  data <- result$result
} else {
  message("读取失败:", result$error)
}

### 技巧3:性能优化

{r performance}
# 对大文件使用data.table
library(data.table)
data_large <- fread("large_file.csv")  # 比read_csv更快

# 或使用vroom
library(vroom)
data_fast <- vroom("file.csv")
```

### 常见问题与解决方案

**系统化的排错指南**:
```markdown
## 常见问题

### 问题1:[错误描述]

**表现**:
```r
Error: ...
```

**原因**: [问题根源]

**解决方法**:
```r
# 正确做法

**预防措施**: [如何避免]

### 问题2:编码问题(中文乱码)

**表现**: 中文显示为乱码

**解决**:
```r
# 方法1:指定编码
read_csv("file.csv", locale = locale(encoding = "GBK"))

# 方法2:转换编码
Encoding(data$col) <- "UTF-8"

### 问题3:路径问题

**Windows路径**:
```r
# 错误
file <- "C:\data\file.csv"  # 反斜杠报错

# 正确
file <- "C:/data/file.csv"
file <- "C:\\data\\file.csv"

# 推荐:使用here包
library(here)
file <- here("data", "file.csv")
```

### 效率与规范

**最佳实践指南**:
```markdown
## 效率与规范

### 文件命名规范

- 使用小写字母和连字符
- 包含日期:`2026-01-data.csv`
- 避免空格和特殊字符
- 有意义的描述性名称

### 目录组织

```
project/
├── data/
│   ├── raw/           # 原始数据(只读)
│   ├── processed/     # 处理后数据
│   └── README.md      # 数据说明
├── scripts/
│   ├── 01-import.R
│   ├── 02-clean.R
│   └── 03-analyze.R
├── output/
│   ├── figures/
│   └── tables/
└── doc/
```

### 代码风格

- 使用tidyverse风格指南
- 适当添加注释
- 函数命名清晰
- 避免硬编码路径

### 版本控制

{r git, eval=FALSE}
# 初始化Git仓库
system("git init")
system("git add .")
system("git commit -m 'Initial commit'")

**.gitignore示例**:
```
*.RData
*.Rhistory
/data/raw/  # 不上传原始数据
```

### 工具生态

**相关工具推荐**:
```markdown
## 相关工具

### 同类工具对比

| 工具 | 优势 | 劣势 | 使用建议 |
|------|------|------|----------|
| [工具1] | | | |
| [工具2] | | | |

### 配套工具

- **[工具A]**: [用途与教程链接]
- **[工具B]**: [用途与教程链接]

### 推荐阅读

- [资源1]
- [资源2]
```

## 写作规范

### 操作导向

- 以"如何做"为主线
- 每步都可直接操作
- 提供可复制的代码
- 说明预期输出

### 路径规范

```r
# ✅ 推荐:相对路径+here包
library(here)
file <- here("data", "file.csv")

# ❌ 避免:绝对路径
file <- "C:/Users/Name/Documents/data/file.csv"

# ❌ 避免:工作目录依赖
setwd("C:/project")  # 可移植性差
```

### 错误处理

- 每个关键步骤提供验证代码
- 列出常见错误及解决方法
- 提供调试技巧

## 完整工作流程

### 步骤1:生成教程

- 提供完整的操作流程
- 至少1个实战案例
- 包含常见问题解答

### 步骤2:三项渲染验证

```bash
quarto render doc/30[number]-[topic].rmd
quarto render doc/index.qmd
quarto render doc/sections/operations.qmd
```

### 步骤3:更新导航

更新`_quarto.yml`、`0001-guide.rmd`、`README.md`。

### 步骤4:提交

```bash
git add doc/30[number]-[topic].rmd ...
git commit -m "新增实用操作教程:[主题]"
git push
```

## 质量检查

- [ ] 是否明确了任务目标?
- [ ] 是否提供了完整的操作流程?
- [ ] 是否包含实战案例?
- [ ] 是否列出了常见错误及解决方法?
- [ ] 是否说明了最佳实践?
- [ ] 路径是否使用相对路径?
- [ ] 代码是否可在不同环境运行?
- [ ] 三项render是否成功?

## 参考模板

- `doc/3001-imports.rmd` - 数据导入教程
- `doc/3003-dplyr-tidyr.rmd` - 数据处理流程
- `doc/3006-reproducible-research.rmd` - 工作流规范

## 主题分类

### 数据导入导出
- CSV/Excel/SPSS/SAS读取
- 数据库连接
- API调用

### 数据清洗
- 缺失值处理
- 重复值处理
- 异常值检测

### 数据转换
- 宽表↔长表
- 字符串处理
- 日期时间处理
- 因子处理

### 文档工具
- RMarkdown/Quarto
- LaTeX集成
- 参考文献管理

### 开发环境
- RStudio/Positron配置
- R包开发
- Git版本控制

## 常见问题

**Q: 如何确定教程深度?**

A: 基础操作要详尽(适合新手),进阶技巧简洁(给出方向和示例)。

**Q: 是否需要提供示例文件?**

A: 优先使用代码生成示例数据,避免外部文件依赖。若必需,说明获取方式。

**Q: 如何处理平台差异?**

A: 优先跨平台方案(如here包处理路径),特殊情况说明各平台的差异。
