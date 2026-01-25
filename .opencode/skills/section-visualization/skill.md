---
name: section-visualization
description: Generate comprehensive R data visualization tutorials (ggplot2, chart types, styling, publication-ready plots) with theory + practice workflow. Use when: (1) User requests visualization tutorials, (2) File names match 20xx-*.rmd pattern, (3) Keywords: boxplot, scatterplot, heatmap, forestplot, sankey, ggplot2 styling, color palettes.
---
## 核心任务

生成数据可视化类教程 (.rmd/.qmd)，涵盖图表原理、绘图代码、样式美化、结果解读。

## 快速启动 (Quick Start)

1. **确定图表**: 如 "箱线图 (Boxplot)"。
2. **加载模板**: 阅读 [content-structure.md](references/content-structure.md) 获取 YAML 和标题结构。
3. **生成内容**: 遵循 "图表用途 -> 数据准备 -> 绘图流程 -> 美化技巧 -> 解读说明" 流程。
4. **视觉设计**: 参考 [visual-templates.md](references/visual-templates.md) 生成封面图和原理示意图。
5. **质量检查**: 使用 [quality-checklist.md](references/quality-checklist.md) 验证导航更新。

## 完整工作流程

### 步骤1: 生成教程内容与封面

按 [content-structure.md](references/content-structure.md) 结构生成文件。

- **必须包含**: 至少 3 个图表示例 (基础 → 中级 → 高级)。
- **封面图 (MANDATORY)**: 必须生成 `doc/images/[topic]-cover.svg`。
- **原理图**: 复杂逻辑，结构图，代码不好展现的，必须AI生图生成 `doc/images/diagrams/stat-*.svg（或者png），由AI直接生成`，比如一些思维导图，可视化内容。使用md语法在文章内引用

### 步骤2: 验证渲染 (CRITICAL)

在提交前必须进行本地渲染验证，确保代码可运行且图片生成正确。

```bash
# 渲染单文件验证内容
quarto render doc/20[number]-[topic].rmd

# 确保图片生成在 doc/figure/ 目录下，无报错
```

### 步骤3: 更新导航系统 (CRITICAL)

必须执行以下步骤，否则新文章无法在网站侧边栏和分类页显示。

1. **更新 `doc/_quarto.yml`**:

   - 找到 `sidebar` -> `contents` -> `数据可视化` 部分。
   - 添加新条目，**注意缩进**:
     ```yaml
               - text: "文章标题"
                 href: "20xx-filename.rmd"
     ```
2. **更新 `doc/0001-guide.rmd`**:

   - 在对应分类的表格中添加一行：
     ```markdown
     | [图表名] | [文章标题](20xx-filename.html) | [简短说明] |
     ```
3. **运行自动生成脚本 (MANDATORY)**:

   - 此脚本会根据 `_quarto.yml` 更新 `sections/visualization.qmd` 等分类索引页。

   ```bash
   # 在项目根目录下运行
   workdir="doc" Rscript doc/generate_sections.R
   ```
4. **更新 `README.md`**:

   - 在 `🧭 内容导航` -> `📈 数据可视化` 的对应表格中添加链接。

### 步骤4: 最终渲染与提交

1. **重新渲染受影响页面**:

   ```bash
   quarto render doc/sections/visualization.qmd
   quarto render doc/index.qmd
   ```
2. **提交代码**:

   ```bash
   git add doc/20xx-*.rmd doc/images/[topic]-cover.svg
   git add doc/_quarto.yml doc/0001-guide.rmd README.md doc/sections/visualization.qmd
   git commit -m "feat(viz): 新增[图表类型]可视化教程"
   ```

## 写作规范

- **内容标准**:
  - **详细度**: 内容必须详尽，起到深入教程的作用。
  - **篇幅**: 不少于 300 行 (Not less than 300 lines)。
  - **比例**: 文字说明约占 70%，代码约占 30% (70% text, 30% code)。
  - **结构**: 必须提前构建全面的内容框架，然后根据框架填充详细内容。
- **图文比例**: 目标是每个代码块都有对应的图表输出。
- **配色**: 优先使用 `ggsci` 期刊配色、`ColorBrewer` 或 `viridis` (色盲友好)。
- **注释**: 每张图都要包含标题、坐标轴标签、图例标题。

## 参考资源

- [content-structure.md](references/content-structure.md): 详细内容模板与标题规范。
- [visual-templates.md](references/visual-templates.md): SVG 封面与示意图模板库。
- [quality-checklist.md](references/quality-checklist.md): 完整质量检查与导航更新指南。
- [color-palettes.md](references/color-palettes.md): 常用配色方案参考。
