---
name: section-r-packages
description: 为本仓库新建、重写或审校 R 包教程与包比较文章，包括 CRAN、Bioconductor 和官方 GitHub 包。适用于实用 R 包栏目及按包名组织的 Rmd/Qmd；先用 `tutorial-authoring`，涉及统计方法时同时使用 `biostat-principles` 和对应分析 skill。需要核对版本、函数、许可证和当前发布状态时使用官方来源。不用于只安装包或只修一个函数报错。
---

# R 包教程

## 开工核验

1. 先执行 `tutorial-authoring`，再读取 [content-structure.md](references/content-structure.md)。
2. 从包的 `DESCRIPTION`、官方站点、参考手册和 `NAMESPACE` 核对包名、版本、发布日期、许可证、依赖、导出函数和发布渠道。
3. 包处于 GitHub 开发、归档、同名冲突或接口快速变化时，在正文标注核验日期和版本。用户提供的介绍文只作为入口。
4. 对照 [package-comparison.md](references/package-comparison.md) 选择比较维度，不用星级、流行度或未经实测的速度下结论。

## 内容主线

先回答包解决什么任务、与底层包或替代包是什么关系，再按真实任务组织函数。至少给出一个从输入、函数调用、返回对象到诊断和解释的完整工作流。函数清单只保留能帮助导航的部分，不逐项抄写帮助页。

重要参数说明其改变的行为和失败边界。包封装统计模型时，既解释接口，也解释底层方法假设；“开箱即用”不等于结果可直接解释。

## 代码与环境

- 所有声称可运行的函数都在文章标注版本下实跑，并检查返回对象结构。
- 优先使用小而有意义的内置或自建数据。随机示例设置种子。
- CRAN/Bioconductor 与官方 GitHub 安装分开说明；GitHub 包建议锁定版本或提交。教程构建不自动安装系统依赖。
- 若站点环境不含该包，可把安装示例保留为展示代码，并用独立、可追溯脚本生成真实图件；不能伪造输出。
- 批量示例必须记录失败分组，不用 `tryCatch()` 静默吞错。

## 图件

按 [visual-templates.md](references/visual-templates.md) 选择真实函数输出、模型诊断、渲染截图或必要架构图。每张图说明包函数产生了什么对象，以及图不能证明什么。

## 验证与导航

运行项目审计脚本、示例代码和目标文章渲染，扫描完整日志。更新 `doc/_quarto.yml` 后从 `doc/` 运行 `Rscript generate_sections.R`，再定向渲染 `sections/packages.qmd` 与 `index.qmd`。不因包教程更新而全站构建。
