# 数据可视化配色方案参考

本文档提供常用的科学期刊配色方案和色盲友好配色,帮助创建出版级图表。

## 期刊主题配色(ggsci包)

### Lancet(柳叶刀)
```r
library(ggsci)
scale_color_lancet()
scale_fill_lancet()
```
**配色**: 深蓝、深红、深绿、橙色、紫色等9色
**适用**: 医学期刊、学术报告
**特点**: 专业、权威、适合打印

### NEJM(新英格兰医学杂志)
```r
scale_color_nejm()
scale_fill_nejm()
```
**配色**: 红、蓝、绿、橙、紫、棕、粉、灰(8色)
**适用**: 临床研究、Meta分析
**特点**: 经典医学配色

### JAMA(美国医学会杂志)
```r
scale_color_jama()
scale_fill_jama()
```
**配色**: 深蓝、深红、深绿、紫色等7色
**适用**: 流行病学研究
**特点**: 稳重、清晰

### Nature
```r
scale_color_npg()
scale_fill_npg()
```
**配色**: Nature Publishing Group标准色(10色)
**适用**: 高影响因子期刊
**特点**: 鲜艳、对比度高

### Science
```r
scale_color_aaas()
scale_fill_aaas()
```
**配色**: AAAS(Science出版商)标准色(10色)
**适用**: 综合科学期刊
**特点**: 明亮、现代

## 色盲友好配色

### Viridis系列(强烈推荐)
```r
scale_color_viridis_d()  # 离散变量
scale_fill_viridis_c()   # 连续变量

# 四种变体
option = "viridis"  # 默认,紫-蓝-绿-黄
option = "magma"    # 黑-紫-粉-黄
option = "plasma"   # 紫-粉-橙-黄
option = "inferno"  # 黑-紫-橙-黄
option = "cividis"  # 蓝-黄(完全色盲友好)
```
**优点**:
- ✓ 色盲友好(红绿色盲可区分)
- ✓ 感知均匀(数值差异=视觉差异)
- ✓ 黑白打印清晰
- ✓ 适合连续变量

### ColorBrewer系列
```r
library(RColorBrewer)
scale_fill_brewer(palette = "Set2")  # 离散,色盲友好
scale_fill_brewer(palette = "RdYlBu")  # 连续,发散配色
```

**推荐色盲友好palette**:
- `Set2`: 8色,柔和,适合分类
- `Dark2`: 8色,深色,适合对比
- `Paired`: 12色,成对,适合对比组

## 配色选择决策树

```
1. 变量类型?
   ├─ 分类变量(≤7类)
   │   ├─ 期刊投稿 → scale_fill_lancet/nejm/npg
   │   ├─ 色盲友好 → scale_fill_brewer(palette="Set2")
   │   └─ 通用 → scale_fill_manual(values=自定义)
   │
   ├─ 分类变量(>7类)
   │   ├─ 建议减少分类数
   │   └─ 或使用渐变色+离散化
   │
   └─ 连续变量
       ├─ 发散型(有中心值) → scale_fill_gradient2(low, mid, high)
       ├─ 单向渐变 → scale_fill_viridis_c()
       └─ 热图 → scale_fill_distiller(palette="RdYlBu")
```

## 常用配色方案速查

### 分类数据配色(离散)

| 场景 | 推荐方案 | 代码 | 最大颜色数 |
|------|---------|------|-----------|
| 医学期刊 | Lancet | `scale_fill_lancet()` | 9 |
| 临床研究 | NEJM | `scale_fill_nejm()` | 8 |
| 色盲友好 | Set2 | `scale_fill_brewer(palette="Set2")` | 8 |
| 高对比度 | Dark2 | `scale_fill_brewer(palette="Dark2")` | 8 |
| 成对对比 | Paired | `scale_fill_brewer(palette="Paired")` | 12 |

### 连续数据配色

