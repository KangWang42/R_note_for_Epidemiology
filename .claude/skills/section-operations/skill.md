---
name: section-operations
description: 为本仓库新建、重写或审校实用操作教程，包括数据导入清洗、字符串日期、网页抓取、R/Quarto/Typst、编辑器和环境配置。适用于 `doc/30xx-*.rmd`、`doc/30xx-*.qmd` 与实用操作栏目；先用 `tutorial-authoring`，涉及数据分析时再使用相应统计 skill。当前软件功能、命令和平台差异必须以官方文档和实际运行核验。不用于直接修改业务数据或只修一个命令。
---

# 实用操作教程

## 开工

1. 先执行 `tutorial-authoring` 并读取 [content-structure.md](references/content-structure.md)。
2. 确定读者的操作系统、工具版本、输入文件、目标产物和验证方式。只有平台差异会改变步骤时才拆分说明。
3. 用实际 `--help`、版本命令和官方文档核对命令；稳定、实验和已弃用功能分开写。
4. 数据清洗主题另读 [data-cleaning-workflow.md](references/data-cleaning-workflow.md)，保持原始输入只读。

## 写作与示例

围绕“任务 → 前置条件 → 最小步骤 → 预期结果 → 验证 → 常见失败”组织。命令块必须可复制，但路径、引号、shell 和工作目录需与平台一致。解释关键参数改变什么，不逐字翻译每个选项。

安装命令与日常使用分开；不要求用户在教程构建时升级运行时或全局环境。外部字体、TeX、Java、系统库和编译器等依赖要说明核验命令和失败影响。

## 图件

按 [visual-templates.md](references/visual-templates.md) 选择真实终端、文档、页面或文件树截图。界面和编译结果必须实际运行得到；概念流程只有在文字和真实截图无法表达关系时使用。

## 验证与导航

- 从干净工作目录按文中顺序执行关键命令，检查输出文件、退出码和完整日志。
- Typst/Quarto 等教程至少编译一个最小文件，并检查最终 PNG/PDF/HTML，不只检查源码。
- 运行项目教程审计与目标文章渲染，扫描 warning/error。
- 更新 `_quarto.yml` 后从 `doc/` 运行 `Rscript generate_sections.R`，再定向渲染 `sections/operation.qmd` 和 `index.qmd`。
