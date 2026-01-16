# update_categories.R
# 根据 _quarto.yml 侧边栏配置自动更新文章的 categories

library(yaml)
library(stringr)

# 读取 _quarto.yml
quarto_config <- yaml::read_yaml("_quarto.yml")

# 构建文件名到分类的映射
build_category_map <- function(config) {
    sidebar_contents <- config$website$sidebar$contents
    category_map <- list()

    for (section in sidebar_contents) {
        level1_name <- section$section # 一级分类

        if (!is.null(section$contents)) {
            for (subsection in section$contents) {
                level2_name <- subsection$section # 二级分类（包含emoji）
                # 清理emoji，保留文字
                level2_clean <- str_replace(level2_name, "^[^a-zA-Z\\u4e00-\\u9fff]+\\s*", "")

                if (!is.null(subsection$contents)) {
                    for (item in subsection$contents) {
                        if (!is.null(item$href)) {
                            # 提取文件名（去掉路径）
                            filename <- basename(item$href)
                            category_map[[filename]] <- list(
                                level1 = level1_name,
                                level2 = level2_clean
                            )
                        }
                    }
                }
            }
        }
    }

    return(category_map)
}

# 更新单个文件的 categories
update_file_categories <- function(filepath, level1, level2) {
    content <- readLines(filepath, encoding = "UTF-8", warn = FALSE)

    # 找到 YAML 头部
    yaml_start <- which(content == "---")[1]
    yaml_end <- which(content == "---")[2]

    if (is.na(yaml_start) || is.na(yaml_end)) {
        message("跳过 (无YAML): ", filepath)
        return(FALSE)
    }

    yaml_content <- content[(yaml_start + 1):(yaml_end - 1)]
    yaml_text <- paste(yaml_content, collapse = "\n")

    # 解析 YAML
    tryCatch(
        {
            yaml_data <- yaml::yaml.load(yaml_text)

            # 获取原有 categories
            old_cats <- yaml_data$categories
            if (is.null(old_cats)) old_cats <- c()

            # 移除旧的一级和二级分类（如果存在）
            all_level1 <- c(
                "入门指南", "实用R包", "统计分析方法", "机器学习与AI",
                "实用操作", "数据可视化", "特殊应用", "R语言方法", "可视化教程"
            )

            # 过滤掉旧的分类标签，只保留内容相关的标签
            filtered_cats <- old_cats[!old_cats %in% all_level1]
            # 移除可能的二级分类
            filtered_cats <- filtered_cats[!grepl("^(表格制作|数据处理|模型整理|基础回归|生存分析|因果推断|高级建模|贝叶斯统计|模型评估|综述方法|机器学习框架|深度学习|数据导入|数据清洗|数据转换|文档写作|开发环境|图形基础|图形组合|分布图|趋势图|比较图|关系图|特殊图形|专题图|其他图形|进阶美化|卫生经济学|质性研究|信号处理|学习路线|基础知识|工作流程)", filtered_cats)]

            # 构建新的 categories：一级 + 二级 + 其他标签（最多4个）
            new_cats <- unique(c(level1, level2, filtered_cats))
            if (length(new_cats) > 4) {
                new_cats <- new_cats[1:4]
            }

            # 更新 YAML
            yaml_data$categories <- new_cats

            # 生成新的 YAML 文本
            new_yaml <- yaml::as.yaml(yaml_data, unicode = TRUE)
            new_yaml_lines <- strsplit(new_yaml, "\n")[[1]]

            # 重建文件内容
            new_content <- c(
                "---",
                new_yaml_lines,
                "---",
                content[(yaml_end + 1):length(content)]
            )

            # 写回文件
            writeLines(new_content, filepath, useBytes = TRUE)
            message("更新: ", filepath, " -> [", paste(new_cats, collapse = ", "), "]")
            return(TRUE)
        },
        error = function(e) {
            message("错误 (", filepath, "): ", e$message)
            return(FALSE)
        }
    )
}

# 主流程
main <- function() {
    category_map <- build_category_map(quarto_config)

    message("找到 ", length(category_map), " 个文件映射")

    updated <- 0
    for (filename in names(category_map)) {
        if (file.exists(filename)) {
            cats <- category_map[[filename]]
            if (update_file_categories(filename, cats$level1, cats$level2)) {
                updated <- updated + 1
            }
        } else {
            message("文件不存在: ", filename)
        }
    }

    message("\n完成! 更新了 ", updated, " 个文件")
}

# 运行
main()
