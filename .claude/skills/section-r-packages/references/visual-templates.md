# 实用 R 包封面与 AI 示意图 SVG 模板

## 1. 封面图生成 (MANDATORY)
每篇教程必须有封面图，路径必须与 YAML 中的 `image` 字段匹配。

### 模板 A: 基础主题封面
```r
library(ggplot2)
cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, label = "[包名]", size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, label = "R Package Tutorial", size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))
ggsave("doc/images/[number]-[topic]-cover.svg", cover, width = 8, height = 4.5, bg = "white")
```

## 2. 文章内 AI 示意图 (MANDATORY)
路径: `doc/images/diagrams/pkg-[topic]-[type].svg`

### 模板 1: 包架构图 (功能分类)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="400" viewBox="0 0 800 400">
  <circle cx="400" cy="200" r="50" fill="#1e40af" stroke="#0f172a" stroke-width="2"/>
  <text x="400" y="200" font-size="16" font-weight="bold" text-anchor="middle" dominant-baseline="middle" fill="white">[包名]</text>
  <rect x="300" y="30" width="100" height="60" rx="8" fill="#93c5fd" stroke="#3b82f6" stroke-width="2"/>
  <text x="350" y="55" font-size="13" font-weight="bold" text-anchor="middle" fill="#1e40af">功能A</text>
  <line x1="375" y1="90" x2="385" y2="150" stroke="#3b82f6" stroke-width="2"/>
  <rect x="80" y="80" width="100" height="60" rx="8" fill="#93c5fd" stroke="#3b82f6" stroke-width="2"/>
  <text x="130" y="105" font-size="13" font-weight="bold" text-anchor="middle" fill="#1e40af">功能B</text>
  <line x1="160" y1="140" x2="340" y2="180" stroke="#3b82f6" stroke-width="2"/>
</svg>
```

### 模板 2: 函数调用链 (工作流)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="200" viewBox="0 0 1000 200">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#2563eb"/>
    </marker>
  </defs>
  <rect x="20" y="60" width="140" height="80" rx="8" fill="#dbeafe" stroke="#3b82f6" stroke-width="2"/>
  <text x="90" y="90" font-size="14" font-weight="bold" text-anchor="middle" fill="#1e40af">步骤1</text>
  <line x1="160" y1="100" x2="200" y2="100" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="200" y="60" width="140" height="80" rx="8" fill="#e9d5ff" stroke="#7c3aed" stroke-width="2"/>
  <text x="270" y="90" font-size="14" font-weight="bold" text-anchor="middle" fill="#6d28d9">步骤2</text>
</svg>
```
