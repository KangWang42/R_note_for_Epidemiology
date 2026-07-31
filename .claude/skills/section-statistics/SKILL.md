---
name: section-statistics
description: 为本仓库新建、重写或审校统计方法教程，包括回归、生存、缺失数据、因果推断、多重检验、样本量和高级模型。适用于 `doc/10xx-*.rmd`、`doc/11xx-*.rmd` 及统计分析方法栏目；先用 `tutorial-authoring`，再按需使用 `biostat-principles`、`evidence-research`、`r-biostats` 和 `publication-figures`。不用于仅执行一个现成分析或仅制作图形。
---

# 统计方法教程

## 开工

1. 先执行 `tutorial-authoring` 的共同流程并读取其质量标准。
2. 新建文件前扫描 `doc/` 的数字前缀、相近主题和 `_quarto.yml`，避免重复编号与重复教程；重写时保留原路径。
3. 明确研究问题是描述、关联、预测还是因果，锁定数据结构、estimand、结局、时间零点和主要效应尺度。
4. 需要理论保证、报告规范或当前包接口时，用权威论文和官方文档核验，不凭记忆补引文或函数。
5. 按 [共同辨析合同](../tutorial-authoring/references/comparison-and-visuals.md) 判断是否存在易混淆候选。只有选错方法会改变 estimand、效应解释或诊断时，才列出最接近的 2–4 个候选并把比较放在正文前段。

## 内容主线

按文章需要读取 [content-structure.md](references/content-structure.md)。写作顺序通常是：问题与适用范围、估计目标、方法原理、假设、与相近方法的区别、具有正确生成机制的示例、模型拟合、诊断、结果解释、失败模式和报告清单。

方法选择参考 [method-comparison.md](references/method-comparison.md)，但最终选择必须服从研究设计和 estimand。比较至少覆盖目标量、数据结构、相关性或风险集处理、假设、缺失或删失、诊断与改用条件；不要用显著性、拟合优度或某个软件是否方便来反向决定方法。

## 代码与模拟

- 示例数据必须体现方法要解决的结构。纵向数据要有簇内相关，竞争风险要同时有目标事件、竞争事件和删失，时变暴露要先发生再影响风险，MSM 要有受既往治疗影响的时变混杂。
- 所有可执行 chunk 使用唯一语义标签，随机过程设置可复现种子。
- 代码写完必须实跑；warning 逐项处理。不要把 `warning = FALSE` 当作质量控制。
- 同时解释效应量、置信区间、绝对风险或精度；P 值不是唯一结果。
- 经验阈值、截断点和模拟参数标明是教学设定或有来源的方案输入，不写成普遍规则。

## 图件

读取 [visual-templates.md](references/visual-templates.md)。优先生成能教会读者诊断或解释的真实统计图，例如权重分布、平衡图、CIF、残差、功效敏感性曲线和模拟分布。固定维度的一一比较用表格；三个以上方法共享输入却导向不同目标，或选择过程含分支时，才考虑概念定位图，并遵循 `research-visuals`。

## 验证与导航

1. 按 [quality-checklist.md](references/quality-checklist.md) 审查内容。
2. 运行项目教程审计脚本并实跑文章代码。
3. 定向渲染目标文章，扫描完整日志。
4. 在 `doc/_quarto.yml` 的统计栏目加入或调整条目，再从 `doc/` 运行 `Rscript generate_sections.R`。
5. 只渲染 `sections/statistics.qmd`、`index.qmd` 和本次目标文章；检查生成页面的代码、表格、图片和移动端可读性。
