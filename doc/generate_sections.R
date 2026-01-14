# ============================================================================
# 自动生成 Section 页面脚本
#
# 功能：从 _quarto.yml 读取侧边栏配置，自动生成 sections/*.qmd 文件
# 使用方法：在 doc 目录下运行 source("generate_sections.R")
# ============================================================================

library(yaml)
library(stringr)

# Section 配置信息（标题、副标题、hero 图标和描述）
section_config <- list(
    "实用 R 包" = list(
        file = "sections/packages.qmd",
        title = "实用 R 包",
        subtitle = "提高效率的各类 R 包，从数据清洗到统计分析",
        hero_icon = "📦",
        hero_title = "R 包工具库",
        hero_desc = "这里收集了提高效率的各类 R 包，涵盖**表格制作**、**数据处理**和**模型整理**等多个方面。每个包都附有详细的使用教程和实际案例。"
    ),
    "可视化教程" = list(
        file = "sections/visualization.qmd",
        title = "可视化教程",
        subtitle = "一图胜千言，ggplot2 及其扩展包的绘图技巧",
        hero_icon = "🎨",
        hero_title = "数据可视化库",
        hero_desc = "\"一图胜千言\"，这里记录了 ggplot2 及其扩展包的绑图技巧。从**基础入门**、**图形组合**到**高级美化**，帮助你制作出版级别的数据可视化。"
    ),
    "R 语言方法" = list(
        file = "sections/methods.qmd",
        title = "R 语言统计方法",
        subtitle = "从基础回归到因果推断，系统掌握生物统计学核心方法",
        hero_icon = "📊",
        hero_title = "统计建模方法库",
        hero_desc = "这里收集了使用 R 语言实现的各类分析方法，涵盖**回归分析**、**生存分析**、**因果推断**、**高级建模**、**机器学习**等领域。每篇教程都从原理出发，配以完整的代码实现和可视化。"
    ),
    "实用操作" = list(
        file = "sections/operation.qmd",
        title = "实用操作",
        subtitle = "日常科研中的小技巧与工作流优化",
        hero_icon = "🛠️",
        hero_title = "实用操作指南",
        hero_desc = "日常科研中遇到的小技巧、环境配置和数据导入导出方法。涵盖**数据输入输出**、**文档写作**和**开发环境**配置。"
    )
)

# 子分类描述（用于卡片下方的简短说明）
category_descriptions <- list(
    "📊 表格制作" = "快速生成发表级表格",
    "🔄 数据处理" = "高效数据处理工具",
    "📈 模型整理" = "模型结果整理工具",
    "🏗️ 图形基础" = "ggplot2 入门与基本配置",
    "🔀 图形组合" = "多图拼接与布局",
    "📊 统计图表" = "常用统计图绑制",
    "🗺️ 专题图类" = "特殊类型图表",
    "✨ 进阶美化" = "高级样式与扩展",
    "🔢 回归分析" = "经典回归方法",
    "⏱️ 生存分析" = "事件时间研究",
    "🎯 因果推断" = "从关联到因果",
    "📐 高级建模" = "复杂数据结构",
    "🤖 机器学习" = "预测建模与AI",
    "📋 数据预处理" = "数据质量保障",
    "📚 综述方法" = "证据综合",
    "🔬 特殊方法" = "领域专用技术",
    "📥 数据输入输出" = "高效的数据读写",
    "📝 文档写作" = "可重复研究报告",
    "💻 开发环境" = "IDE 与工作流"
)

# 将 href 转换为 HTML 链接（输出目录）
convert_href_to_html <- function(href) {
    # 移除开头的路径，转换为 HTML
    basename <- tools::file_path_sans_ext(basename(href))
    paste0("../", basename, ".html")
}

