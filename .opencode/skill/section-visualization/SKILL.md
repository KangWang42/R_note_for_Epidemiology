---
name: section-visualization
description: 生成"数据可视化"类页面的超详细教程内容。触发条件:(1)用户要求编写ggplot2图表教程、可视化方法、绘图美化指南;(2)涉及"20xx"编号的可视化文章;(3)用户需要绘制箱线图、散点图、热图、森林图、桑基图等图表;(4)用户提到图表美化、配色方案、主题定制、图形组合;(5)用户要求生成出版级图表。生成完整的可视化教程,强调"图表用途→数据准备→绘图流程→美化技巧→解读说明",提供基础版和进阶版示例,确保图文并茂。
---

## 核心任务

生成数据可视化类教程(.rmd/.qmd),涵盖图表原理、绘图代码、样式美化、结果解读。

## 必备内容结构(按顺序)

### YAML头部与setup代码块

```yaml
---
title: '[图表类型]完全指南'
date: 'YYYY-MM-DD'
categories:
- 数据可视化
- [具体分类:分布图/关系图/比较图等]
image: images/[topic]-cover.svg
description: 一句话概括图表用途
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
## 简介  # ✅ 一级标题,会出现在目录中
### 适用场景  # ✅ 二级标题,不会出现在目录中但有层次结构
```

**错误示例**:
```markdown
### 简介  # ❌ 只用三级标题,目录不会生成
#### 适用场景  # ❌ 层次混乱
```

### 图表简介与适用场景

**必须包含对比表格**:
```markdown
## 简介

[图表名称]是用于[展示什么信息]的可视化方法。

| 图表类型 | 展示信息 | 优点 | 缺点 | 适用场景 |
|---------|---------|------|------|----------|
| [本图表] | | | | |
| [相关图表1] | | | | |
| [相关图表2] | | | | |
```

**说明**:
- 何时使用该图表
- 适合什么类型的数据
- 相比其他图表的优势
- 不适用的情况

### 图形构成解析

**详细解释图表元素**:
- 每个视觉元素代表什么
- 如何读取图表信息
- 常见的编码方式

**示例(箱线图)**:
```markdown
## 箱线图结构解读

- **箱体**: 从Q1(下四分位数)到Q3(上四分位数)
- **中线**: 中位数
- **须(whisker)**: 延伸到1.5×IQR范围内的最远点
- **点**: 异常值(超出须范围)

[配图示意]
```

### 数据准备

**说明数据结构要求**:
- 变量类型(数值/分类)
- 数据格式(宽表/长表)
- 必要的预处理步骤

**提供示例数据**:
```r
# 使用内置数据集或构造简单示例
library(ggplot2)
data(iris)  # 或其他合适数据

# 数据结构检查
str(iris)
head(iris)
```

### 基础图表绘制

**从最简单版本开始**:

```markdown
## 基础版本

### 最简单的[图表名]

[简要说明]

{r basic-plot}
ggplot(data, aes(x = var1, y = var2)) +
  geom_[type]() +
  labs(title = "标题")

[代码逐行解释]
- `ggplot()`: 初始化图形对象
- `aes()`: 映射变量到视觉元素
- `geom_[type]()`: 添加几何对象
- `labs()`: 设置标签
```

**解释核心函数**:
- 主要geom_*函数
- 关键参数含义
- 常用映射(x, y, fill, color, size等)

### 样式美化与定制

**分层次展示美化技巧**:

#### 6.1 填充颜色
```markdown
### 按组填色

{r color-by-group}
ggplot(..., aes(fill = group)) +
  geom_[type]() +
  scale_fill_brewer(palette = "Set2")

**配色选择**:
- `scale_fill_brewer()`: ColorBrewer配色
- `scale_fill_manual()`: 自定义颜色
- `scale_fill_lancet()`: 期刊配色(ggsci)
```

#### 6.2 主题设置
```markdown
### 主题美化

{r theme-custom}
ggplot(...) +
  geom_[type]() +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold")
  )

**常用主题**:
- `theme_minimal()`: 极简风格
- `theme_bw()`: 黑白主题
- `theme_classic()`: 经典主题
```