| 场景 | 推荐方案 | 代码 |
|------|---------|------|
| 单向渐变 | Viridis | `scale_fill_viridis_c()` |
| 发散配色(中心为0) | RdYlBu | `scale_fill_gradient2(low="blue", mid="white", high="red")` |
| 热图 | RdYlBu反转 | `scale_fill_distiller(palette="RdYlBu", direction=-1)` |
| 完全色盲友好 | Cividis | `scale_fill_viridis_c(option="cividis")` |

## 自定义配色示例

### 手动指定颜色
```r
# 自定义颜色向量
custom_colors <- c(
  "Control" = "#4DBBD5",
  "Treatment" = "#E64B35",
  "Placebo" = "#00A087"
)

ggplot(data, aes(x, y, fill=group)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = custom_colors)
```

### 渐变色(双色)
```r
scale_fill_gradient(
  low = "#FFFFFF",    # 低值:白色
  high = "#E64B35",   # 高值:红色
  limits = c(0, 100)
)
```

### 渐变色(三色,发散)
```r
scale_fill_gradient2(
  low = "#3C5488",     # 低值:蓝色
  mid = "#F7F7F7",     # 中值:白色
  high = "#E64B35",    # 高值:红色
  midpoint = 0
)
```

## 颜色代码速查表

### Lancet配色
```r
c("#00468B", "#ED0000", "#42B540", "#0099B4", 
  "#925E9F", "#FDAF91", "#AD002A", "#ADB6B6", "#1B1919")
```

### NEJM配色
```r
c("#BC3C29", "#0072B5", "#E18727", "#20854E",
  "#7876B1", "#6F99AD", "#FFDC91", "#EE4C97")
```

### Set2(色盲友好)
```r
c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3",
  "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3")
```

## 配色检验工具

### 在线工具
- **Coblis**: 色盲模拟器(检查图表色盲可访问性)
  - https://www.color-blindness.com/coblis-color-blindness-simulator/
  
- **ColorBrewer**: 配色方案生成器
  - https://colorbrewer2.org/

### R包检验
```r
# 检查配色的色盲友好性
library(colorBlindness)
cvdPlot(your_plot)  # 模拟不同类型色盲视角
```

## 常见错误与纠正

### ❌ 错误1:红绿配色
```r
# 错误:红绿色盲无法区分
scale_fill_manual(values = c("red", "green"))
```
**纠正**:
```r
# 使用蓝-橙或紫-黄对比
scale_fill_manual(values = c("#0072B5", "#E18727"))
```

### ❌ 错误2:颜色过多
```r
# 错误:超过10种颜色难以区分
ggplot(data, aes(fill = factor_with_15_levels))
```
**纠正**:
- 合并分类(减少至<7类)
- 使用分面(facet)分组显示
- 考虑其他视觉元素(形状、线型)

### ❌ 错误3:彩虹配色
```r
# 错误:rainbow()不均匀,不色盲友好
scale_fill_gradientn(colors = rainbow(7))
```
**纠正**:
```r
# 使用感知均匀的viridis
scale_fill_viridis_c()
```

## 最佳实践建议

1. **优先使用色盲友好配色**
   - 默认选择viridis/Set2
   - 避免单纯依赖红绿对比

2. **限制颜色数量**
   - 分类变量:≤7种颜色
   - 超过7类:考虑合并或分面

3. **测试黑白打印效果**
   - 确保灰度下仍可区分
   - 添加纹理/形状辅助

4. **保持一致性**
   - 同一研究中相同变量使用相同颜色
   - 建立配色规范文档

5. **期刊要求优先**
   - 投稿前查看期刊配色指南
   - 使用期刊推荐的配色方案

## 参考资源

- ggsci包文档: https://cran.r-project.org/package=ggsci
- RColorBrewer: https://cran.r-project.org/package=RColorBrewer
- viridis色彩理论: https://cran.r-project.org/package=viridis
