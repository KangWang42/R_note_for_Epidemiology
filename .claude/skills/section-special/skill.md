---
name: section-special
description: 为本仓库新建、重写或审校跨领域特殊应用教程，包括卫生经济学、质性研究、信号处理、环境流行病学、计算模拟及其他专业方法。适用于 `doc/60xx-*.rmd`、`doc/60xx-*.qmd` 与特殊应用栏目；先用 `tutorial-authoring`，再按领域调用 `evidence-research`、对应分析 skill 和视觉 skill。不用于把未经验证的跨领域方法直接包装为推荐方案。
---

# 特殊应用教程

## 开工

1. 先执行 `tutorial-authoring`，再读取 [content-structure.md](references/content-structure.md)。
2. 定义领域、读者、研究或业务问题、目标产物、数据生成过程和适用规范。
3. 新建文件前核对 `60xx` 编号、主题重复、稳定 URL 和 `_quarto.yml` 位置。
4. 用 `evidence-research` 核验专业术语、方法来源、报告规范、软件状态和跨领域适用性；用户提供的二手介绍只作为线索。

## 跨领域合同

先说明方法在原领域解决什么问题，再判断目标领域是否具有兼容的构念、测量尺度、采样过程和假设。名称相同不代表 estimand、输入或解释相同。无法确认可迁移性时，明确标为待验证方案，不写成成熟做法。

术语与来源路由读取 [domain-terminology.md](references/domain-terminology.md)。文章应区分：领域定义、统计或算法假设、软件实现、教学设定和作者建议。

## 内容与代码

- 按真实工作流组织，不固定章节数、行数、文字/代码比例、类比、图件或参考文献数量。
- 核心方法至少说明输入、输出、假设、诊断、失败模式和与替代方案的区别。
- 模拟必须反映目标领域的数据结构；演示结果不写成领域发现或政策建议。
- 领域软件、R 包、商业工具和数据库均核对版本、许可证、平台与数据使用条件。
- 实跑全部声明可执行的代码和命令；不隐藏 warning，不为构建成功静默更换方法。
- 涉及真实研究分析时使用 `biostat-principles` 和对应 R/Python 执行 skill；统计图使用 `publication-figures`。

## 图件

读取 [visual-templates.md](references/visual-templates.md)。统计和模拟结果来自真实代码，软件界面来自实际运行，流程/机制/框架按 `research-visuals` 生成。科研原始图像不得生成式重绘。

## 验证与导航

1. 核对引用身份、领域术语、报告规范和软件接口。
2. 运行教程审计、代码与命令，扫描 warning/error/NA/空结果。
3. 更新 `_quarto.yml` 后从 `doc/` 运行 `Rscript generate_sections.R`。
4. 只渲染目标文章、`sections/special.qmd` 和 `index.qmd`，检查最终 HTML、图片和移动端可读性。
