# AGENTS Instructions for R 语言学习笔记

## Scope
- Applies to the whole repository unless a deeper AGENTS.md exists.
- This repo is a Quarto website with source files in `doc/` and outputs in `public/`.
- Prefer editing source files only; generated content lives under `public/`.

## Repository Layout
- `doc/`: Quarto source, `.rmd`/`.qmd` articles, assets, config.
- `doc/_quarto.yml`: site config; output directory is `../public`.
- `doc/images/`, `doc/figure/`: media and generated figures.
- `public/`: built website output (do not edit by hand).
- `.github/workflows/deploy.yml`: deploys `public/` on push to `main`.

## Build / Preview / Render
- From repo root, preview the site:
  - `quarto preview doc`
- From `doc/`, preview the site:
  - `quarto preview`
- Render the full site:
  - `quarto render doc`
- Render a single article:
  - `quarto render doc/0011-rmarkdown.rmd`
  - `quarto render doc/0013-positron.qmd`
- Render a specific section file:
  - `quarto render doc/sections/guide.qmd`
- Clean output by deleting `public/` (only if asked).

## Testing / Linting
- There is no formal test suite or lint config detected.
- If you add new tests, document the command here.
- Prefer manual validation by rendering the specific article you changed.

## Tooling Prerequisites
- Requires R 4.x and Quarto.
- R packages are article-specific; install per the tutorial content.
- Consider using `renv` only if the repo adds it.

## Code Style: R and Quarto
- Use tidyverse-style formatting (2 spaces; no tabs).
- Keep line width around 80 where reasonable.
- Use snake_case for variables and functions.
- Use explicit, descriptive names; avoid one-letter variables.
- Prefer native pipe `|>` (or `%>%` if existing code uses it).
- Keep function definitions and library calls at the top of a chunk.
- Use explicit namespace calls (`pkg::fn`) for non-core functions.

## Imports and Dependencies
- Use `library()` in R chunks only when several functions are used.
- For one-off calls, prefer `pkg::fn`.
- Do not load unused packages.
- Avoid attaching packages in global setup chunks unless needed.

## Quarto / RMarkdown Conventions
- Use clear chunk labels and keep them unique.
- Include chunk options like `echo`, `message`, `warning` deliberately.
- Use `set.seed()` for any stochastic output.
- Prefer `include = FALSE` or `echo = FALSE` when output is not needed.
- Avoid hard-coded absolute paths; use relative paths from `doc/`.
- Store images in `doc/images/` or `doc/figure/`.
- Reference figures with relative paths and descriptive filenames.

## Error Handling and Robustness
- Validate inputs in reusable functions (types, ranges, missing values).
- Use informative error messages with `stop()` when necessary.
- Avoid suppressing warnings unless they are known and documented.

## Naming and Content Rules
- Article filenames follow numeric prefixes (e.g., `1014-purrr.rmd`).
- Keep new files consistent with existing naming scheme.
- Add new entries to `doc/_quarto.yml` sidebar if needed.
- Keep headings in Chinese consistent with existing style.

## Content Quality
- Ensure examples are reproducible and minimal.
- Prefer vectorized operations over explicit loops when possible.
- Use consistent terminology between text and code.
- Avoid changes to unrelated sections or topics.

## Generated Output
- Do not manually edit `public/`.
- Regenerate `public/` with `quarto render` when needed.
- Keep `_freeze` behavior consistent with `execute.freeze: auto`.

## Git Hygiene
- Keep commits scoped to source files under `doc/`.
- Avoid committing large generated assets unless required.
- If `public/` is updated, ensure it is the result of a render.

## Repo Rules in Other Locations
- No `.cursor/rules`, `.cursorrules`, or `.github/copilot-instructions.md` found.
- If any are added later, include their rules here.

## Validation Checklist
- Render the changed article with `quarto render doc/<file>`.
- Skim the output HTML for warnings and layout issues.
- Ensure links to images and sections resolve correctly.
- Confirm sidebar entries match new content when added.

## Notes for Agentic Edits
- Prefer targeted edits using existing patterns.
- Minimize changes to generated output.
- Ask before making structural changes to navigation or sections.

## Skill Auto-Load Rules
- 当任务涉及“入门指南/学习路线/基础知识”，先加载 `section-intro-guide`.
- 当任务涉及“实用 R 包”教程/评测/实践，先加载 `section-r-packages`.
- 当任务涉及“统计分析方法”，先加载 `section-statistics`.
- 当任务涉及“机器学习/深度学习/AI”，先加载 `section-ml-ai`.
- 当任务涉及“数据导入/清洗/转换/文档写作/开发环境”，先加载 `section-operations`.
- 当任务涉及“数据可视化/图形设计/绘图美化”，先加载 `section-visualization`.
- 当任务涉及“卫生经济学/质性研究/信号处理等特殊应用”，先加载 `section-special`.

