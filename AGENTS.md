# AGENTS Instructions for R 语言学习笔记

## Scope
- Applies to the whole repository unless a deeper AGENTS.md exists.
- This repo is a Quarto website with source files in `doc/` and outputs in `public/`.
- Edit source files only; never manually edit generated content under `public/`.

## Repository Layout
```
├── doc/                    # Quarto source files
│   ├── _quarto.yml         # Site config (output → ../public)
│   ├── index.qmd           # Homepage
│   ├── *.rmd / *.qmd       # Tutorial articles
│   ├── sections/           # Auto-generated category pages
│   ├── generate_sections.R # Pre-render script
│   ├── images/             # Static media
│   └── figure/             # Generated figures
├── public/                 # Built website output (do not edit)
├── .github/workflows/      # CI/CD: deploys public/ on push to main
└── AGENTS.md               # This file
```

## Build / Preview / Render Commands

```bash
# Preview site (with hot reload)
quarto preview doc

# From doc/ directory
cd doc && quarto preview

# Render entire site
quarto render doc

# Render single article (preferred for testing changes)
quarto render doc/1014-purrr.rmd
quarto render doc/0013-positron.qmd

# Render section page
quarto render doc/sections/guide.qmd

# Clean build (only if explicitly requested)
rm -rf public && quarto render doc
```

## Testing / Validation

- **No formal test suite** - validation is via successful rendering.
- **Validate changes** by rendering the specific file you modified.
- Check for R package errors; install missing packages and document them below.
- Skim HTML output for layout issues, broken links, and warning messages.

### Installed R Dependencies (from past sessions)
rpart.plot, stacks, Rtsne, uwot, isotree, dbscan, baguette, tidytable, DoubleML, clusterGeneration, readstata13, mlr3learners, paradox, DiceKriging, grf, EpiModel, igraph, network, sna, statnet.common, tergm, intergraph

## Tooling Prerequisites

- **R**: ≥ 4.3 required
- **Quarto**: ≥ 1.4 required
- R packages are article-specific; install as needed per tutorial content.
- No `renv` lockfile; packages are managed ad-hoc.

## Code Style: R

### Formatting
- **Indentation**: 2 spaces, no tabs
- **Line width**: ~80 characters where reasonable
- **Naming**: `snake_case` for variables and functions
- **Pipes**: Prefer native `|>`, accept `%>%` in existing code

### Imports
- Use `library()` only when multiple functions from a package are used.
- Prefer `pkg::fn()` for one-off calls.
- Never load unused packages.
- Keep `library()` calls at the top of chunks.

```r
# Good: explicit namespace for one-off use
result <- dplyr::filter(data, x > 0)

# Good: library() when using many functions
library(ggplot2)
ggplot(data, aes(x, y)) + geom_point() + theme_minimal()

# Bad: loading package for single function
library(scales)
comma(1000)  # Use scales::comma(1000) instead
```

### Functions
- Use explicit, descriptive names; avoid single-letter variables.
- Validate inputs in reusable functions (types, ranges, missing values).
- Use informative error messages with `stop()`.

```r
# Good
calculate_bmi <- function(weight_kg, height_m) {
  if (!is.numeric(weight_kg) || !is.numeric(height_m)) {
    stop("weight_kg and height_m must be numeric")
  }
  weight_kg / height_m^2
}
```

## Quarto / RMarkdown Conventions

### YAML Header Template
```yaml
---
title: 'Title: 中文副标题'
date: '2024-10-20'
categories:
- 实用 R 包
- 数据处理
image: figure/default-cover1.png
---
```

### Chunk Setup Pattern
```r
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
set.seed(42)  # For reproducibility when needed
```

### Chunk Guidelines
- Use clear, unique chunk labels.
- Set `echo`, `message`, `warning` deliberately.
- Use `set.seed()` for any stochastic output.
- Use `include = FALSE` or `echo = FALSE` when output is not needed.
- Avoid hard-coded absolute paths; use relative paths from `doc/`.

## Naming and Content Rules

