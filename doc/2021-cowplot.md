---
title: "cowplot: 专业图形组合与美化"
date: "2025-01-10"
categories: [可视化, ggplot2扩展]
image: "figure/cowplot-cover.png"
---



## 简介

**cowplot** 是 ggplot2 的扩展包，专注于：

- 专业主题：出版级简洁主题
- 图形组合：灵活的多图排列
- 图形嵌入：在图中添加子图
- 标签注释：自动添加 A/B/C 面板标签
- 对齐控制：精确对齐多图坐标轴


``` r
library(ggplot2)
library(cowplot)
library(dplyr)
```

## 主题系统

### theme_cowplot - 经典主题


``` r
p <- ggplot(mtcars, aes(wt, mpg)) + 
  geom_point(aes(color = factor(cyl)), size = 3)

# cowplot 经典主题：无网格线，粗坐标轴
p + theme_cowplot(font_size = 12)
```

<div class="figure">
<img src="figure/unnamed-chunk-2-1.png" alt="plot of chunk unnamed-chunk-2" width="100%" />
<p class="caption">plot of chunk unnamed-chunk-2</p>
</div>

### theme_minimal_grid - 极简网格


``` r
p + theme_minimal_grid(font_size = 12)
```

<div class="figure">
<img src="figure/unnamed-chunk-3-1.png" alt="plot of chunk unnamed-chunk-3" width="100%" />
<p class="caption">plot of chunk unnamed-chunk-3</p>
</div>

### theme_minimal_hgrid / vgrid


``` r
p1 <- p + theme_minimal_hgrid() + ggtitle("水平网格")
p2 <- p + theme_minimal_vgrid() + ggtitle("垂直网格")
plot_grid(p1, p2, ncol = 2)
```

<div class="figure">
<img src="figure/unnamed-chunk-4-1.png" alt="plot of chunk unnamed-chunk-4" width="100%" />
<p class="caption">plot of chunk unnamed-chunk-4</p>
</div>

### theme_half_open - 半开放坐标轴








































