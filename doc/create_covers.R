library(ggplot2)

# 封面1: 渐变条形图 - 蓝紫色系
set.seed(1)
df1 <- data.frame(x = 1:6, y = c(3, 5, 4, 6, 5, 7))
p1 <- ggplot(df1, aes(x = factor(x), y = y, fill = y)) +
  geom_col(width = 0.7) +
  scale_fill_gradient(low = "#6366f1", high = "#a855f7") +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#faf5ff", color = NA))
ggsave("figure/default-cover1.png", p1, width = 6, height = 4, dpi = 150)

# 封面2: 散点图 - 青绿色系
set.seed(2)
df2 <- data.frame(x = rnorm(30), y = rnorm(30), size = runif(30, 2, 8))
p2 <- ggplot(df2, aes(x, y, size = size, color = size)) +
  geom_point(alpha = 0.7) +
  scale_color_gradient(low = "#06b6d4", high = "#10b981") +
  scale_size_continuous(range = c(3, 10)) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#f0fdfa", color = NA))
ggsave("figure/default-cover2.png", p2, width = 6, height = 4, dpi = 150)

# 封面3: 折线图 - 橙红色系
set.seed(3)
df3 <- data.frame(x = 1:8, y = cumsum(rnorm(8, 0.5, 1)))
p3 <- ggplot(df3, aes(x, y)) +
  geom_area(fill = "#fed7aa", alpha = 0.5) +
  geom_line(color = "#f97316", linewidth = 2) +
  geom_point(color = "#ea580c", size = 4) +
  theme_void() +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#fff7ed", color = NA))
ggsave("figure/default-cover3.png", p3, width = 6, height = 4, dpi = 150)

cat("3 default covers created!\n")
