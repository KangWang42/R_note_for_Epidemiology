# ============================================================================
# 自动生成 Section 页面脚本
#
# 功能：从 _quarto.yml 读取侧边栏配置，自动生成 sections/*.qmd 文件
# 使用方法：在 doc 目录下运行 source("generate_sections.R")
# ============================================================================

library(yaml)
library(stringr)

# Section 配置信息（标题、副标题和说明）
section_config <- list(
  "入门指南" = list(
    file = "sections/guide.qmd",
    title = "入门指南",
    subtitle = "从零开始学习 R 语言的完整路线图",
    hero_title = "入门指南",
    hero_desc = "第一次来？这里有完整的学习路线和教程目录，帮你快速找到想学的内容。",
    grid_min_width = "300px"
  ),
  "EpiAgentKit 科研 Skills 库" = list(
    file = "sections/epiagentkit.qmd",
    title = "EpiAgentKit 科研 Skills 库",
    subtitle = "覆盖证据、项目、分析、论文、视觉、汇报、交付与审查的完整科研工作流",
    hero_title = "EpiAgentKit 科研 Skills 库",
    hero_desc = "20 个可组合的科研 Skills，每个技能均有独立、完整的能力说明与使用边界。",
    grid_min_width = "300px"
  ),
  "实用 R 包" = list(
    file = "sections/packages.qmd",
    title = "实用 R 包",
    subtitle = "提高效率的各类 R 包，从数据清洗到统计分析",
    hero_title = "R 包工具库",
    hero_desc = "这里收集了提高效率的各类 R 包，涵盖**表格制作**、**数据处理**和**模型整理**等方面。",
    grid_min_width = "300px"
  ),
  "数据可视化" = list(
    file = "sections/visualization.qmd",
    title = "数据可视化",
    subtitle = "一图胜千言，ggplot2 及其扩展包的绑图技巧",
    hero_title = "数据可视化库",
    hero_desc = "从**基础入门**、**图形组合**到**高级美化**，帮助你制作出版级别的数据可视化。",
    grid_min_width = "280px"
  ),
  "统计分析方法" = list(
    file = "sections/statistics.qmd",
    title = "统计分析方法",
    subtitle = "从基础回归到因果推断，系统掌握核心统计方法",
    hero_title = "统计建模方法库",
    hero_desc = "这里收集了使用 R 语言实现的各类分析方法，涵盖**回归分析**、**生存分析**、**因果推断**、**高级建模**等领域。",
    grid_min_width = "300px"
  ),
  "实用操作" = list(
    file = "sections/operation.qmd",
    title = "实用操作",
    subtitle = "日常科研中的小技巧与工作流优化",
    hero_title = "实用操作指南",
    hero_desc = "日常科研中遇到的小技巧、环境配置和数据导入导出方法。",
    grid_min_width = "300px"
  ),
  "机器学习与人工智能" = list(
    file = "sections/machine-learning.qmd",
    title = "机器学习与人工智能",
    subtitle = "从传统机器学习到深度学习的完整技术栈",
    hero_title = "机器学习与人工智能",
    hero_desc = "本部分涵盖从传统机器学习到深度学习的完整技术栈，帮助您构建端到端的机器学习能力。",
    grid_min_width = "300px"
  ),
  "特殊应用" = list(
    file = "sections/special.qmd",
    title = "特殊应用",
    subtitle = "卫生经济学、质性研究和信号处理等专业领域应用",
    hero_title = "特殊应用",
    hero_desc = "本部分涵盖了在特定领域和专业场景中使用的 R 语言应用方法。",
    grid_min_width = "300px"
  )
)

# 子分类描述（用于卡片下方的简短说明）
category_descriptions <- list(
  "学习路线" = "新手入门必读",
  "基础知识" = "R 基础与工具",
  "工作流程" = "科研工作流",
  "总览与安装" = "认识架构、安装方式与 20 个 Skills 全景",
  "原则与证据" = "锁定研究口径并核验方法与来源",
  "项目与分析" = "初始化项目、执行统计分析并生成图件",
  "论文与报告" = "生成论文、投稿材料和专业报告",
  "科研视觉与汇报" = "制作非统计视觉与中山大学学术汇报",
  "咨询与审查" = "交付可复现成果并完成六层项目质控",
  "文件操作" = "可靠读写 Word、PDF、PowerPoint 和 Excel",
  "维护与扩展" = "维护 EpiAgentKit、创建 Skills 和整理版本历史",
  "表格制作" = "快速生成发表级表格",
  "数据处理" = "高效数据处理工具",
  "模型整理" = "模型结果整理工具",
  "图形基础" = "ggplot2 入门与配置",
  "图形组合" = "多图拼接与布局",
  "分布图" = "数据分布展示",
  "趋势图" = "变化趋势展示",
  "比较图" = "对比与排序",
  "关系图" = "多变量关系",
  "特殊图形" = "创意可视化",
  "专题图" = "学术专用图表",
  "其他图形" = "补充图表类型",
  "进阶美化" = "高级样式与扩展",
  "基础回归" = "经典回归方法",
  "生存分析" = "事件时间研究",
  "因果推断" = "从关联到因果",
  "高级建模" = "复杂数据结构",
  "贝叶斯统计" = "概率推断方法",
  "模型评估" = "验证与诊断",
  "综述方法" = "证据综合",
  "流行病学研究设计" = "常用研究设计",
  "机器学习框架" = "模型训练与评估",
  "深度学习" = "神经网络与序列模型",
  "人工智能工具" = "研究与编程工具",
  "数据导入导出" = "高效的数据读写",
  "数据清洗" = "数据质量保障",
  "数据转换" = "格式与类型转换",
  "文档写作" = "可重复研究报告",
  "开发环境" = "集成开发环境与工作流",
  "计算模拟" = "模拟与复杂系统",
  "卫生经济学" = "成本效益分析",
  "质性研究" = "文本与内容分析",
  "信号处理" = "时序信号分析",
  "环境流行病学" = "环境暴露研究",
  "建模方法" = "专题建模方法"
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
body-classes: section-page
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
      # 从分类名提取 anchor ID
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

  paste0(yaml_header, hero_section, cards)
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
