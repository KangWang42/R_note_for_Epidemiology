# 特殊应用封面与 AI 示意图 SVG 模板

## 1. 封面图生成 (MANDATORY)
每篇教程必须有封面图，路径必须与 YAML 中的 `image` 字段匹配。

### 路径规范
- **路径**: `doc/images/[number]-[topic]-cover.svg`
- **尺寸**: 1200×675 (16:9 比例)
- **格式**: SVG

### 模板 A: 渐变背景 + 核心视觉元素
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="675" viewBox="0 0 1200 675">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0f172a" />
      <stop offset="100%" stop-color="#1e40af" />
    </linearGradient>
  </defs>
  <rect width="1200" height="675" fill="url(#bg)" />
  
  <!-- 中文标题 -->
  <text x="600" y="280" font-family="Arial, sans-serif" font-size="64" font-weight="bold" 
        fill="white" text-anchor="middle">元胞自动机</text>
  
  <!-- 英文副标题 -->
  <text x="600" y="350" font-family="Arial, sans-serif" font-size="32" 
        fill="#93c5fd" text-anchor="middle">Cellular Automata</text>
  
  <!-- 装饰性网格图案 -->
  <g opacity="0.3" stroke="#60a5fa" stroke-width="1" fill="none">
    <rect x="100" y="450" width="40" height="40" />
    <rect x="140" y="450" width="40" height="40" />
    <rect x="180" y="450" width="40" height="40" />
  </g>
</svg>
```

### 模板 B: 简洁文字型
```r
library(ggplot2)
cover <- ggplot() +
  annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 1, fill = "#1e3a8a") +
  annotate("text", x = 0.5, y = 0.55, label = "元胞自动机", 
           size = 24, fontface = "bold", color = "white") +
  annotate("text", x = 0.5, y = 0.45, label = "Cellular Automata", 
           size = 12, color = "#93c5fd") +
  theme_void() +
  coord_fixed(ratio = 16/9)

ggsave("doc/images/6001-cellular-automata-cover.svg", cover, 
       width = 12, height = 6.75, bg = "white")
```

## 2. 文章内 AI 示意图 (MANDATORY)

### 路径规范
- **路径**: `doc/images/diagrams/spc-[topic]-[type].svg`
- **推荐尺寸**: `viewBox="0 0 1400 800"` (宽 1400, 高 800)
- **格式**: SVG
- **每篇至少 2 张**

### 类型说明
- `structure`: 结构示意图（元胞网格、邻域类型）
- `workflow`: 流程图（算法步骤）
- `comparison`: 对比表格（方法对比）
- `example`: 示例演示（规则演化）

### 模板 1: 元胞自动机结构图
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="800" viewBox="0 0 1400 800">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#2563eb"/>
    </marker>
  </defs>
  
  <!-- 标题 -->
  <text x="700" y="50" font-family="Arial" font-size="28" font-weight="bold" 
        text-anchor="middle" fill="#1e3a8a">元胞自动机基本结构</text>
  
  <!-- 元胞网格 -->
  <g transform="translate(100, 120)">
    <rect x="0" y="0" width="400" height="400" fill="#e0f2fe" stroke="#0369a1" stroke-width="2" rx="8"/>
    <text x="200" y="30" font-size="18" font-weight="bold" text-anchor="middle" fill="#0c4a6e">元胞 (Cell)</text>
    
    <!-- 3x3 网格 -->
    <g stroke="#0891b2" stroke-width="1" fill="white">
      <rect x="120" y="80" width="50" height="50"/>
      <rect x="175" y="80" width="50" height="50"/>
      <rect x="230" y="80" width="50" height="50"/>
      <rect x="120" y="135" width="50" height="50" fill="#0ea5e9"/>
      <rect x="175" y="135" width="50" height="50"/>
      <rect x="230" y="135" width="50" height="50"/>
      <rect x="120" y="190" width="50" height="50"/>
      <rect x="175" y="190" width="50" height="50"/>
      <rect x="230" y="190" width="50" height="50"/>
    </g>
    
    <text x="200" y="270" font-size="14" text-anchor="middle" fill="#0c4a6e">当前元胞</text>
  </g>
  
  <!-- 状态 -->
  <g transform="translate(600, 120)">
    <rect x="0" y="0" width="300" height="200" fill="#fef3c7" stroke="#f59e0b" stroke-width="2" rx="8"/>
    <text x="150" y="30" font-size="18" font-weight="bold" text-anchor="middle" fill="#92400e">状态 (State)</text>
    
    <circle cx="80" cy="100" r="30" fill="white" stroke="#f59e0b" stroke-width="2"/>
    <text x="80" y="105" font-size="14" text-anchor="middle" fill="#92400e">0</text>
    <text x="80" y="160" font-size="12" text-anchor="middle" fill="#92400e">死亡</text>
    
    <circle cx="220" cy="100" r="30" fill="#f59e0b" stroke="#f59e0b" stroke-width="2"/>
    <text x="220" y="105" font-size="14" text-anchor="middle" fill="white">1</text>
    <text x="220" y="160" font-size="12" text-anchor="middle" fill="#92400e">存活</text>
  </g>
  
  <!-- 规则 -->
  <g transform="translate(1000, 120)">
    <rect x="0" y="0" width="300" height="400" fill="#dcfce7" stroke="#16a34a" stroke-width="2" rx="8"/>
    <text x="150" y="30" font-size="18" font-weight="bold" text-anchor="middle" fill="#166534">规则 (Rule)</text>
    
    <text x="20" y="80" font-size="14" fill="#166534">• 邻居数 &lt; 2: 死亡</text>
    <text x="20" y="120" font-size="14" fill="#166534">• 邻居数 = 2,3: 存活</text>
    <text x="20" y="160" font-size="14" fill="#166534">• 邻居数 &gt; 3: 死亡</text>
    <text x="20" y="200" font-size="14" fill="#166534">• 邻居数 = 3: 复活</text>
  </g>
  
  <!-- 箭头连接 -->
  <line x1="520" y1="320" x2="580" y2="220" stroke="#6366f1" stroke-width="3" marker-end="url(#arrow)"/>
  <line x1="920" y1="220" x2="980" y2="320" stroke="#6366f1" stroke-width="3" marker-end="url(#arrow)"/>
  
  <text x="700" y="750" font-size="16" text-anchor="middle" fill="#64748b">
    说明: 元胞自动机由元胞、状态和规则三要素组成
  </text>
</svg>
```

