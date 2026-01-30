---
name: section-special
description: Generate comprehensive R tutorials for specialized applications (health economics, qualitative research, signal processing, environmental epidemiology, cellular automata) with theory + practice workflow. Use when: (1) User requests domain-specific tutorials, (2) File names match 60xx-[topic].rmd pattern, (3) Keywords: TreeAge, CEA, text mining, wavelet, VMD, DLNM, WQS, BKMR, cellular automata, agent-based modeling.
---
## 核心任务

生成特殊应用领域教程 (.rmd/.qmd)，涵盖领域背景、专业方法、完整流程、结果解释，强调 "领域背景 → 专业术语 → 分析框架 → 实践流程 → 结果解读"。

## 快速启动 (Quick Start)

1. **确定领域**: 如 "元胞自动机 (Cellular Automata)"。
2. **加载模板**: 阅读 [content-structure.md](references/content-structure.md) 获取 YAML 和标题结构。
3. **生成内容**: 遵循 "背景 -> 术语 -> 原理 -> 实践 -> 领域解读" 流程。
4. **视觉设计**: 参考 [visual-templates.md](references/visual-templates.md) 生成封面图和领域框架图。
5. **质量检查**: 验证术语准确性与导航更新。

## 完整工作流程

### 步骤0: 文件编号分配 (CRITICAL - 避免重复)

**在创建任何文件前，必须先确定可用编号！**

1. **检查现有编号**:

   ```bash
   ls doc/60*.rmd doc/60*.qmd | sort | tail -20
   ```
2. **选择下一个可用编号**:

   - 找到当前最大编号 (如 6005)
   - 新文件使用下一个编号 (如 6006，上一个编号＋1)
   - **绝对禁止**: 使用已存在的编号!
3. **编号冲突检测**:

   ```bash
   # 检查是否有重复编号
   ls doc/60*.rmd doc/60*.qmd | sed 's/.*\///;s/-.*//' | sort | uniq -d
   # 如果有输出，说明存在重复编号，必须先解决
   ```
4. **命名规范**:

   - 格式: `60[number]-[topic].rmd`
   - 示例: `6001-cellular-automata.rmd`
   - 禁止: 同一编号用于不同主题

### 步骤1: 逐部分生成教程内容（CRITICAL - 分段生成策略）

**⚠️ 重要：教程内容超过 300 行时必须分段生成，避免一次性输出过长内容。**

**分段生成流程**：

1. **第一部分**：生成 YAML 头部 + Setup + 领域背景 + 核心概念 + 基础原理（约 150-200 行）
2. **第二部分**：追加数据准备 + 基础实现 + 可视化方法（约 150-200 行）
3. **第三部分**：追加进阶应用 + 案例分析 + 常见问题（约 100-150 行）
4. **第四部分**：追加总结 + 参考文献（约 50 行）
5. **验证完整性**：确认所有必需章节都已包含

**使用工具追加内容**：
- 推荐使用 `edit` 工具在特定位置插入
- 或使用 `bash` 的 `cat >> file.rmd << 'EOF'` 追加
- 每次追加后用 `wc -l` 检查行数

**内容生成要求**：
- **必须包含**: `## 领域背景` 到 `## 参考文献` 的标准章节结构
- **零基础通俗解释**: 必须在开头用生活化类比解释核心原理
- **可复现性**: 所有随机操作必须设置种子 `set.seed(2026)`
- **领域准确性**: 术语使用必须准确，遵循领域规范和指南

### 步骤1.5: 生成配图并在文章中引用（CRITICAL）

**⚠️ 必须完成的两步操作**：

**第一步：生成图片文件**

1. **封面图 (MANDATORY)**: 
   - 路径：`doc/images/[number]-[topic]-cover.svg`
   - 风格：学术、专业、与领域相关
   - 尺寸：1200×675 (16:9 比例)
   - 必须包含：中英文标题、视觉元素

2. **文内示意图 (MANDATORY - 每篇至少 2 张)**：
   - 路径：`doc/images/diagrams/spc-*.svg`
   - 格式：**必须使用 SVG 格式**（扩展名必须是 .svg）
   - **尺寸要求**（CRITICAL）：
     - **推荐标准尺寸**: `viewBox="0 0 1400 800"` (宽 1400, 高 800)
     - **流程图**: 1400×800 (横向流程)
     - **对比表格图**: 1400×800～1400×900 (横向宽幅)
     - **原理示意图**: 1000×700～1200×800
     - **架构图**: 1200×600～1400×800
     - ⚠️ **避免**: 过高的纵向布局 (如 1000×1100)，会导致显示不全
   - 用途：**原理示意、流程图、对比表、架构图、决策树**
   - 示例场景：
     - 领域概念框架图
     - 方法流程图
     - 多种方法对比表格
     - 分析步骤流程图
     - 应用场景决策树

**第二步：在文章中引用图片（CRITICAL）**

⚠️ **生成图片后必须立即在文章相应位置添加 Markdown 引用！**

```markdown
## 核心概念与原理

![元胞自动机基本结构](images/diagrams/spc-ca-structure.svg)

**结构说明**：上图展示了元胞自动机的基本组成要素：元胞、状态、邻域和规则。
```

