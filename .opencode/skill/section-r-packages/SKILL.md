---
name: section-r-packages
description: 生成"实用R包"类页面的超详细教程内容。触发条件:(1)用户要求编写R包使用教程、功能评测、实践指南;(2)用户需要介绍tidyverse、data.table、mlr3等R包;(3)用户提到包的核心功能、使用场景、性能对比;(4)涉及表格制作(gtsummary/gt)、数据处理(dplyr/tidyr)、模型工具(broom)等包。生成完整的R包教程,强调"包定位→核心功能→完整示例→最佳实践",提供最小示例和进阶用法,确保实用性和可复现性。
---

## 核心任务

生成R包使用教程(.rmd/.qmd),涵盖包背景、核心功能、实战示例、性能优化。

## 必备内容结构

### YAML头部与setup代码块

```yaml
---
title: '[包名] - [核心功能简述]'
date: 'YYYY-MM-DD'
categories:
- 实用 R 包
- [具体分类]
image: images/[topic]-cover.svg
description: 一句话概括包的用途
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
## 包简介  # ✅ 一级标题,会出现在目录中
### 核心特点  # ✅ 二级标题,不会出现在目录中但有层次结构
```

**错误示例**:
```markdown
### 包简介  # ❌ 只用三级标题,目录不会生成
#### 核心特点  # ❌ 层次混乱
```

### 包简介与定位

**必须包含对比表格**:
```markdown
## 包简介

[包名]是用于[解决什么问题]的R包。

**核心特点**
- [特点1]
- [特点2]

**与相关包的对比**

| 包名 | 适用场景 | 优点 | 缺点 | 性能 |
|------|---------|------|------|------|
| [本包] | | | | |
| [竞品1] | | | | |
| [竞品2] | | | | |
```

### 安装与加载

```markdown
## 安装

{r install, eval=FALSE}
# CRAN安装
install.packages("[包名]")

# 开发版安装(如适用)
# remotes::install_github("作者/包名")

# 依赖包(如需要)
install.packages(c("dep1", "dep2"))

**版本要求**
- R >= 4.0
- [其他依赖说明]

## 加载

{r load}
library([包名])
library(tidyverse) # 辅助包
```

### 核心功能清单

**表格形式列出主要函数**:
```markdown
## 核心功能

| 函数名 | 功能 | 输入 | 输出 | 常用场景 |
|-------|------|------|------|----------|
| `func1()` | [功能] | [输入类型] | [输出类型] | [何时使用] |
| `func2()` | [功能] | [输入类型] | [输出类型] | [何时使用] |
```

### 快速开始(最小示例)

**5分钟能运行的最简示例**:
```markdown
## 快速开始

最简单的使用示例:

{r quick-start}
# 使用内置数据
data(iris)

# 最基本用法
result <- package::function(iris, key_param = value)

result
```

**说明**:
- 为什么这个例子能代表包的核心功能
- 输出结果的含义
- 下一步可以做什么
```

### 完整工作流程

**实战导向的完整示例**:
```markdown
## 完整示例

### 场景:[真实应用场景描述]

#### 步骤1:数据准备

{r data-prep}
# 读取或构造数据
data <- ...

# 数据检查
str(data)
head(data)

#### 步骤2:[关键操作]

{r step2}
# 核心功能调用
output <- package::function(
  data,
  param1 = value1,  # 参数含义
  param2 = value2   # 参数含义
)

**参数详解**:
- `param1`: [含义、取值范围、默认值]
- `param2`: [含义、取值范围、默认值]

#### 步骤3:[结果处理]

{r result}
# 提取结果
summary(output)

# 可视化(如适用)
plot(output)
```

### 高级用法

**进阶功能展示**:
```markdown
## 高级功能

### 功能1:[高级特性名称]

[为什么需要这个功能]

{r advanced-1}
# 代码示例

### 功能2:[另一高级特性]

{r advanced-2}
# 代码示例

### 与其他包的配合

{r integration}
# 与tidyverse配合
data %>%
  package::func1() %>%
  dplyr::filter(...)
```

### 性能与最佳实践

```markdown
## 性能优化

### 性能对比

{r benchmark, eval=FALSE}
library(microbenchmark)

microbenchmark(
  method1 = package1::func(data),
  method2 = package2::func(data),
  times = 100
)

**结论**: [包名]在[场景]下比[竞品]快X倍。