### 模板 2: 分析流程图
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="800" viewBox="0 0 1400 800">
  <defs>
    <marker id="arrow2" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#2563eb"/>
    </marker>
  </defs>
  
  <!-- 标题 -->
  <text x="700" y="60" font-family="Arial" font-size="28" font-weight="bold" 
        text-anchor="middle" fill="#1e3a8a">元胞自动机实现流程</text>
  
  <!-- 流程步骤 -->
  <g>
    <!-- 步骤1 -->
    <rect x="150" y="150" width="250" height="100" rx="12" fill="#dbeafe" 
          stroke="#2563eb" stroke-width="3"/>
    <text x="275" y="195" font-size="18" font-weight="bold" text-anchor="middle" fill="#1e40af">
      1. 初始化网格
    </text>
    <text x="275" y="225" font-size="14" text-anchor="middle" fill="#1e40af">
      设置网格大小和初始状态
    </text>
    
    <!-- 箭头 -->
    <line x1="400" y1="200" x2="480" y2="200" stroke="#2563eb" stroke-width="3" marker-end="url(#arrow2)"/>
    
    <!-- 步骤2 -->
    <rect x="480" y="150" width="250" height="100" rx="12" fill="#dbeafe" 
          stroke="#2563eb" stroke-width="3"/>
    <text x="605" y="195" font-size="18" font-weight="bold" text-anchor="middle" fill="#1e40af">
      2. 定义规则
    </text>
    <text x="605" y="225" font-size="14" text-anchor="middle" fill="#1e40af">
      转换函数和邻域判断
    </text>
    
    <!-- 箭头 -->
    <line x1="730" y1="200" x2="810" y2="200" stroke="#2563eb" stroke-width="3" marker-end="url(#arrow2)"/>
    
    <!-- 步骤3 -->
    <rect x="810" y="150" width="250" height="100" rx="12" fill="#fef3c7" 
          stroke="#f59e0b" stroke-width="3"/>
    <text x="935" y="195" font-size="18" font-weight="bold" text-anchor="middle" fill="#92400e">
      3. 迭代演化
    </text>
    <text x="935" y="225" font-size="14" text-anchor="middle" fill="#92400e">
      逐代更新元胞状态
    </text>
    
    <!-- 向下箭头 -->
    <line x1="935" y1="250" x2="935" y2="350" stroke="#f59e0b" stroke-width="3" marker-end="url(#arrow2)"/>
    
    <!-- 步骤4 -->
    <rect x="810" y="350" width="250" height="100" rx="12" fill="#dcfce7" 
          stroke="#16a34a" stroke-width="3"/>
    <text x="935" y="395" font-size="18" font-weight="bold" text-anchor="middle" fill="#166534">
      4. 可视化
    </text>
    <text x="935" y="425" font-size="14" text-anchor="middle" fill="#166534">
      绘制演化动画
    </text>
    
    <!-- 向左箭头 -->
    <line x1="810" y1="400" x2="730" y2="400" stroke="#16a34a" stroke-width="3" marker-end="url(#arrow2)"/>
    
    <!-- 步骤5 -->
    <rect x="480" y="350" width="250" height="100" rx="12" fill="#fce7f3" 
          stroke="#ec4899" stroke-width="3"/>
    <text x="605" y="395" font-size="18" font-weight="bold" text-anchor="middle" fill="#9f1239">
      5. 结果分析
    </text>
    <text x="605" y="425" font-size="14" text-anchor="middle" fill="#9f1239">
      提取统计指标
    </text>
  </g>
  
  <!-- 说明文字 -->
  <text x="700" y="750" font-size="16" text-anchor="middle" fill="#64748b">
    说明: 典型的元胞自动机实现包含初始化、规则定义、迭代演化、可视化和分析五个步骤
  </text>
