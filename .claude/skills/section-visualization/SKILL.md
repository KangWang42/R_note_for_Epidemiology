---
name: section-visualization
description: 为本仓库新建、重写或审校 R 数据可视化教程，包括 ggplot2、图形类型、配色、标注、组合、交互与导出。适用于 `doc/20xx-*.rmd`、`doc/20xx-*.qmd` 和数据可视化栏目；先用 `tutorial-authoring`，任何统计数据图同时使用 `biostat-principles` 与 `publication-figures`。不用于非统计流程、机制或框架图。
---

# 数据可视化教程

## 开工

1. 先执行 `tutorial-authoring`，再读取 [content-structure.md](references/content-structure.md)。
2. 明确图要回答的问题、数据形态、主要读者、网页/论文/演示载体和最终显示尺寸。
3. 核对图形函数、扩展包、返回对象和导出接口的当前官方文档。
4. 统计图先确认估计目标、分母、不确定性和数据限制；不能用视觉修饰掩盖数据或方法问题。
5. 按 [共同辨析合同](../tutorial-authoring/references/comparison-and-visuals.md) 判断是否存在会影响当前任务的相邻图形。若图形选择会改变读者看到的统计量或比较任务，才在首次绘图前说明选择依据。

## 内容主线

按“问题 → 数据 → 最小图 → 读图 → 改进 → 误导风险 → 导出”组织，不强制固定行数、三个示例或每个代码块都出图。每个新增示例必须增加一种信息能力，例如分组、区间、标注、分面、坐标转换或无障碍，而不是只换主题和颜色。

- 先解释图形编码与统计量，再讲样式；比较相邻图形时保持数据、尺度和统计变换一致。
- 数据变换、排序、聚合和缺失处理必须在代码中可见。
- 不把平滑线、箱线图须、误差条或显著性标记解释成它们没有表达的量。
- 坐标截断、对数尺度、双轴、面积/体积编码和抖动会改变读图，应说明原因与限制。
- 图题、坐标、图例、单位和注释由读者任务决定；不机械要求每张图内部重复文章标题。
- 不用“更美观”选择图形。明确每个候选图回答的问题、可能遮蔽的结构和最常见误读。

## 配色与可访问性

按需读取 [color-palettes.md](references/color-palettes.md)。颜色与变量类型匹配，并用形状、线型、直接标签或分面提供冗余编码。期刊风格包只是候选色值来源，不代表期刊认可，也不保证色盲、灰度或投影条件下可读。

## 代码与图件

- 所有图由文章代码实跑生成；随机抖动、抽样或布局才设置种子。
- 中间对象命名清楚，使读者能核对数据到图的转换。
- 使用最终载体的物理尺寸检查字号、线宽、图例和多面板密度。
- 每张内容图提供准确 `fig.alt` 或 Markdown 替代文本；替代文本描述结构、组别和主要关系。
- 图件选择与导出读取 [visual-templates.md](references/visual-templates.md)。

## 验证与导航

1. 按 [quality-checklist.md](references/quality-checklist.md) 审查并实跑所有绘图代码。
2. 更新 `_quarto.yml` 后从 `doc/` 运行 `Rscript generate_sections.R`。
3. 只渲染目标文章、`sections/visualization.qmd` 和 `index.qmd`。
4. 检查最终 HTML、目标尺寸图片、中文字体、替代文本、颜色以外的编码和完整日志。
