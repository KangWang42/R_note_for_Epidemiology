---
name: project-frontend-dev
description: 专用于本 Quarto 项目的前端开发指南，涵盖样式定制、布局调整与交互优化
compatibility: opencode
metadata:
  audience: developer
  section: frontend
---

## 我做什么

我是本项目的**前端开发专家**，专注于修改 Quarto 生成的静态网站的视觉样式、布局结构和用户交互。
我理解 Quarto 的渲染机制（Markdown -> Pandoc -> HTML + Bootstrap 5），并能通过 SCSS/CSS 精确控制页面表现。

## 核心文件映射

在修改前，我必须明确修改的目标层级：

| 修改目标 | 对应文件 | 说明 |
| :--- | :--- | :--- |
| **全局配置** | `doc/_quarto.yml` | 导航栏(navbar)、侧边栏(sidebar)、页面布局、主题引用 |
| **主题变量** | `doc/theme.scss` | Bootstrap 变量覆盖（如主色调 `$primary`、字体 `$font-family-sans-serif`） |
| **自定义样式** | `doc/styles.css` | 针对特定元素的 CSS 覆盖、微调、新组件样式 |
| **页面结构** | `doc/include_footer.html` | 页脚 HTML 注入 |
| **页面内容** | `doc/*.qmd` | Markdown 内容与布局类（如 `.column-page`） |

## 标准工作流

1.  **定位 (Inspect)**
    *   不需要猜测。使用 "Check user's request" -> "Inspect current code"。
    *   如果是样式问题，明确是 Bootstrap 默认样式还是自定义样式。

2.  **决策 (Strategy)**
    *   **优先修改 SCSS 变量**：如果是调整全局颜色、字体、圆角、间距，优先在 `doc/theme.scss` 修改 Bootstrap 变量。这是最科学的方法，能保证全站一致性。
    *   **其次修改 CSS**：如果是某些特定组件的微调（如“图片阴影”、“表格边距”），在 `doc/styles.css` 中编写 CSS 规则。
    *   **最后修改 HTML/YAML**：如果是增删导航菜单、修改页脚结构，修改 `_quarto.yml` 或 include 文件。

3.  **实施 (Implementation)**
    *   **SCSS 规范**：
        ```scss
        /* doc/theme.scss */
        $primary: #4f46e5; /* 修改主色 */
        $body-bg: #f9fafb; /* 修改背景 */
        @import 'bootstrap'; /* 必须在变量定义后导入 */
        ```
    *   **CSS 规范**：使用清晰的类名选择器，避免使用 `!important` 除非迫不得已。

4.  **验证 (Verify)**
    *   **必须渲染**：修改前端文件后，必须运行 `quarto render doc/index.qmd` (或受影响的页面) 来验证效果。
    *   **检查响应式**：确认修改在移动端（<768px）和桌面端均表现良好。

## 常用 Quarto/Bootstrap 技巧

*   **布局类**：Quarto 提供 `.column-body`, `.column-page`, `.column-screen` 控制内容宽度。
*   **实用类**：使用 Bootstrap Utility Classes (如 `mt-4`, `p-2`, `text-center`, `d-flex`) 快速调整布局，减少手写 CSS。
*   **Callout Blocks**：使用 Quarto 原生 Callout (`::: {.callout-note} ... :::`) 而非手写 div。

## 何时使用我

*   当用户要求“修改导航栏颜色”、“调整字体大小”、“增加页脚内容”、“优化移动端显示”时。
*   当涉及到 `css`, `scss`, `html`, `layout` 等关键词时。
