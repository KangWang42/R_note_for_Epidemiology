---
name: section-ai-tools
description: 生成 AI 工具介绍类页面的超详细教程内容，强调工具对比、配置技巧与实战场景；当需要撰写 AI 工具介绍、配置指南、使用技巧类教程时使用
---
## 我做什么

- 为"AI 工具介绍"类页面生成不含代码的长篇实用教程
- 强调工具的使用场景、功能对比、配置方法、操作技巧与效果优化
- 以实际场景为导向，展示工具如何解决具体问题
- 输出可直接用于 `.rmd/.qmd` 的完整页面内容

## 核心原则

**必须查阅官方文档**：在撰写任何 AI 工具教程前，必须先获取并阅读该工具的官方文档。若无法找到官方文档，必须向用户询问文档来源或链接。

**不写代码**：本分类教程以文字说明、截图、配置示例、操作步骤为主，不涉及 R/Python 等编程代码。

## 输出结构要求

1. **工具简介与定位**

   - 工具是什么、解决什么问题
   - 官方网站、文档链接、版本信息
   - 与同类工具的核心差异
2. **适用场景分析**

   - 列出 3-5 个典型使用场景
   - 每个场景说明：问题背景、为何选择此工具、预期效果
   - 明确工具的适用边界（什么情况下不适合）
3. **工具对比**

   - 与同类工具的功能对比表
   - 优缺点分析
   - 选择建议（什么情况用什么工具）
4. **安装与配置**

   - 安装步骤（分平台说明）
   - 核心配置项解释
   - 推荐配置方案
   - 常见配置问题与排查
5. **功能详解与操作指南**

   - 核心功能逐一介绍
   - 每个功能配合操作步骤说明
   - 关键设置项的作用与调优建议
6. **场景实战**

   - 选择 2-3 个具体场景
   - 详细展示：问题描述 → 操作步骤 → 效果展示 → 优化技巧
   - 强调"如何做得更好"的进阶技巧
7. **效果优化与最佳实践**

   - 提升效率的技巧
   - 避免常见错误的建议
   - 高级用法与隐藏功能
8. **常见问题与解答**

   - 收集典型问题
   - 提供解决方案
9. **扩展资源**

   - 官方文档链接
   - 社区资源、教程推荐
   - 相关工具推荐

## 写作规范

- **内容标准**:
  - **详细度**: 内容必须详尽，起到深入教程的作用。
  - **篇幅**: 不少于 300 行 (Not less than 300 lines)。
  - **比例**: 文字说明约占 70%，配置/示例代码约占 30% (70% text, 30% config/examples)。
  - **结构**: 必须提前构建全面的内容框架，然后根据框架填充详细内容。
- 标题不要手动编号（如 `### 1. xxx`），项目已配置自动编号。
- 使用清晰的标题层级，章节结构完整。
- 文字为主，可适当使用表格、列表辅助说明。
- 配置示例使用 YAML/JSON/TOML 等格式的代码块展示，但不写编程代码。
- 操作步骤要具体、可执行，避免模糊描述。
- 场景实战部分要足够详细，读者能按步骤复现。
- 语言风格客观、实用、结构清楚，以段落叙述为主。
- 若文内没有图片，必须生成 SVG 封面并在 YAML 的 `image` 字段引用。

## 文档获取流程

1. **首先尝试获取官方文档**：使用 librarian agent 或 webfetch 工具查找官方文档。
2. **若找不到文档**：立即向用户询问，例如："我找不到 [工具名] 的官方文档，请问您能提供文档链接吗？"
3. **文档确认后再动笔**：确保对工具功能有准确理解后才开始撰写。

## 完成后操作

### 步骤1: 渲染文章 (CRITICAL)

创建文章后必须立即渲染，生成 HTML 文件：

```bash
# 渲染单文件
quarto render doc/[number]-[topic].qmd

# 确保无报错、格式正确
```

### 步骤2: 更新导航系统 (CRITICAL)

**⚠️ 重要顺序：创建文章 → 渲染文章 → 更新 _quarto.yml → 运行 generate_sections.R**

必须执行以下步骤，否则新文章无法在网站侧边栏和分类页显示。

**⚠️ 更新导航前务必验证**:

- 确认新文件已成功渲染（HTML 文件已生成）
- 确认文件编号无冲突
- 确认YAML元数据正确

1. **更新 `doc/_quarto.yml`**:

   - 找到 `sidebar` -> `contents` -> `机器学习与AI` -> `AI 工具` 部分。
   - 添加新条目，**严格遵守 14 空格缩进**:
     ```yaml
               - text: "文章标题"
                 href: "[number]-[topic].qmd"
     ```

2. **运行自动生成脚本 (MANDATORY - 在更新 _quarto.yml 之后)**:

   - ⚠️ **必须在 _quarto.yml 更新后运行**，否则新的文章链接不会出现在 sections 中
   - 此脚本会根据 `_quarto.yml` 更新 `sections/machine-learning.qmd` 等分类索引页。

   ```bash
   # 在 doc 目录下运行
   cd doc && Rscript generate_sections.R
   ```

3. **渲染 sections 页面 (MANDATORY - 必须执行)**:

   ⚠️ **运行 generate_sections.R 后必须立即渲染 sections 页面！**

   ```bash
   # 渲染 machine-learning 页面（新增文章所在分类）
   # ⚠️ 注意：不要使用 --output-dir 参数，让 Quarto 自动输出到正确位置
   cd doc && quarto render sections/machine-learning.qmd

   # 如果需要，也渲染主页以更新导航
   quarto render index.qmd
   ```

   **注意**：这里的渲染是生成分类索引页面，不是文章本身。文章本身已在步骤1中渲染。

   **为什么必须渲染 sections 页面**：
   - generate_sections.R 只更新 .qmd 源文件
   - 必须渲染才能生成 HTML，新文章链接才会出现在网站侧边栏

   **⚠️ 警告：不要使用 `--output-dir` 参数**：
   - 错误：`quarto render sections/machine-learning.qmd --output-dir ../public/sections`
   - 这会导致输出到 `public/sections/sections/` 嵌套目录
   - 正确：直接在 doc 目录下运行 `quarto render sections/machine-learning.qmd`
   - Quarto 会根据 `_quarto.yml` 中的 `output-dir` 配置自动输出到正确位置

4. **验证 sections 已更新**:

   ```bash
   # 检查新文章是否出现在对应的 section 中
   grep "[number]-[topic]" doc/sections/machine-learning.qmd
   ```

### 步骤3: 更新学习指南和 README (MANDATORY)

1. **更新 `doc/0001-guide.rmd`**：
   - 在对应分类表格中添加新教程条目
   - 保持与现有格式一致
   - 链接使用 `.html` 后缀

2. **同步更新 `README.md`**：
   - 在对应分类的折叠块中添加新教程条目
   - 保持与 guide 内容一致
   - README 中的教程链接使用 `.html` 后缀

### 步骤4: 最终渲染与提交

1. **重新渲染受影响页面**:

   ```bash
   quarto render doc/sections/machine-learning.qmd
   quarto render doc/index.qmd
   ```

2. **提交代码**:

   ```bash
   git add doc/[number]-[topic].qmd doc/images/[topic]-cover.svg
   git add doc/_quarto.yml doc/0001-guide.rmd README.md doc/sections/machine-learning.qmd
   git commit -m "feat(ai-tools): 新增[工具名称]教程"
   ```

示例主题：OpenCode、Cursor、GitHub Copilot、Claude、ChatGPT 使用技巧等。
如果未指定具体工具或使用场景，请先提出澄清问题。
