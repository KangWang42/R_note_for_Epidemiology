# 实用操作封面与 AI 示意图 SVG 模板

## 1. 封面图生成 (MANDATORY)
每篇教程必须有封面图，路径必须与 YAML 中的 `image` 字段匹配。

### 模板 A: 基础主题封面
```r
library(ggplot2)
cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, label = "[教程主题]", size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, label = "Operation Guide", size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))
ggsave("doc/images/[number]-[topic]-cover.svg", cover, width = 8, height = 4.5, bg = "white")
```

## 2. 文章内 AI 示意图 (MANDATORY)
路径: `doc/images/diagrams/ops-[topic]-[type].svg`

### 模板 1: 数据处理管道
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="300" viewBox="0 0 900 300">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#3b82f6"/>
    </marker>
  </defs>
  <rect x="30" y="100" width="130" height="80" rx="8" fill="#dbeafe" stroke="#3b82f6" stroke-width="2"/>
  <text x="95" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#1e40af">数据导入</text>
  <line x1="160" y1="140" x2="200" y2="140" stroke="#3b82f6" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="200" y="100" width="130" height="80" rx="8" fill="#fed7aa" stroke="#f97316" stroke-width="2"/>
  <text x="265" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#92400e">数据清洗</text>
  <line x1="330" y1="140" x2="370" y2="140" stroke="#3b82f6" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="370" y="100" width="130" height="80" rx="8" fill="#fed7aa" stroke="#f97316" stroke-width="2"/>
  <text x="435" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#92400e">数据转换</text>
  <line x1="500" y1="140" x2="540" y2="140" stroke="#3b82f6" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="540" y="100" width="130" height="80" rx="8" fill="#d1fae5" stroke="#10b981" stroke-width="2"/>
  <text x="605" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#065f46">结果输出</text>
</svg>
```

### 模板 2: 项目目录结构
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="300" viewBox="0 0 400 300">
  <text x="20" y="30" font-family="monospace" font-size="14" fill="#1e293b">project/</text>
  <text x="40" y="60" font-family="monospace" font-size="14" fill="#1e293b">├── data/</text>
  <text x="60" y="90" font-family="monospace" font-size="14" fill="#64748b">│   ├── raw/</text>
  <text x="60" y="120" font-family="monospace" font-size="14" fill="#64748b">│   └── processed/</text>
  <text x="40" y="150" font-family="monospace" font-size="14" fill="#1e293b">├── scripts/</text>
  <text x="40" y="180" font-family="monospace" font-size="14" fill="#1e293b">├── output/</text>
  <text x="40" y="210" font-family="monospace" font-size="14" fill="#1e293b">└── doc/</text>
</svg>
```
