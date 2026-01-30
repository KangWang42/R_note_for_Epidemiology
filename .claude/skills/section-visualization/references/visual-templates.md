# 可视化封面与 AI 示意图 SVG 模板

## 1. 封面图生成 (MANDATORY)
每篇教程必须有封面图，路径必须与 YAML 中的 `image` 字段匹配。

### 模板 A: 基础主题封面
```r
library(ggplot2)
cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, label = "[图表类型]", size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, label = "Data Visualization Guide", size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))
ggsave("doc/images/[topic]-cover.svg", cover, width = 8, height = 4.5, bg = "white")
```

### 模板 B: 专业示例封面
```r
library(ggplot2)
library(ggsci)
cover_plot <- ggplot(iris, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_boxplot(alpha = 0.8) +
  scale_fill_lancet() +
  theme_minimal(base_size = 14) +
  labs(title = "[图表类型]完全指南", subtitle = "Professional Data Visualization") +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5, face = "bold"), plot.subtitle = element_text(hjust = 0.5))
ggsave("doc/images/[topic]-cover.svg", cover_plot, width = 8, height = 4.5, dpi = 300, bg = "white")
```

## 2. 文章内 AI 示意图 (MANDATORY)
路径: `doc/images/diagrams/viz-[topic]-[type].svg`

### 模板 1: 流程图 (ggplot2 绘图流程)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="400" viewBox="0 0 800 400">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#2563eb"/>
    </marker>
  </defs>
  <rect x="50" y="150" width="120" height="60" rx="5" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
  <text x="110" y="185" font-size="16" text-anchor="middle" fill="#1e40af">数据准备</text>
  <line x1="170" y1="180" x2="220" y2="180" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="220" y="150" width="120" height="60" rx="5" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
  <text x="280" y="185" font-size="16" text-anchor="middle" fill="#1e40af">映射变量</text>
  <line x1="340" y1="180" x2="390" y2="180" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="390" y="150" width="120" height="60" rx="5" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
  <text x="450" y="185" font-size="16" text-anchor="middle" fill="#1e40af">几何对象</text>
  <line x1="510" y1="180" x2="560" y2="180" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="560" y="150" width="120" height="60" rx="5" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
  <text x="620" y="185" font-size="16" text-anchor="middle" fill="#1e40af">主题美化</text>
  <text x="400" y="40" font-size="20" font-weight="bold" text-anchor="middle" fill="#1e293b">ggplot2绘图流程</text>
</svg>
```

### 模板 2: 决策树 (图表类型选择)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
  <rect x="320" y="30" width="160" height="50" rx="25" fill="#fef3c7" stroke="#f59e0b" stroke-width="2"/>
  <text x="400" y="60" font-size="14" text-anchor="middle" fill="#92400e">数据类型?</text>
  <line x1="400" y1="80" x2="200" y2="150" stroke="#64748b" stroke-width="2"/>
  <line x1="400" y1="80" x2="400" y2="150" stroke="#64748b" stroke-width="2"/>
  <line x1="400" y1="80" x2="600" y2="150" stroke="#64748b" stroke-width="2"/>
  <rect x="120" y="150" width="160" height="50" rx="25" fill="#fef3c7" stroke="#f59e0b" stroke-width="2"/>
  <text x="200" y="180" font-size="14" text-anchor="middle" fill="#92400e">分类变量</text>
  <rect x="320" y="150" width="160" height="50" rx="25" fill="#fef3c7" stroke="#f59e0b" stroke-width="2"/>
  <text x="400" y="180" font-size="14" text-anchor="middle" fill="#92400e">数值变量</text>
  <rect x="520" y="150" width="160" height="50" rx="25" fill="#fef3c7" stroke="#f59e0b" stroke-width="2"/>
  <text x="600" y="180" font-size="14" text-anchor="middle" fill="#92400e">时间序列</text>
  <rect x="120" y="250" width="160" height="50" rx="5" fill="#d1fae5" stroke="#10b981" stroke-width="2"/>
  <text x="200" y="280" font-size="14" text-anchor="middle" fill="#065f46">柱状图/饼图</text>
  <rect x="320" y="250" width="160" height="50" rx="5" fill="#d1fae5" stroke="#10b981" stroke-width="2"/>
  <text x="400" y="280" font-size="14" text-anchor="middle" fill="#065f46">箱线图/直方图</text>
  <rect x="520" y="250" width="160" height="50" rx="5" fill="#d1fae5" stroke="#10b981" stroke-width="2"/>
  <text x="600" y="280" font-size="14" text-anchor="middle" fill="#065f46">折线图/面积图</text>
</svg>
```
