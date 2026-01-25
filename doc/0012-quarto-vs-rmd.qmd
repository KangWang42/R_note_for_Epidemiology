---
title: Quarto vs RMarkdown 对比
date: '2026-01-11'
categories:
- 实用操作
- 文档写作
- 入门
- 工具
description: Quarto 和 RMarkdown 的功能对比，帮助你选择合适的文档工具
image: figure/quarto-vs-rmd.svg
---

## 概述

Quarto 是 RMarkdown 的下一代版本，由 Posit（原 RStudio）开发。两者都用于创建可重复的文档，但 Quarto 提供了更多现代特性。

## 核心区别

| 特性 | RMarkdown | Quarto |
|------|-----------|--------|
| 文件扩展名 | `.Rmd` | `.qmd` |
| 语言支持 | 主要是 R | R、Python、Julia、Observable |
| 依赖 | 需要 R 和 knitr | 独立命令行工具 |
| 配置语法 | YAML + R 代码块选项 | 统一的 YAML 语法 |
| 输出格式 | 通过 R 包 | 内置支持 |

## 语法对比

### 代码块选项

**RMarkdown 方式：** 选项写在花括号内

```
代码块头: {r myplot, echo=TRUE, fig.width=8}
```

**Quarto 方式：** 使用 #| 注释语法

```
代码块头: {r}
#| label: myplot
#| echo: true
#| fig-width: 8
```

Quarto 的 `#|` 语法更清晰，且支持代码补全。

### 交叉引用

| 功能 | RMarkdown | Quarto |
|------|-----------|--------|
| 图片引用 | `\@ref(fig:myplot)` | `@fig-myplot` |
| 表格引用 | `\@ref(tab:mytable)` | `@tbl-mytable` |
| 依赖 | 需要 bookdown 包 | 内置支持 |

### 条件内容

Quarto 原生支持按输出格式显示不同内容：

- `::: {.content-visible when-format="html"}` 仅 HTML 显示
- `::: {.content-visible when-format="pdf"}` 仅 PDF 显示

## Quarto 的优势

### 1. 多语言支持

在同一文档中可混合使用 R、Python、Julia、Observable JS。

### 2. 更好的项目支持

通过 `_quarto.yml` 统一配置整个项目，支持网站、书籍、博客等多种项目类型。

### 3. 内置幻灯片

原生支持 Revealjs 幻灯片，只需设置 `format: revealjs`。

### 4. 扩展系统

可通过 `quarto add` 安装扩展，添加新格式、过滤器和短代码。

## RMarkdown 的优势

1. **生态成熟**：大量现有模板和包
2. **R 深度集成**：与 R 包系统无缝配合
3. **学习资料丰富**：教程和文档更多

## 迁移建议

### 从 RMarkdown 迁移到 Quarto

1. 将 `.Rmd` 重命名为 `.qmd`（大多数情况下直接可用）
2. 更新代码块选项为 `#|` 语法
3. 更新 YAML 头部：`output: html_document` → `format: html`

### YAML 头部对比

| RMarkdown | Quarto |
|-----------|--------|
| `output: html_document` | `format: html` |
| `toc: true` | `toc: true` |
| `toc_float: true` | `toc-location: left` |
| `code_folding: show` | `code-fold: show` |

## 选择建议

| 场景 | 推荐 |
|------|------|
| 新项目 | Quarto |
| 纯 R 项目 | 两者皆可 |
| 多语言项目 | Quarto |
| 已有 RMarkdown 项目 | 继续使用，有需要再迁移 |
| 需要特定 R 包功能 | RMarkdown |
| 网站/书籍项目 | Quarto |

## 总结

Quarto 是 RMarkdown 的现代继承者，提供：

- 统一的跨语言体验
- 更清晰的语法
- 内置丰富功能
- 活跃的开发和社区

对于新项目，推荐使用 Quarto。现有 RMarkdown 项目可以按需逐步迁移。

## 参考资源

- [Quarto 官方文档](https://quarto.org/)
- [RMarkdown 官方文档](https://rmarkdown.rstudio.com/)
- [从 RMarkdown 迁移到 Quarto](https://quarto.org/docs/faq/rmarkdown.html)
