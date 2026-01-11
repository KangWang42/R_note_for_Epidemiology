---
description: 'R 语言学习笔记项目：Quarto 网站教程编写规范'
applyTo: '**/*.{rmd,qmd}'
---

# R 语言学习笔记 - 教程编写规范

> 本规范适用于 `doc/` 目录下的所有 `.rmd` 和 `.qmd` 教程文件

---

## 📁 项目结构

```
E:\99 其它\05 R语言\
├── doc/                    # 源文件目录
│   ├── _quarto.yml         # Quarto 配置
│   ├── index.qmd           # 首页
│   ├── styles.css          # 全局样式
│   ├── theme.scss          # 主题变量
│   ├── figure/             # 静态封面图片
│   ├── sections/           # 分类页面
│   └── *.rmd               # 教程文件
├── public/                 # 输出目录（部署到 Vercel）
├── deploy.bat              # 全量部署脚本
└── deploy_new.bat          # 增量部署脚本
```

---

## 📄 教程文件规范

### YAML 头部（必须）

```yaml
---
title: "教程标题"
date: "YYYY-MM-DD"
categories: [分类1, 分类2]
image: "figure/xxx-cover.png"  # 封面图片
---
```

**封面图片规则：**
- 有 ggplot 输出的教程：使用文章中的代表性图片作为封面
- 无图片的教程：使用 `figure/default-cover.png` 或分类默认封面
- 封面图片统一放在 `doc/figure/` 目录

### Setup 代码块（必须）

```r
```{r setup, include=FALSE}
knitr::opts_chunk$set(
  echo = TRUE,
  warning = FALSE,
  message = FALSE,
  fig.width = 8,
  fig.height = 5,
  fig.retina = 2,
  out.width = "100%",
  dpi = 150
)
```
```

### 图片尺寸规范

| 图表类型 | fig.width | fig.height | 说明 |
|---------|-----------|------------|------|
| 单图 | 8 | 5 | 默认尺寸 |
| 宽图（多分面） | 10 | 5 | 横向分面 |
| 高图（纵向分面） | 8 | 8 | 纵向分面 |
| 组合图 | 10 | 6 | patchwork 拼接 |

### 文件命名

| 分类 | 前缀 | 示例 |
|------|------|------|
| 实用 R 包 | `1xxx-` | `1011-rpac_brucer.rmd` |
| R 语言方法 | `1xxx-` | `1015-health-economics.rmd` |
| 可视化教程 | `2xxx-` | `2017-ggtext.rmd` |
| 实用操作 | `3xxx-` | `3001-imports.rmd` |
| 其他 | `0xxx-` | `0011-rmarkdown.rmd` |

---

## 📦 包使用规范

### 优先使用的包

| 用途 | 推荐包 | 说明 |
|------|--------|------|
| 数据处理 | `dplyr`, `tidyr` | tidyverse 核心 |
| 可视化 | `ggplot2`, `tidyplots` | 优先 tidyplots 简化代码 |
| 配色 | `ggsci` | 期刊级配色 |
| 文本 | `ggtext` | 富文本和中英文混合 |
| 拼图 | `patchwork` | 多图组合 |
| 表格 | `gt`, `kableExtra` | 美观表格 |

### 包依赖处理

**渲染前确保包已安装！** 如果包可能未安装，使用条件加载：

```r
# 可选包的条件加载
if (requireNamespace("ggnewscale", quietly = TRUE)) {
  library(ggnewscale)
}
```

### tidyplots 特殊设置

tidyplots 默认 50mm 尺寸会覆盖 knitr 设置，**必须**添加：

```r
library(tidyplots)
tidyplots_options(width = NA, height = NA)
```

### 常见包名注意

- ✅ `tidyplots`（复数）  ❌ ~~tidyplot~~
- ✅ `ggnewscale`  ❌ ~~ggNewscale~~

---

## 🎨 可视化规范

### 配色方案

| 场景 | 推荐函数 |
|------|----------|
| 分类变量（≤5类） | `ggsci::scale_fill_lancet()` |
| 分类变量（>5类） | `ggsci::scale_fill_npg()` |
| 连续变量 | `scale_fill_viridis_c()` |