#### 6.3 坐标轴调整
```markdown
### 坐标轴定制

{r axis-custom}
ggplot(...) +
  geom_[type]() +
  scale_x_continuous(breaks = seq(0, 10, 2)) +
  scale_y_continuous(limits = c(0, 100)) +
  coord_flip()  # 翻转坐标
```

### 进阶技巧

**展示高级用法**:

#### 7.1 添加统计信息
```markdown
### 添加统计元素

{r add-statistics}
ggplot(...) +
  geom_[type]() +
  stat_summary(fun = mean, geom = "point", color = "red") +
  geom_text(aes(label = n), position = position_dodge(0.9))
```

#### 7.2 分面显示
```markdown
### 分面图

{r facet-plot}
ggplot(...) +
  geom_[type]() +
  facet_wrap(~category) +
  # 或 facet_grid(row ~ col)
```

#### 7.3 组合图表
```markdown
### 图形组合

{r combine-plots}
library(patchwork)
p1 + p2 + p3 +
  plot_layout(ncol = 2)
```

### 实战案例

**提供完整的实战示例**:
- 真实场景描述
- 数据准备
- 完整绘图代码
- 详细解释
- 最终效果图

### 常见错误与解决

**列出5-10个常见问题**:

```markdown
## 常见错误

| 错误类型 | 表现 | 原因 | 解决方法 |
|---------|------|------|----------|
| 图例重叠 | 图例遮挡数据 | 默认位置不当 | `theme(legend.position = "bottom")` |
| 标签重叠 | 文字互相覆盖 | 数据点过多 | 使用`ggrepel::geom_text_repel()` |
| 颜色不当 | 不易区分/色盲不友好 | 配色方案选择 | 使用viridis或ggsci包 |
| 比例误导 | Y轴不从0开始 | 坐标轴范围设置 | `scale_y_continuous(limits = c(0, NA))` |
```

### 输出与保存

**说明如何保存图片**:
```r
# 保存高质量图片
ggsave(
  filename = "figure/plot-name.png",
  width = 8, 
  height = 6,
  dpi = 300,
  bg = "white"
)

# SVG格式(矢量图)
ggsave("figure/plot-name.svg", width = 8, height = 6)
```

### 进阶扩展

**提供**:
- 交互式图表(plotly)
- 动画图表(gganimate)
- 相关图表类型链接
- 推荐资源

### 封面图生成(MANDATORY)

**CRITICAL**: 每篇教程必须有封面图,路径必须与YAML中的`image`字段匹配。

**方法1: 使用SVG(推荐)**

在`doc/images/`目录创建SVG文件:

```r
# 示例:创建简单的主题封面
library(ggplot2)

cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, 
           label = "[图表类型]", 
           size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, 
           label = "Data Visualization Guide", 
           size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))

ggsave("doc/images/[topic]-cover.svg", cover, 
       width = 8, height = 4.5, bg = "white")
```

**方法2: 使用图表类型本身作为封面**

```r
library(ggplot2)
library(ggsci)

# 创建该图表类型的精美示例作为封面
cover_plot <- ggplot(iris, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_boxplot(alpha = 0.8) +
  scale_fill_lancet() +
  theme_minimal(base_size = 14) +
  labs(title = "[图表类型]完全指南",
       subtitle = "Professional Data Visualization") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))

ggsave("doc/images/[topic]-cover.svg", cover_plot,
       width = 8, height = 4.5, dpi = 300, bg = "white")
```

**CRITICAL CHECKS**:
- [ ] 封面图文件存在于`doc/images/`目录
- [ ] YAML中`image: images/[topic]-cover.svg`路径正确
- [ ] 文件名与YAML中的路径完全匹配
- [ ] 图片清晰、主题相关、视觉美观
- [ ] 封面图展示了该图表类型的特点

## 写作规范

### 图文比例

- **目标:每个代码块都有对应的图表输出**
- 每张图必须有文字解释
- 解释包含:图表含义、关键发现、如何读取

### 代码规范

**渐进式展示**:
```r
# 第一步:基础图
p1 <- ggplot(data, aes(x, y)) + geom_point()

# 第二步:添加颜色
p2 <- p1 + aes(color = group)

# 第三步:美化主题
p3 <- p2 + theme_minimal()
```

