---
name: section-statistics
description: Generate comprehensive R statistical method tutorials (regression, survival analysis, causal inference, Bayesian stats) with theory + practice workflow. Use when: (1) User requests statistical method tutorials, (2) File names match 10xx-*.rmd pattern, (3) Keywords: PSM, Cox, Meta-analysis, RCS, multilevel models, SEM, PCA, LCA.
---
## 核心任务

生成统计分析方法类教程 (.rmd/.qmd)，确保理论背景、模型假设、完整分析流程与结果解释并重。

## 快速启动 (Quick Start)

1. **确定方法**: 如 "泊松回归 (Poisson Regression)"。
2. **加载模板**: 阅读 [content-structure.md](references/content-structure.md) 获取 YAML 和标题结构。
3. **生成内容**: 遵循 "通俗解释 -> 理论 -> 代码 -> 解读" 流程。
4. **视觉设计**: 参考 [visual-templates.md](references/visual-templates.md) 生成封面图和原理示意图。
5. **质量检查**: 使用 [quality-checklist.md](references/quality-checklist.md) 验证导航更新。

## 完整工作流程

### 步骤0: 文件编号分配 (CRITICAL - 避免重复)

**在创建任何文件前，必须先确定可用编号！**

1. **检查现有编号**:
   ```bash
   ls doc/10*.rmd doc/10*.qmd | sort | tail -20
   ```

2. **选择下一个可用编号**:
   - 找到当前最大编号 (如 1099)
   - 新文件使用下一个编号 (如 1100)
   - **绝对禁止**: 使用已存在的编号!

3. **编号冲突检测**:
   ```bash
   # 检查是否有重复编号
   ls doc/10*.rmd doc/10*.qmd | sed 's/.*\///;s/-.*//' | sort | uniq -d
   # 如果有输出，说明存在重复编号，必须先解决
   ```

4. **命名规范**:
   - 格式: `10[number]-[topic].rmd`
   - 示例: `1100-distributions.rmd`
   - 禁止: 同一编号用于不同主题

### 步骤1: 生成教程内容与封面

按 [content-structure.md](references/content-structure.md) 结构生成文件。

- **必须包含**: `## 方法背景与适用场景` 到 `## 参考文献` 的标准 10 章节结构。
- **零基础通俗解释**: 必须在开头用生活化类比解释核心原理。
- **封面图 (MANDATORY)**: 必须生成 `doc/images/[topic]-cover.svg`。
- **原理图**: 复杂逻辑必须生成 `doc/images/diagrams/stat-*.svg（或者png），由AI直接生成`。

### 步骤2: 验证渲染 (CRITICAL)

在提交前必须进行本地渲染验证，确保代码可运行且格式正确。

```bash
# 渲染单文件验证内容
quarto render doc/10[number]-[topic].rmd

# 确保无报错、包缺失或格式问题
```

**安装依赖**:
若渲染过程中提示缺少 R 包，请先安装：

```r
# 示例：安装常用统计包
install.packages(c("survival", "MatchIt", "lme4", "brms", "mediation"))
```

### 步骤3: 更新导航系统 (CRITICAL)

必须执行以下步骤，否则新文章无法在网站侧边栏和分类页显示。

**⚠️ 更新导航前务必验证**:
- 确认新文件已成功渲染
- 确认文件编号无冲突
- 确认YAML元数据正确

1. **更新 `doc/_quarto.yml`**:

   - 找到 `sidebar` -> `contents` -> `统计分析方法` 部分。
   - 添加 new 条目，**严格遵守 14 空格缩进**:
     ```yaml
               - text: "方法名称"
                 href: "10xx-filename.rmd"
     ```
2. **更新 `doc/0001-guide.rmd`**:

   - 在对应分类的表格中添加一行，保持索引同步。
3. **运行自动生成脚本 (MANDATORY)**:

   - 此脚本会根据 `_quarto.yml` 更新 `sections/statistics.qmd` 等分类索引页。

   ```bash
   # 在项目根目录下运行
   workdir="doc" Rscript doc/generate_sections.R
   ```
4. **更新 `README.md`**:

   - 在 `🧭 内容导航` -> `📐 统计分析方法` 的对应表格中添加链接。

### 步骤4: 最终渲染与提交

1. **重新渲染受影响页面**:

   ```bash
   quarto render doc/sections/statistics.qmd
   quarto render doc/index.qmd
   ```
2. **提交代码**:

   ```bash
   git add doc/10xx-*.rmd doc/images/[topic]-cover.svg
   git add doc/_quarto.yml doc/0001-guide.rmd README.md doc/sections/statistics.qmd
   git commit -m "feat(stat): 新增[方法名称]统计教程"
   ```

## 写作规范

- **内容标准**:
  - **详细度**: 内容必须详尽，起到深入教程的作用。
  - **篇幅**: 不少于 300 行 (Not less than 300 lines)。
  - **比例**: 文字说明约占 70%，代码约占 30% (70% text, 30% code)。
  - **结构**: 必须提前构建全面的内容框架，然后根据框架填充详细内容。
- **代码**: 优先使用 `pkg::fn()` 调用函数；必须提供完整的模拟数据生成代码。
- **解读**: 结果解读必须涵盖统计显著性与实际意义。
- **视觉**: SVG 标注必须全部使用中文。

## 参考资源

- [content-structure.md](references/content-structure.md): 详细内容模板与标题规范。
- [visual-templates.md](references/visual-templates.md): SVG 封面与示意图模板库。
- [quality-checklist.md](references/quality-checklist.md): 完整质量检查与导航更新指南。
- [method-comparison.md](references/method-comparison.md): 统计方法对比表。