### File Naming Convention
```
[Section][Number]-[topic].rmd

Sections:
  00xx = 入门指南 (Guide)
  10xx = 统计分析方法 (Statistics)
  20xx = 数据可视化 (Visualization)
  30xx = 实用操作 (Operations)
  40xx = 应用开发 (Applications)

Examples:
  0011-rmarkdown.rmd
  1014-purrr.rmd
  2025-bindboxplot.rmd
  3002-datatable.rmd
```

### Content Guidelines
- Keep headings in Chinese, consistent with existing style.
- Ensure examples are reproducible and minimal.
- Prefer vectorized operations over explicit loops.
- Use consistent terminology between text and code.

## Generated Output

- **Never edit `public/` manually** - it is auto-generated.
- Regenerate with `quarto render doc` when needed.
- `_freeze` behavior: `execute.freeze: auto` (in `_quarto.yml`).
- Sections are auto-generated via `doc/generate_sections.R` (pre-render).

## Git Hygiene

- Scope commits to source files under `doc/`.
- Avoid committing large generated assets unless required.
- If `public/` changes, ensure it resulted from a render.
- Do not push to `main` without successful local render.

## Validation Checklist

Before committing changes:
1. [ ] Render the changed file: `quarto render doc/<file>`
2. [ ] Check for R errors or missing packages in console output
3. [ ] Skim HTML output for layout issues
4. [ ] Verify images and internal links resolve correctly
5. [ ] If adding new article, update `doc/_quarto.yml` sidebar
6. [ ] If adding new article, update `doc/0001-guide.rmd` to keep guide in sync

## Notes for Agentic Edits

- Prefer targeted edits using existing patterns.
- Minimize changes to unrelated sections.
- Ask before making structural changes to navigation or sections.
- When uncertain about Chinese terminology, maintain existing usage.
- For new tutorials, copy structure from similar existing `.rmd` files.

## Skill Auto-Load Rules

Load these skills based on task type:

| Task Type | Skill to Load |
|-----------|---------------|
| 入门指南/学习路线/基础知识 | `section-intro-guide` |
| 实用 R 包教程/评测/实践 | `section-r-packages` |
| 统计分析方法 | `section-statistics` |
| 机器学习/深度学习/AI | `section-ml-ai` |
| 数据导入/清洗/转换/开发环境 | `section-operations` |
| 数据可视化/图形设计/绘图美化 | `section-visualization` |
| 卫生经济学/质性研究/信号处理 | `section-special` |

## Automatic Skill Recognition (CRITICAL for New Sessions)

**RULE**: When user requests to generate tutorial content, the assistant MUST:

1. **Identify task type** from user request using keywords
2. **Automatically load appropriate skill** by calling `skill(name="...")` before starting work
3. **Follow skill guidelines** strictly for content structure and workflow

### Keyword Mapping for Auto-Detection

| Request Keywords | Skill to Load |
|-----------------|---------------|
| 回归、生存分析、因果推断、贝叶斯、Meta、德尔菲、PSM、Cox、SEM、PCA、LCA、10xx | `section-statistics` |
| R包、tidyverse、dplyr、ggplot2、purrr、data.table、mlr3、实用包 | `section-r-packages` |
| 可视化、绘图、图表、图形、ggplot2、箱线图、散点图、热图、20xx | `section-visualization` |
| 入门、学习路线、基础、新手、指南、00xx | `section-intro-guide` |
| 机器学习、深度学习、AI、预测、分类、聚类、xgboost、torch | `section-ml-ai` |
| 数据导入、清洗、转换、正则、字符串、日期、rvest、readxl、30xx | `section-operations` |
| 卫生经济学、质性研究、信号处理、环境流行病学、TreeAge、VMD | `section-special` |

### Workflow for Tutorial Generation

When user asks to generate content:
1. Parse request for keywords
2. Match to appropriate skill from table above
3. Execute: `skill(name="[matched-skill-name]")`
4. Follow skill's structure and guidelines
5. Follow rendering sequence: article → section → index

**EXAMPLE**:
```
User: "生成一个泊松回归教程"
→ Keywords: "泊松回归", "教程"
→ Skill: section-statistics
→ Action: skill(name="section-statistics")
→ Follow section-statistics guidelines to generate content
```

## External Rules

- No `.cursor/rules`, `.cursorrules`, or `.github/copilot-instructions.md` detected.
- If any are added later, incorporate their rules into this file.