**插入位置建议**：
- 概念框架图 → "核心概念"章节
- 流程图 → "完整分析流程"章节
- 对比图 → "领域背景与适用场景"章节
- 应用场景图 → "进阶应用"章节

**验证图片引用**：
```bash
grep "!\[.*\](images/diagrams/" doc/[number]-[topic].rmd
```

### 步骤2: 验证渲染 (CRITICAL)

在提交前必须进行本地渲染验证，确保代码可运行且格式正确。

```bash
# 渲染单文件验证内容
quarto render doc/60[number]-[topic].rmd

# 确保无报错、包缺失或格式问题
```

**安装依赖**:
若渲染过程中提示缺少 R 包，请先安装：

```r
# 示例：安装常用包
install.packages(c("ggplot2", "dplyr", "tidyr", "purrr"))
```

### 步骤3: 更新导航系统 (CRITICAL)

**⚠️ 重要顺序：必须先创建文章 → 更新 _quarto.yml → 运行 generate_sections.R**

必须执行以下步骤，否则新文章无法在网站侧边栏和分类页显示。

**⚠️ 更新导航前务必验证**:

- 确认新文件已成功渲染
- 确认文件编号无冲突
- 确认YAML元数据正确

1. **更新 `doc/_quarto.yml`**:

   - 找到 `sidebar` -> `contents` -> `特殊应用` 部分。
   - 添加新条目，**严格遵守 14 空格缩进**:
     ```yaml
               - text: "文章标题"
                 href: "60xx-[topic].rmd"
     ```

2. **运行自动生成脚本 (MANDATORY - 在更新 _quarto.yml 之后)**:

   - ⚠️ **必须在 _quarto.yml 更新后运行**，否则新的文章链接不会出现在 sections 中
   - 此脚本会根据 `_quarto.yml` 更新对应的 section 分类索引页。

   ```bash
   # 在 doc 目录下运行
   cd doc && Rscript generate_sections.R
   ```

3. **验证 sections 已更新**:

   ```bash
   # 检查新文章是否出现在对应的 section 中
   grep "60xx-[topic]" doc/sections/special.qmd
   ```

4. **重新渲染 sections 页面**:

   ```bash
   quarto render doc/sections/special.qmd
   ```

### 步骤4: 最终渲染与提交

1. **重新渲染受影响页面**:

   ```bash
   quarto render doc/sections/special.qmd
   quarto render doc/index.qmd
   ```
2. **提交代码**:

   ```bash
   git add doc/60xx-*.rmd doc/images/60xx-*-cover.svg doc/images/diagrams/spc-*.svg
   git add doc/_quarto.yml doc/0001-guide.rmd README.md doc/sections/special.qmd
   git commit -m "feat(spc): 新增[领域-方法]特殊应用教程"
   ```

## 写作规范

- **内容标准**:
  - **详细度**: 内容必须详尽，起到深入教程的作用。
  - **篇幅**: 不少于 300 行 (Not less than 300 lines)。
  - **比例**: 文字说明约占 70%，代码约占 30% (70% text, 30% code)。
  - **结构**: 必须提前构建全面的内容框架，然后根据框架填充详细内容。
- **术语**: 首次出现的术语提供中英文对照和通俗解释。
- **解读**: 强调从领域视角（如应用场景、实践意义）解读结果。
- **完整性**: 包含领域背景、理论基础、实践案例和进阶应用。
- **视觉**: SVG 标注必须全部使用中文。

## 代码块与表格格式规范 (CRITICAL)

### 图片居中 (MANDATORY)

**在 setup chunk 中设置全局图片居中**：

```r
knitr::opts_chunk$set(
  echo = TRUE, 
  message = FALSE, 
  warning = FALSE,
  fig.align = 'center',  # 所有图片居中
  fig.width = 10,
  fig.height = 7,
  dpi = 300
)
```

**或在单独代码块中设置**：

```r
```{r plot-name, fig.align='center', fig.width=10, fig.height=7}
# 图表代码
```
```

### 表格字体大小 (MANDATORY)

**所有 gt 表格必须设置合适的字体大小，避免表格过小难以阅读**：

```r
tibble(...) |> 
  gt() |> 
  tab_options(
    table.font.size = px(14),      # 表格字体 14px
    data_row.padding = px(8)       # 行间距 8px
  ) |> 
  tab_style(
    style = cell_fill(color = "#E8F4F8"),
    locations = cells_column_labels()
  )
```

**推荐字体大小**：
- 常规表格：`px(14)` 
- 大型对比表：`px(13)` 
- 简洁表格：`px(15)`

**必须添加的 tab_options 参数**：
- `table.font.size`: 控制整体字号
- `data_row.padding`: 控制行间距，提升可读性
- `column_labels.font.size`: (可选) 单独设置表头字号

## 参考资源

- [content-structure.md](references/content-structure.md): 详细内容模板与标题规范。
- [visual-templates.md](references/visual-templates.md): SVG 封面与示意图模板库。
- [domain-terminology.md](references/domain-terminology.md): 各领域核心术语库。