### 主题设置

- 基础主题：`theme_bw(base_size = 12)` 或 `theme_minimal()`
- tidyplots 自带专业主题，无需额外设置

### 中英文混合字体

```r
labs(title = "<span style='font-family:SimHei'>中文</span> English") +
theme(plot.title = ggtext::element_markdown())
```

---

## 🌐 首页样式规范

### Hero 区域（index.qmd）

首页 Hero 区域使用紧凑布局：
- padding: `2rem 2.5rem`
- 标题字体: `2rem`
- 代码预览宽度: `300px`

### 卡片列表

- 布局：2 列 grid
- 卡片样式：圆角 12px，hover 上移效果
- 封面图高度：180px

### 样式文件

- `styles.css`：全局样式和布局修复
- `theme.scss`：主题变量（颜色、字体等）
- `index.qmd` 内联 `<style>`：Hero 区域专用样式

---

## 🚀 部署规范

### 部署命令

```powershell
# 全量部署（渲染所有文件）
.\deploy.bat

# 增量部署（只渲染指定文件）
.\deploy_new.bat
# 输入: 2017-ggtext.rmd 2018-tidyplots.rmd

# 只部署（不重新渲染）
npx vercel public --prod --yes

# 只渲染首页
cd doc; quarto render index.qmd
```

### 清除缓存重新渲染

```powershell
Remove-Item "doc\*_files" -Recurse -Force
.\deploy.bat
```

### 部署平台

- **Vercel**：自动部署到 Vercel，亚洲有边缘节点，国内访问快
- 首次部署需要登录 Vercel 账号并关联项目

---

## 📝 内容编写规范

### 标题层级

```markdown
# 一级标题（页面标题，由 YAML title 定义）

## 二级标题（主要章节）

### 三级标题（子章节）
```

### 代码块说明

每个代码块前应有简短说明文字。

### 代码风格原则

**教程代码应遵循"最简原则"：**

1. **代码尽可能短** - 删除冗余代码，合并可以合并的操作
2. **注释要清楚** - 关键步骤必须有中文注释说明
3. **最少代码，完整功能** - 用最少的代码实现完整的教学目标（注意是完整的教学，要求尽可能全面）
4. **避免重复** - 相似操作使用函数封装或 `across()` 批量处理
5. **链式操作** - 优先使用管道 `|>` 串联操作，减少中间变量

**示例：**
```r
# ✅ 推荐：简洁清晰
df |> 
  mutate(across(where(is.numeric), scale)) |>  # 标准化所有数值列
  filter(!is.na(target))                        # 删除缺失值

# ❌ 避免：冗长重复
df$col1 <- scale(df$col1)
df$col2 <- scale(df$col2)
df$col3 <- scale(df$col3)
df <- df[!is.na(df$target), ]
```

### 禁止事项

1. ❌ 不要使用 `print()`, `cat()` 输出结果
2. ❌ 不要使用 `for` 循环，使用 `purrr::map_*()` 或 `across()`
3. ❌ 不要使用绝对路径
4. ❌ 不要硬编码 `library()` 未安装的包

---

## ✅ 发布检查清单

- [ ] YAML 头部包含 title, date, categories, image
- [ ] setup 代码块设置正确
- [ ] 所有代码块可正常执行（无报错）
- [ ] 图片显示尺寸合适
- [ ] 无 warning/error 输出
- [ ] 中文显示正常
- [ ] 封面图片存在且路径正确

---

## 🔧 常见问题

### Q: 渲染报错 "不存在叫 xxx 这个名称的程序包"
A: 使用 `install.packages("xxx")` 安装，或用 `requireNamespace()` 条件加载

### Q: tidyplots 图片太小
A: 在 setup 中添加 `tidyplots_options(width = NA, height = NA)`

### Q: 首页封面图片不显示
A: 检查 `image:` 路径是否正确，图片必须是静态文件（非代码生成）

### Q: 部署后样式没更新
A: 清除浏览器缓存，或等待 CDN 刷新（约 1-2 分钟）
