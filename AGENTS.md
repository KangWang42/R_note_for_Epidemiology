# AGENTS Instructions for R 语言学习笔记

## Project Overview

This is a **Quarto-based static website** that serves as a comprehensive learning resource for R language data science, with a focus on:
- Epidemiology and biostatistics
- Statistical analysis methods
- Data visualization
- Machine learning and AI
- Special applications (health economics, qualitative research, signal processing)

**Live Site**: https://r.wk8686.top  
**Repository**: https://github.com/KangWang42/R_note_for_Epidemiology

---

## Technology Stack

| Component | Technology | Version Requirement |
|-----------|------------|---------------------|
| Document Framework | [Quarto](https://quarto.org/) | ≥ 1.4 |
| Programming Language | R | ≥ 4.3 |
| Visualization | ggplot2 + extensions | ≥ 3.6 |
| CI/CD | GitHub Actions | - |
| Deployment | Self-hosted server | - |

---

## Repository Layout

```
├── doc/                          # Quarto source files (EDIT THESE ONLY)
│   ├── _quarto.yml              # Main site configuration (sidebar, navbar, theme)
│   ├── index.qmd                # Homepage with search & listings
│   ├── 0001-guide.rmd           # Learning roadmap page
│   ├── 00xx-*.rmd/qmd           # Guide/intro tutorials
│   ├── 10xx-*.rmd               # Statistics methods tutorials
│   ├── 20xx-*.rmd               # Data visualization tutorials
│   ├── 30xx-*.rmd               # Data operations tutorials
│   ├── 40xx-*.rmd               # Application development
│   ├── 50xx-*.qmd               # AI tools tutorials
│   ├── 60xx-*.rmd               # Special applications
│   ├── sections/                # Auto-generated category pages (DO NOT EDIT)
│   ├── generate_sections.R      # Pre-render script for section pages
│   ├── create_covers.R          # Script for generating cover images
│   ├── update_categories.R      # Script for updating article categories
│   ├── styles.css               # Custom CSS styling
│   ├── theme.scss               # SCSS theme variables
│   ├── include_footer.html      # Footer include template
│   ├── images/                  # Static cover images
│   └── figure/                  # Generated figures from R code
├── public/                       # Built website output (AUTO-GENERATED)
├── .github/workflows/deploy.yml  # CI/CD: Deploy on push to main
├── .gitignore                    # Git ignore rules
└── AGENTS.md                     # This file
```

### File Naming Convention

Articles follow a strict numbering system:

| Range | Category | Description |
|-------|----------|-------------|
| `00xx` | 入门指南 | Getting started, learning roadmap, basics |
| `10xx` | 统计分析方法 | Statistical analysis methods |
| `20xx` | 数据可视化 | Data visualization tutorials |
| `30xx` | 实用操作 | Data operations, imports, cleaning |
| `40xx` | 应用开发 | Application development (Shiny) |
| `50xx` | AI 工具 | AI programming tools documentation |
| `60xx` | 特殊应用 | Special applications |

Example: `1014-purrr.rmd` = Statistics category (#10), #14 in sequence, topic is purrr package.

---

## Build Commands

### Development

```bash
# Preview site with hot reload (run from doc/ directory)
cd doc && quarto preview

# Or from project root
quarto preview doc
```

### Production Build

```bash
# Render entire site (run from doc/ directory)
cd doc && quarto render

# Or from project root
quarto render doc
```

### Single Article Rendering (Preferred for Testing)

```bash
# Render specific article only
quarto render doc/1014-purrr.rmd
quarto render doc/0013-positron.qmd

# Render specific section page
quarto render doc/sections/guide.qmd
```

### Clean Build

```bash
# Remove generated files and rebuild (only if explicitly requested)
rm -rf public && quarto render doc
```

---

## Build Process Architecture

```
quarto render doc/
    │
    ├── [PRE-RENDER] Rscript generate_sections.R
    │       └── Generates sections/*.qmd from _quarto.yml sidebar config
    │
    ├── Renders all *.rmd/*.qmd files to HTML
    │       └── Outputs to public/ directory
    │
    └── [POST-RENDER] Generates search.json for site search
```

### Pre-render Script: `generate_sections.R`

This script automatically generates category index pages from `_quarto.yml` sidebar configuration:
- Reads sidebar structure from `_quarto.yml`
- Generates styled category cards with article links
- Outputs to `doc/sections/*.qmd`
- **Never manually edit** files in `doc/sections/`

---

## Development Workflow

### Adding a New Tutorial

1. **Create file** with proper naming: `[Section][Number]-[topic].rmd`
   - Check existing files to determine next available number

2. **Use YAML template**:
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

3. **Set up R chunk options** at top of document:
   ```r
   ```{r setup, include=FALSE}
   knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
   set.seed(42)  # For reproducibility
   ```
   ```

4. **Add to `_quarto.yml`** sidebar configuration (find appropriate section)

5. **Run pre-render script** to regenerate section pages:
   ```bash
   cd doc && Rscript generate_sections.R
   ```

6. **Update guide page** (`0001-guide.rmd`) to include new tutorial in learning roadmap

7. **Test rendering**:
   ```bash
   quarto render doc/[your-file].rmd
   ```

### Adding Cover Image

Place cover image in appropriate location:
- `doc/images/[basename]-cover.svg` or
- `doc/figure/[basename]-cover.png`

Then reference in YAML: `image: images/[basename]-cover.svg`

---

## Code Style Guidelines

### R Code Style

- **Indentation**: 2 spaces, no tabs
- **Line width**: ~80 characters where reasonable
- **Naming**: `snake_case` for variables and functions
- **Pipes**: Prefer native `|>`, accept `%>%` in existing code

### Import Guidelines

```r
# Good: Explicit namespace for one-off use
result <- dplyr::filter(data, x > 0)

# Good: library() when using many functions from same package
library(ggplot2)
ggplot(data, aes(x, y)) + geom_point() + theme_minimal()

# Bad: Loading package for single function
library(scales)
comma(1000)  # Use scales::comma(1000) instead
```

### Function Writing

```r
# Good
calculate_bmi <- function(weight_kg, height_m) {
  if (!is.numeric(weight_kg) || !is.numeric(height_m)) {
    stop("weight_kg and height_m must be numeric")
  }
  weight_kg / height_m^2
}
```

---

## Testing & Validation

This project has **no formal test suite**. Validation is via successful rendering.

### Validation Checklist (Before Committing)

- [ ] Render the changed file: `quarto render doc/<file>`
- [ ] Check for R errors or missing packages in console output
- [ ] Skim HTML output for layout issues
- [ ] Verify images and internal links resolve correctly
- [ ] If adding new article, update `doc/_quarto.yml` sidebar
- [ ] If adding new article, update `doc/0001-guide.rmd` to keep guide in sync
- [ ] Run `Rscript generate_sections.R` if sidebar structure changed

### Common Rendering Issues

| Issue | Solution |
|-------|----------|
| Missing R package | Install with `install.packages("pkg")` |
| Cache issues | Delete `doc/*_cache/` directories |
| YAML syntax error | Validate indentation (spaces, not tabs) |
| Image not found | Check relative path from `doc/` directory |

---

## Deployment Process

### Automatic Deployment (GitHub Actions)

```yaml
# .github/workflows/deploy.yml
Trigger: Push to main branch with changes in public/**
Steps:
  1. Checkout code
  2. Setup SSH
  3. rsync public/ to server
  4. Set file permissions
```

**Deployment secrets** (configured in GitHub):
- `SERVER_SSH_KEY`: SSH private key for server access
- `SERVER_HOST`: Server IP/hostname
- `SERVER_USER`: SSH username
- `SERVER_PATH`: Deployment directory on server

### Manual Deployment

For local testing, you can serve `public/` directory with any static server:
```bash
cd public && python -m http.server 8000
```

---

## Git Hygiene

- **Scope commits** to source files under `doc/`
- **Avoid committing** large generated assets unless required
- **Never manually edit** `public/` - it is auto-generated
- **Never manually edit** `doc/sections/*.qmd` - auto-generated by `generate_sections.R`
- **Clean build artifacts** before commit if necessary:
  ```bash
  # Remove generated HTML/cache from doc/
  git clean -fd doc/*.html doc/*_files/ doc/*_cache/
  ```

---

## Content Organization Reference

### Main Categories (from `_quarto.yml`)

1. **入门指南** (Getting Started)
   - 学习路线 (Learning Path)
   - 基础知识 (Fundamentals)
   - 工作流程 (Workflow)

2. **实用 R 包** (R Packages)
   - 表格制作 (Table Generation)
   - 数据处理 (Data Processing)
   - 模型整理 (Model Tidying)

3. **统计分析方法** (Statistical Methods)
   - 基础回归 (Basic Regression)
   - 生存分析 (Survival Analysis)
   - 因果推断 (Causal Inference)
   - 高级建模 (Advanced Modeling)
   - 贝叶斯统计 (Bayesian Statistics)
   - 模型评估 (Model Evaluation)
   - 综述方法 (Review Methods)
   - 流行病学研究设计 (Study Design)

4. **机器学习与AI** (ML & AI)
   - 机器学习框架 (ML Frameworks)
   - 深度学习 (Deep Learning)
   - AI 工具 (AI Tools)

5. **实用操作** (Practical Operations)
   - 数据导入导出 (Data I/O)
   - 数据清洗 (Data Cleaning)
   - 数据转换 (Data Transformation)
   - 文档写作 (Document Writing)
   - 开发环境 (Development Environment)

6. **数据可视化** (Data Visualization)
   - 图形基础 (Plotting Basics)
   - 图形组合 (Plot Composition)
   - 分布图 (Distribution Plots)
   - 趋势图 (Trend Plots)
   - 比较图 (Comparison Plots)
   - 关系图 (Relationship Plots)
   - 特殊图形 (Special Plots)
   - 专题图 (Thematic Plots)
   - 进阶美化 (Advanced Styling)

7. **特殊应用** (Special Applications)
   - 卫生经济学 (Health Economics)
   - 质性研究 (Qualitative Research)
   - 信号处理 (Signal Processing)
   - 环境流行病学 (Environmental Epidemiology)
   - 建模方法 (Modeling Methods)

---

## Key Configuration Files

### `doc/_quarto.yml`

Main configuration controlling:
- Site metadata (title, navbar, footer)
- Sidebar navigation structure (all article links)
- Theme and styling (SCSS, CSS)
- Output directory (`public/`)
- Pre-render scripts
- Code execution settings

**Important**: The `sidebar.contents` section defines the entire site navigation. Changes here require re-running `generate_sections.R`.

### `doc/styles.css`

Custom CSS including:
- Auto-section numbering (CSS counters for h2/h3)
- Responsive layout (3-column desktop, mobile adaptations)
- Card and component styling
- Search box styling
- Mobile TOC floating button
- Print styles

### `doc/theme.scss`

SCSS variables for:
- Color schemes
- Typography
- Component defaults

---

## Security Considerations

1. **No sensitive data** in tutorials - use publicly available datasets
2. **Server credentials** stored in GitHub Secrets only
3. **SSH keys** for deployment are encrypted in GitHub
4. **No API keys** should be committed to repository

---

## External Rules

No additional rule files detected:
- No `.cursor/rules`
- No `.cursorrules`
- No `.github/copilot-instructions.md`

---

## Common Tasks Reference

### Task: Add New Tutorial

1. Determine category and next available number
2. Create `doc/[NNXX]-[topic].rmd` with proper YAML header
3. Add entry to `doc/_quarto.yml` sidebar
4. Run `cd doc && Rscript generate_sections.R`
5. Update `doc/0001-guide.rmd` with new tutorial link
6. Test: `quarto render doc/[NNXX]-[topic].rmd`
7. Commit source files only

### Task: Update Sidebar Structure

1. Edit `doc/_quarto.yml` → `website.sidebar.contents`
2. Run `cd doc && Rscript generate_sections.R`
3. Verify section pages render correctly
4. Commit `_quarto.yml` and regenerated `sections/*.qmd` files

### Task: Fix Rendering Error

1. Check console output for specific error
2. If missing package: install it
3. If YAML error: validate syntax
4. If R error: debug code chunk
5. Delete cache: `rm -rf doc/[file]_cache/`
6. Re-render to verify fix

---

## Contact & Resources

- **Issues**: https://github.com/KangWang42/R_note_for_Epidemiology/issues
- **Quarto Docs**: https://quarto.org/docs/
- **R Markdown Cookbook**: https://bookdown.org/yihui/rmarkdown-cookbook/
