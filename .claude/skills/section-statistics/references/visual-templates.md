# 封面图与 AI 示意图 SVG 模板库

## 1. 封面图设计原则
- **路径**: `doc/images/[topic]-cover.svg`
- **视觉**: 深色背景 + 渐变色 + 核心统计元素。
- **文字**: 标题字号 ≥ 56，副标题 ≥ 28。

## 2. 封面图模板
### 模板 A: 回归/曲线类 (线性回归, GAM, RCS)
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="675" viewBox="0 0 1200 675">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1e3a8a" />
      <stop offset="100%" stop-color="#3b82f6" />
    </linearGradient>
  </defs>
  <rect width="1200" height="675" fill="url(#bg)" />
  <line x1="150" y1="550" x2="1050" y2="550" stroke="#e2e8f0" stroke-width="2" opacity="0.6"/>
  <line x1="150" y1="550" x2="150" y2="150" stroke="#e2e8f0" stroke-width="2" opacity="0.6"/>
  <g fill="#93c5fd" opacity="0.6">
    <circle cx="250" cy="450" r="8"/><circle cx="350" cy="420" r="8"/><circle cx="450" cy="380" r="8"/>
  </g>
  <path d="M250,450 Q600,300 950,220" stroke="#fbbf24" stroke-width="4" fill="none" opacity="0.9"/>
  <text x="600" y="100" font-family="Arial" font-size="56" font-weight="bold" fill="white" text-anchor="middle">[方法中文名]</text>
  <text x="600" y="150" font-family="Arial" font-size="28" fill="#e0f2fe" text-anchor="middle">[English Name]</text>
</svg>
```

## 3. 文章内 AI 示意图模板
- **路径**: `doc/images/diagrams/stat-[topic]-[type].svg`
- **类型**:
    - `workflow`: 分析流程图 (矩形 + 箭头)
    - `principle`: 原理示意图 (对比组, 匹配过程)
    - `structure`: 数据结构图 (嵌套层级)
    - `decision`: 决策树 (菱形判断)

### 示例: PSM 匹配流程
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="800" height="400" viewBox="0 0 800 400">
  <!-- 包含处理组、对照组、计算PS、匹配后平衡的完整逻辑 -->
  <!-- 详见 section-statistics 原始 skill.md 第 668-725 行 -->
</svg>
```
