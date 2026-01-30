# 机器学习与 AI 封面与 AI 示意图 SVG 模板

## 1. 封面图生成 (MANDATORY)
每篇教程必须有封面图，路径必须与 YAML 中的 `image` 字段匹配。

### 模板 A: 基础主题封面
```r
library(ggplot2)
cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, label = "[教程主题]", size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, label = "Machine Learning", size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))
ggsave("doc/images/[number]-[topic]-cover.svg", cover, width = 8, height = 4.5, bg = "white")
```

## 2. 文章内 AI 示意图 (MANDATORY)
路径: `doc/images/diagrams/ml-[topic]-[type].svg`

### 模板 1: ML 工作流 (通用训练流程)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="300" viewBox="0 0 900 300">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#2563eb"/>
    </marker>
  </defs>
  <rect x="30" y="100" width="150" height="80" rx="8" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
  <text x="105" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#1e40af">数据准备</text>
  <line x1="180" y1="140" x2="220" y2="140" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="220" y="100" width="150" height="80" rx="8" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
  <text x="295" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#1e40af">特征工程</text>
  <line x1="370" y1="140" x2="410" y2="140" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="410" y="100" width="150" height="80" rx="8" fill="#fed7aa" stroke="#f97316" stroke-width="2"/>
  <text x="485" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#9a3412">模型训练</text>
  <line x1="560" y1="140" x2="600" y2="140" stroke="#2563eb" stroke-width="2" marker-end="url(#arrow)"/>
  <rect x="600" y="100" width="150" height="80" rx="8" fill="#d1fae5" stroke="#10b981" stroke-width="2"/>
  <text x="675" y="135" font-size="16" font-weight="bold" text-anchor="middle" fill="#065f46">模型评估</text>
  <path d="M 675,180 L 675,220 L 485,220 L 485,180" fill="none" stroke="#dc2626" stroke-width="2" stroke-dasharray="5,5" marker-end="url(#arrow)"/>
  <text x="580" y="235" font-size="12" fill="#dc2626">超参数调优</text>
</svg>
```

### 模板 2: 决策树分裂示意
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="600" height="400" viewBox="0 0 600 400">
  <rect x="220" y="30" width="160" height="60" rx="8" fill="#fef3c7" stroke="#f59e0b" stroke-width="2"/>
  <text x="300" y="55" font-size="14" font-weight="bold" text-anchor="middle" fill="#92400e">特征 A > X?</text>
  <line x1="250" y1="90" x2="150" y2="160" stroke="#64748b" stroke-width="2"/>
  <line x1="350" y1="90" x2="450" y2="160" stroke="#64748b" stroke-width="2"/>
  <rect x="70" y="160" width="160" height="60" rx="8" fill="#fef3c7" stroke="#f59e0b" stroke-width="2"/>
  <text x="150" y="185" font-size="14" font-weight="bold" text-anchor="middle" fill="#92400e">特征 B > Y?</text>
  <rect x="370" y="160" width="160" height="60" rx="8" fill="#d1fae5" stroke="#10b981" stroke-width="2"/>
  <text x="450" y="185" font-size="14" font-weight="bold" text-anchor="middle" fill="#065f46">类别: A</text>
</svg>
```