**chunk命名**:
```r
{r basic-scatter}       # 基础散点图
{r scatter-color}       # 添加颜色
{r scatter-theme}       # 主题美化
{r scatter-final}       # 最终版本
```

### 配色规范

**优先使用**:
- ggsci包的期刊配色:`scale_fill_lancet()`, `scale_fill_nejm()`
- ColorBrewer: `scale_fill_brewer(palette = "Set2")`
- viridis(色盲友好): `scale_fill_viridis_d()`

**说明配色选择理由**:
```r
scale_fill_lancet() # 柳叶刀期刊风格,适合出版
scale_fill_viridis_d() # 色盲友好,感知均匀
```

### 图表注释

**每张图都要包含**:
- 标题(`title`)
- 坐标轴标签(`x`, `y`)
- 图例标题(`fill`, `color`)
- 必要时添加副标题(`subtitle`)和说明(`caption`)

## 完整工作流程

### 步骤1:生成教程内容

按上述结构生成.rmd/.qmd文件,确保:
- 至少3个图表示例(基础→中级→高级)
- 每个示例都有完整代码和输出
- 包含对比表格和参数说明

### 步骤2:三项渲染验证

```bash
quarto render doc/20[number]-[topic].rmd
quarto render doc/index.qmd
quarto render doc/sections/visualization.qmd
```

**确保图片生成**:
- 检查`doc/figure/`目录下是否有图片
- 图片是否清晰
- 中文是否正常显示

### 步骤3:更新导航

**更新`doc/_quarto.yml`**:
在visualization分类下添加新文章。

**更新`doc/0001-guide.rmd`**:
在数据可视化表格中添加条目。

**更新`README.md`**:
在可视化折叠块添加链接(.html后缀)。

### 步骤4:提交

```bash
git add doc/20[number]-[topic].rmd doc/figure/ doc/_quarto.yml doc/0001-guide.rmd README.md
git commit -m "新增可视化教程:[图表类型]"
git push
```

## 质量检查清单

生成前确认:

- [ ] 是否明确了图表类型和适用场景?
- [ ] 是否提供了数据结构说明?
- [ ] 是否包含基础版和进阶版示例?
- [ ] 是否说明了配色选择理由?

生成后验证:

- [ ] 每个代码块是否都生成了图片?
- [ ] 图片是否清晰美观?
- [ ] 中文标签是否正常显示?
- [ ] 配色是否合理(色盲友好)?
- [ ] 是否提供了保存图片的代码?
- [ ] 三项render是否成功?

## 参考优质模板

- `doc/2025-bindboxplot.rmd` - 完整的图表教程示范
- `doc/2020-heatmap.rmd` - 复杂图表的详细讲解
- `doc/2016-forestplot.rmd` - 专业图表的制作流程

## 图表分类参考

### 分布图
- 箱线图、小提琴图、直方图、密度图

### 关系图
- 散点图、气泡图、相关性矩阵

### 比较图
- 柱状图、棒棒糖图、发散图、哑铃图

### 趋势图
- 折线图、面积图、时间序列图

### 组成图
- 饼图、堆叠柱状图、华夫饼图、桑基图

### 专业图表
- 森林图、漏斗图、雷达图、韦恩图、热图、网络图

## 常见问题

**Q: 如何确定图表类型?**

A: 根据数据类型和展示目标:
- 分布→箱线图/直方图
- 关系→散点图/相关图
- 比较→柱状图/热图
- 趋势→折线图/面积图
- 组成→饼图/堆叠图

**Q: 配色方案如何选择?**

A: 优先顺序:
1. 期刊要求配色(如投稿NEJM用`scale_fill_nejm()`)
2. 色盲友好配色(viridis)
3. 分类变量用离散色(Set2/Set3)
4. 连续变量用渐变色(viridis/RdYlBu)

**Q: 如何避免图表过于复杂?**

A: 遵循"少即是多"原则:
- 一图一主题
- 避免3D效果
- 限制颜色数量(<7种)
- 去除网格线(可选)
- 简化图例

**Q: 用户需求不明确怎么办?**

A: 澄清:图表类型、数据结构、展示目的、目标期刊/会议、是否需要组合图。
