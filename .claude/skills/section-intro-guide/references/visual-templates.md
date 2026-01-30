# 入门指南封面与 AI 示意图 SVG 模板

## 1. 封面图生成 (MANDATORY)
每篇教程必须有封面图，路径必须与 YAML 中的 `image` 字段匹配。

### 模板 A: 基础主题封面
```r
library(ggplot2)
cover <- ggplot() +
  annotate("text", x = 0.5, y = 0.6, label = "[教程主题]", size = 24, fontface = "bold", color = "#2c3e50") +
  annotate("text", x = 0.5, y = 0.4, label = "入门指南", size = 10, color = "#7f8c8d") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#ecf0f1", color = NA))
ggsave("doc/images/[number]-[topic]-cover.svg", cover, width = 8, height = 4.5, bg = "white")
```

## 2. 文章内 AI 示意图 (MANDATORY)
路径: `doc/images/diagrams/guide-[topic]-[type].svg`

### 模板 1: 学习路线图 (三阶段)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="300" viewBox="0 0 900 300">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#3b82f6"/>
    </marker>
  </defs>
  <rect x="50" y="80" width="240" height="140" rx="8" fill="#e0f2fe" stroke="#0369a1" stroke-width="2"/>
  <text x="170" y="110" font-size="16" font-weight="bold" text-anchor="middle" fill="#003d5c">入门基础</text>
  <text x="170" y="135" font-size="11" fill="#003d5c">• 基本语法</text>
  <text x="170" y="155" font-size="11" fill="#003d5c">• 数据类型</text>
  <line x1="290" y1="150" x2="330" y2="150" stroke="#3b82f6" stroke-width="3" marker-end="url(#arrow)"/>
  <rect x="330" y="80" width="240" height="140" rx="8" fill="#bfdbfe" stroke="#1e40af" stroke-width="2"/>
  <text x="450" y="110" font-size="16" font-weight="bold" text-anchor="middle" fill="#1e3a8a">进阶应用</text>
  <text x="450" y="135" font-size="11" fill="#1e3a8a">• 数据处理</text>
  <text x="450" y="155" font-size="11" fill="#1e3a8a">• 可视化</text>
  <line x1="570" y1="150" x2="610" y2="150" stroke="#3b82f6" stroke-width="3" marker-end="url(#arrow)"/>
  <rect x="610" y="80" width="240" height="140" rx="8" fill="#7dd3fc" stroke="#0284c7" stroke-width="2"/>
  <text x="730" y="110" font-size="16" font-weight="bold" text-anchor="middle" fill="#003d5c">实战项目</text>
  <text x="730" y="135" font-size="11" fill="#003d5c">• 完整分析</text>
  <text x="730" y="155" font-size="11" fill="#003d5c">• 论文复现</text>
  <text x="450" y="40" font-size="18" font-weight="bold" text-anchor="middle" fill="#0f172a">R语言学习三阶段路线图</text>
</svg>
```

### 模板 2: 数据结构体系
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="700" height="450" viewBox="0 0 700 450">
  <rect x="225" y="20" width="250" height="60" rx="8" fill="#1e40af" stroke="#0f172a" stroke-width="2"/>
  <text x="350" y="55" font-size="14" font-weight="bold" text-anchor="middle" fill="white">向量 (vector)</text>
  <line x1="350" y1="80" x2="200" y2="130" stroke="#64748b" stroke-width="2"/>
  <line x1="350" y1="80" x2="500" y2="130" stroke="#64748b" stroke-width="2"/>
  <rect x="50" y="130" width="300" height="60" rx="8" fill="#3b82f6" stroke="#1e40af" stroke-width="2"/>
  <text x="200" y="165" font-size="13" font-weight="bold" text-anchor="middle" fill="white">同类向量 (atomic)</text>
  <rect x="350" y="130" width="300" height="60" rx="8" fill="#7c3aed" stroke="#5b21b6" stroke-width="2"/>
  <text x="500" y="165" font-size="13" font-weight="bold" text-anchor="middle" fill="white">递归结构 (recursive)</text>
  <text x="350" y="25" font-size="16" font-weight="bold" text-anchor="middle" fill="#0f172a">R语言数据结构体系</text>
</svg>
```