### 最佳实践

- **数据规模**: [适合多大数据量]
- **内存使用**: [内存占用特点]
- **并行计算**: [是否支持并行]
- **常用技巧**: 
  - [技巧1]
  - [技巧2]
```

### 常见错误与排查

```markdown
## 常见问题

| 错误信息 | 原因 | 解决方法 |
|---------|------|----------|
| Error: ... | [原因分析] | [具体步骤] |
| Warning: ... | [原因分析] | [具体步骤] |

### 调试技巧

- [技巧1]
- [技巧2]
```

### 扩展阅读

```markdown
## 相关资源

- **官方文档**: [链接]
- **Vignettes**: [主要vignette列表]
- **相关包**: 
  - [包名1]: [用途]
  - [包名2]: [用途]
- **推荐阅读**: [文章/书籍]
```

### 封面图生成(MANDATORY)

**CRITICAL**: 每篇教程必须有封面图,路径必须与YAML中的`image`字段匹配。

**方法1: 使用SVG(推荐)**

在`doc/images/`目录创建SVG文件:

```r
# 示例:创建简单的主题封面
library(ggplot2)

cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, 
           label = "[包名]", 
           size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, 
           label = "R Package Tutorial", 
           size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))

ggsave("doc/images/[topic]-cover.svg", cover, 
       width = 8, height = 4.5, bg = "white")
```

**方法2: 使用ggplot2生成主题封面**

```r
library(ggplot2)
library(ggsci)

# 创建主题相关的可视化作为封面
cover_plot <- ggplot(...) +
  geom_[relevant_geom]() +
  scale_fill_lancet() +
  theme_minimal(base_size = 14) +
  labs(title = "[包名]教程")

ggsave("doc/images/[topic]-cover.svg", cover_plot,
       width = 8, height = 4.5, dpi = 300)
```

**CRITICAL CHECKS**:
- [ ] 封面图文件存在于`doc/images/`目录
- [ ] YAML中`image: images/[topic]-cover.svg`路径正确
- [ ] 文件名与YAML中的路径完全匹配
- [ ] 图片清晰、主题相关、视觉美观

## 写作规范

### 示例优先

- 每个功能都要有可运行的代码示例
- 示例要简洁但完整
- 优先使用内置数据集(iris, mtcars等)

### 函数使用规范

```r
# 包内函数明确使用::
package::function()

# 仅演示该包功能时可library()
library(package)
function1()
function2()

# 辅助包用::
dplyr::filter()
ggplot2::ggplot()
```

### 参数说明

**每个重要参数都要解释**:
```r
function(
  data,              # 数据框
  method = "auto",   # 方法:"auto"/"manual",默认自动
  n_iter = 100,      # 迭代次数,范围:10-1000
  verbose = TRUE     # 是否打印进度
)
```

## 完整工作流程

### 步骤1:生成教程

- 按上述结构生成.rmd文件
- 确保至少2个示例(简单+复杂)
- 包含性能对比(如适用)

### 步骤2:三项渲染验证

```bash
quarto render doc/[number]-[package].rmd
quarto render doc/index.qmd
quarto render doc/sections/r-packages.qmd
```

### 步骤3:更新导航

更新`_quarto.yml`、`0001-guide.rmd`、`README.md`。

### 步骤4:提交

```bash
git add doc/[number]-[package].rmd ...
git commit -m "新增R包教程:[包名]"
git push
```

## 质量检查

- [ ] 是否明确了包的定位和适用场景?
- [ ] 是否提供了最小可运行示例?
- [ ] 是否包含完整的实战流程?
- [ ] 是否说明了关键参数含义?
- [ ] 是否提供了性能对比(如适用)?
- [ ] 代码是否可复现?
- [ ] 三项render是否成功?

## 参考模板

- `doc/3002-datatable.rmd` - 完整的包教程示范
- `doc/1043-broom.rmd` - 简洁的功能介绍

## 常见问题

**Q: 如何平衡简洁与完整?**

A: 最小示例保持5-10行代码,完整示例分步骤详解,高级功能单独章节。

**Q: 是否需要性能测试?**

A: 如果包的卖点是性能(如data.table),必须包含benchmark;否则可选。

**Q: 如何选择示例数据?**

A: 优先顺序:内置数据集 > 包自带数据 > 简单模拟数据。避免外部文件依赖。
