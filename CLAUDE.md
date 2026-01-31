# AGENTS Instructions for R 语言学习笔记

## Project Overview

我要求你生成文章的时候，一定要查看对应的Skills，使用skills的规范来生成、

缺少的R包你安装之后再运行，除非我普通电脑运行不了或者时间太久，不然不要evalFALSE

如果我说文章没有问题，你就直接gitadd然后push，注意所有修改的内容都要提交，能提交的都要提交

---

Repository Layout

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
