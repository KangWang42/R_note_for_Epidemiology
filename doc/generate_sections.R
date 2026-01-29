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
  "入门指南" = list(
    file = "sections/guide.qmd",
    title = "入门指南",
    subtitle = "从零开始学习 R 语言的完整路线图",
    hero_icon = "📘",
    hero_title = "入门指南",
    hero_desc = "第一次来？这里有完整的学习路线和教程目录，帮你快速找到想学的内容。",
    grid_min_width = "300px"
  ),
  "实用 R 包" = list(
    file = "sections/packages.qmd",
    title = "实用 R 包",
    subtitle = "提高效率的各类 R 包，从数据清洗到统计分析",
    hero_icon = "📦",
    hero_title = "R 包工具库",
    hero_desc = "这里收集了提高效率的各类 R 包，涵盖**表格制作**、**数据处理**和**模型整理**等方面。",
    grid_min_width = "300px"
  ),
  "数据可视化" = list(
    file = "sections/visualization.qmd",
    title = "数据可视化",
    subtitle = "一图胜千言，ggplot2 及其扩展包的绑图技巧",
    hero_icon = "🎨",
    hero_title = "数据可视化库",
    hero_desc = "从**基础入门**、**图形组合**到**高级美化**，帮助你制作出版级别的数据可视化。",
    grid_min_width = "280px"
  ),
  "统计分析方法" = list(
    file = "sections/statistics.qmd",
    title = "统计分析方法",
    subtitle = "从基础回归到因果推断，系统掌握核心统计方法",
    hero_icon = "📊",
    hero_title = "统计建模方法库",
    hero_desc = "这里收集了使用 R 语言实现的各类分析方法，涵盖**回归分析**、**生存分析**、**因果推断**、**高级建模**等领域。",
    grid_min_width = "300px"
  ),
  "实用操作" = list(
    file = "sections/operation.qmd",
    title = "实用操作",
    subtitle = "日常科研中的小技巧与工作流优化",
    hero_icon = "🛠️",
    hero_title = "实用操作指南",
    hero_desc = "日常科研中遇到的小技巧、环境配置和数据导入导出方法。",
    grid_min_width = "300px"
  ),
  "机器学习与AI" = list(
    file = "sections/machine-learning.qmd",
    title = "机器学习与AI",
    subtitle = "从传统机器学习到深度学习的完整技术栈",
    hero_icon = "🤖",
    hero_title = "机器学习与AI",
    hero_desc = "本部分涵盖从传统机器学习到深度学习的完整技术栈，帮助您构建端到端的机器学习能力。",
    grid_min_width = "300px"
  ),
  "特殊应用" = list(
    file = "sections/special.qmd",
    title = "特殊应用",
    subtitle = "卫生经济学、质性研究和信号处理等专业领域应用",
    hero_icon = "🔬",
    hero_title = "特殊应用",
    hero_desc = "本部分涵盖了在特定领域和专业场景中使用的 R 语言应用方法。",
    grid_min_width = "300px"
  )
)

# 子分类描述（用于卡片下方的简短说明）
category_descriptions <- list(
  "📘 学习路线" = "新手入门必读",
  "📖 基础知识" = "R 基础与工具",
  "⚙️ 工作流程" = "科研工作流",
  "📊 表格制作" = "快速生成发表级表格",
  "🔄 数据处理" = "高效数据处理工具",
  "📈 模型整理" = "模型结果整理工具",
  "🏗️ 图形基础" = "ggplot2 入门与配置",
  "🔀 图形组合" = "多图拼接与布局",
  "📊 分布图" = "数据分布展示",
  "📈 趋势图" = "变化趋势展示",
  "📊 比较图" = "对比与排序",
  "🔄 关系图" = "多变量关系",
  "🎨 特殊图形" = "创意可视化",
  "🗺️ 专题图" = "学术专用图表",
  "📊 其他图形" = "补充图表类型",
  "✨ 进阶美化" = "高级样式与扩展",
  "📊 基础回归" = "经典回归方法",
  "⏱️ 生存分析" = "事件时间研究",
  "🎯 因果推断" = "从关联到因果",
  "🎯 因果推断(续)" = "高级因果方法",
  "📐 高级建模" = "复杂数据结构",
  "📈 贝叶斯统计" = "概率推断方法",
  "🎯 模型评估" = "验证与诊断",
  "📚 综述方法" = "证据综合",
  "🤖 机器学习框架" = "模型训练与评估",
  "🧠 深度学习" = "神经网络与序列模型",
  "📥 数据导入导出" = "高效的数据读写",
  "🧹 数据清洗" = "数据质量保障",
  "🔄 数据转换" = "格式与类型转换",
  "📝 文档写作" = "可重复研究报告",
  "💻 开发环境" = "IDE 与工作流",
  "💰 卫生经济学" = "成本效益分析",
  "🔬 质性研究" = "文本与内容分析",
  "📡 信号处理" = "时序信号分析"
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

  # Hero section - 只保留标题（无emoji）
  hero_section <- sprintf("
::: {.hero-section}
## %s
:::

::: {.method-categories}
", config$hero_title)

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
  padding: 2rem 1rem !important;
  text-align: center !important;
  background: transparent !important;
  margin: 60px 0 1.5rem 0 !important;
}


.hero-section p {
  color: #6b7280 !important;
  font-size: 1.1rem !important;
  max-width: 600px !important;
  margin: 0.75rem auto 0 !important;
}

.hero-section h2 {
  color: #1f2937 !important;
  border-bottom: none !important;
  margin: 0 !important;
  font-size: 2.25rem !important;
  font-weight: 600 !important;
  letter-spacing: -0.02em !important;
  text-align: center !important;
  width: 100% !important;
  display: block !important;
}

/* 隐藏 Hero 标题的锚点图标以保证完美居中 */
.hero-section .anchorjs-link {
  display: none !important;
}

.method-categories {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(GRID_MIN_WIDTH, 1fr));
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

  # 替换 grid_min_width
  grid_min_width <- ifelse(is.null(config$grid_min_width), "300px", config$grid_min_width)
  css_style <- str_replace(css_style, "GRID_MIN_WIDTH", grid_min_width)

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