# 生成单个 section 的 QMD 内容
generate_section_qmd <- function(section_name, section_contents, config) {
    # YAML 头部
    yaml_header <- sprintf('---
title: "%s"
subtitle: "%s"
toc: false
---
', config$title, config$subtitle)

    # Hero section
    hero_section <- sprintf("
::: {.hero-section}
## %s %s

%s
:::

::: {.method-categories}
", config$hero_icon, config$hero_title, config$hero_desc)

    # 生成分类卡片
    cards <- ""

    for (category in section_contents) {
        if (!is.null(category$section)) {
            category_name <- category$section
            # 从分类名提取 anchor ID（去除 emoji 和空格）
            anchor_id <- str_trim(str_replace(category_name, "^[^\\p{L}]+", ""))

            # 获取分类描述
            desc <- category_descriptions[[category_name]]
            if (is.null(desc)) desc <- ""

            cards <- paste0(cards, sprintf("
::: {.category-card}
### %s {#%s}
%s

", category_name, anchor_id, desc))

            # 生成文章链接列表
            if (!is.null(category$contents)) {
                for (item in category$contents) {
                    if (!is.null(item$text) && !is.null(item$href)) {
                        html_href <- convert_href_to_html(item$href)
                        cards <- paste0(cards, sprintf("- [**%s**](%s)\n", item$text, html_href))
                    }
                }
            }

            cards <- paste0(cards, ":::\n")
        }
    }

    cards <- paste0(cards, "\n:::\n")

    # CSS 样式（所有 section 页面共用）
    css_style <- "
<style>
/* 禁用此页面的所有自动编号 */
h2::before, h3::before {
  content: none !important;
  counter-increment: none !important;
}

section.level2, section.level3 {
  counter-reset: none !important;
}

#title-block-header {
  margin-bottom: 1rem !important;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
  color: white !important;
  padding: 2rem !important;
  border-radius: 16px !important;
  margin-bottom: 1.5rem !important;
  margin-top: 0 !important;
  text-align: center !important;
}

.hero-section * {
  background: transparent !important;
  background-color: transparent !important;
}

.hero-section h2 {
  color: white !important;
  border-bottom: none !important;
  margin-top: 0 !important;
  margin-bottom: 0.5rem !important;
  font-size: 1.6rem !important;
}

.hero-section p {
  color: rgba(255,255,255,0.9) !important;
  font-size: 1rem !important;
  max-width: 700px !important;
  margin: 0 auto !important;
}

.method-categories {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.category-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  border: 1px solid #e5e7eb;
  transition: transform 0.2s, box-shadow 0.2s;
}

.category-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0,0,0,0.12);
}

.category-card h3 {
  font-size: 1.1rem;
  color: #1f2937;
  margin-top: 0;
  margin-bottom: 0.75rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid #e0e7ff;
}

.category-card p {
  font-size: 0.85rem;
  color: #6b7280;
  margin-bottom: 0.75rem;
}

.category-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.category-card li {
  padding: 0.4rem 0;
  font-size: 0.9rem;
  border-bottom: 1px solid #f3f4f6;
}

.category-card li:last-child {
  border-bottom: none;
}

.category-card a {
  color: #4f46e5;
  text-decoration: none;
  font-weight: 500;
}

.category-card a:hover {
  color: #3730a3;
}

@media (max-width: 768px) {
  .method-categories {
    grid-template-columns: 1fr;
  }

  .hero-section {
    padding: 1.5rem;
  }

  .hero-section h2 {
    font-size: 1.4rem;
  }
}
</style>
"

    paste0(yaml_header, hero_section, cards, css_style)
}

# 主函数：从 _quarto.yml 生成所有 section 页面
generate_all_sections <- function() {
    # 读取 _quarto.yml
    quarto_config <- yaml::read_yaml("_quarto.yml")

    # 获取侧边栏内容
    sidebar_contents <- quarto_config$website$sidebar$contents

    # 遍历每个 section
    for (section_item in sidebar_contents) {
        if (!is.null(section_item$section)) {
            section_name <- section_item$section

            # 检查是否有对应的配置
            if (section_name %in% names(section_config)) {
                config <- section_config[[section_name]]

                # 生成 QMD 内容
                qmd_content <- generate_section_qmd(
                    section_name,
                    section_item$contents,
                    config
                )

                # 写入文件
                writeLines(qmd_content, config$file, useBytes = TRUE)
                message(sprintf("✅ 已生成: %s", config$file))
            }
        }
    }

    message("\n🎉 所有 section 页面已更新！")
}

# 运行生成
generate_all_sections()