</svg>
```

### 模板 3: 方法对比表格图
```svg
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="850" viewBox="0 0 1400 850">
  <!-- 标题 -->
  <text x="700" y="50" font-family="Arial" font-size="28" font-weight="bold" 
        text-anchor="middle" fill="#1e3a8a">元胞自动机 vs 传统建模方法</text>
  
  <!-- 表格头 -->
  <rect x="100" y="100" width="300" height="60" fill="#1e40af" rx="8"/>
  <text x="250" y="140" font-size="18" font-weight="bold" text-anchor="middle" fill="white">对比维度</text>
  
  <rect x="400" y="100" width="400" height="60" fill="#0891b2" rx="8"/>
  <text x="600" y="140" font-size="18" font-weight="bold" text-anchor="middle" fill="white">元胞自动机</text>
  
  <rect x="800" y="100" width="400" height="60" fill="#6366f1" rx="8"/>
  <text x="1000" y="140" font-size="18" font-weight="bold" text-anchor="middle" fill="white">微分方程模型</text>
  
  <!-- 行1: 建模方式 -->
  <rect x="100" y="160" width="300" height="80" fill="#e0f2fe" stroke="#bae6fd" stroke-width="1"/>
  <text x="250" y="205" font-size="16" text-anchor="middle" fill="#0c4a6e">建模方式</text>
  
  <rect x="400" y="160" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="600" y="195" font-size="14" text-anchor="middle" fill="#0c4a6e">个体为基础</text>
  <text x="600" y="220" font-size="14" text-anchor="middle" fill="#0c4a6e">离散时空</text>
  
  <rect x="800" y="160" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="1000" y="195" font-size="14" text-anchor="middle" fill="#0c4a6e">群体为基础</text>
  <text x="1000" y="220" font-size="14" text-anchor="middle" fill="#0c4a6e">连续时空</text>
  
  <!-- 行2: 空间异质性 -->
  <rect x="100" y="240" width="300" height="80" fill="#e0f2fe" stroke="#bae6fd" stroke-width="1"/>
  <text x="250" y="285" font-size="16" text-anchor="middle" fill="#0c4a6e">空间异质性</text>
  
  <rect x="400" y="240" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="600" y="275" font-size="14" text-anchor="middle" fill="#16a34a">✓ 自然表达</text>
  <text x="600" y="300" font-size="14" text-anchor="middle" fill="#0c4a6e">网格位置天然支持</text>
  
  <rect x="800" y="240" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="1000" y="275" font-size="14" text-anchor="middle" fill="#dc2626">✗ 难以处理</text>
  <text x="1000" y="300" font-size="14" text-anchor="middle" fill="#0c4a6e">需要偏微分方程</text>
  
  <!-- 行3: 计算复杂度 -->
  <rect x="100" y="320" width="300" height="80" fill="#e0f2fe" stroke="#bae6fd" stroke-width="1"/>
  <text x="250" y="365" font-size="16" text-anchor="middle" fill="#0c4a6e">计算复杂度</text>
  
  <rect x="400" y="320" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="600" y="355" font-size="14" text-anchor="middle" fill="#dc2626">高</text>
  <text x="600" y="380" font-size="14" text-anchor="middle" fill="#0c4a6e">O(n×m×t)</text>
  
  <rect x="800" y="320" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="1000" y="355" font-size="14" text-anchor="middle" fill="#16a34a">相对较低</text>
  <text x="1000" y="380" font-size="14" text-anchor="middle" fill="#0c4a6e">数值求解器高效</text>
  
  <!-- 行4: 随机性 -->
  <rect x="100" y="400" width="300" height="80" fill="#e0f2fe" stroke="#bae6fd" stroke-width="1"/>
  <text x="250" y="445" font-size="16" text-anchor="middle" fill="#0c4a6e">随机性</text>
  
  <rect x="400" y="400" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="600" y="435" font-size="14" text-anchor="middle" fill="#16a34a">✓ 易集成</text>
  <text x="600" y="460" font-size="14" text-anchor="middle" fill="#0c4a6e">个体层面随机事件</text>
  
  <rect x="800" y="400" width="400" height="80" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="1000" y="435" font-size="14" text-anchor="middle" fill="#f59e0b">△ 需要扩展</text>
  <text x="1000" y="460" font-size="14" text-anchor="middle" fill="#0c4a6e">随机微分方程</text>
  
  <!-- 行5: 适用场景 -->
  <rect x="100" y="480" width="300" height="100" fill="#e0f2fe" stroke="#bae6fd" stroke-width="1"/>
  <text x="250" y="535" font-size="16" text-anchor="middle" fill="#0c4a6e">典型应用</text>
  
  <rect x="400" y="480" width="400" height="100" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="600" y="515" font-size="14" text-anchor="middle" fill="#0c4a6e">城市规划、交通流</text>
  <text x="600" y="540" font-size="14" text-anchor="middle" fill="#0c4a6e">生态系统、传染病</text>
  <text x="600" y="565" font-size="14" text-anchor="middle" fill="#0c4a6e">图像处理、游戏</text>
  
  <rect x="800" y="480" width="400" height="100" fill="white" stroke="#bae6fd" stroke-width="1"/>
  <text x="1000" y="515" font-size="14" text-anchor="middle" fill="#0c4a6e">物理系统建模</text>
  <text x="1000" y="540" font-size="14" text-anchor="middle" fill="#0c4a6e">化学反应动力学</text>
  <text x="1000" y="565" font-size="14" text-anchor="middle" fill="#0c4a6e">经典传染病模型</text>
  
  <!-- 底部说明 -->
  <text x="700" y="650" font-size="16" text-anchor="middle" fill="#64748b">
    说明: 元胞自动机在表达空间异质性和个体行为方面具有优势,但计算成本较高
  </text>
  
  <!-- 图例 -->
  <g transform="translate(450, 700)">
    <circle cx="0" cy="0" r="8" fill="#16a34a"/>
    <text x="15" y="5" font-size="14" fill="#0c4a6e">优势明显</text>
    
    <circle cx="130" cy="0" r="8" fill="#f59e0b"/>
    <text x="145" y="5" font-size="14" fill="#0c4a6e">有条件支持</text>
    
    <circle cx="300" cy="0" r="8" fill="#dc2626"/>
    <text x="315" y="5" font-size="14" fill="#0c4a6e">不适用/困难</text>
  </g>
</svg>
```

## 3. 在文章中引用图片的标准格式

### Markdown 引用语法
```markdown
![图片描述](images/diagrams/spc-topic-type.svg)

**说明**: 对图片内容的简短解释，帮助读者理解图片要点。
```

### 插入位置建议
| 章节 | 推荐图片类型 |
|------|-------------|
| 领域背景与适用场景 | 方法对比图 (comparison) |
| 核心概念与术语 | 结构示意图 (structure) |
| 完整实现流程 | 流程图 (workflow) |
| 进阶应用与案例 | 示例演示 (example) |
