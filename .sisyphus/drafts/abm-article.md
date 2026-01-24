# Draft: ABM（基于主体建模）文章

## Requirements (confirmed)
- **内容范围**: 流行病学ABM应用（传染病传播建模、疾病干预模拟等）
- **工具选择**: 多工具对比（NetLogoR, EpiModel, RNetLogo, simecol等）
- **难度级别**: 进阶级 (⭐⭐) - 假设读者有基础R知识，重点讲应用
- **分类归属**: 特殊应用（与卫生经济学、质性研究、信号处理并列）

## Technical Decisions
- **文件编号**: 需确定（特殊应用分类目前无编号规则，需查看现有编号）
- **文件格式**: .rmd（与仓库其他文章保持一致）
- **示例数据**: 待定（真实案例 vs 模拟数据）

## Research Findings
### 仓库结构
- Quarto网站，源文件在doc/，输出在public/
- 命名规则: [Section][Number]-[topic].rmd
- 构建命令: `quarto render doc/1110-abm.rmd`（验证更改）

### 特殊应用分类现有内容
- 卫生经济学: 1015-health-economics.rmd, 1062-treeage-pro.rmd
- 质性研究: 1030-qualitative-research.rmd
- 信号处理: 1096-wavelet-transform.rmd, 1034-nvmd.rmd, 1035-fft-nvmd-gmm.rmd
- 环境流行病学: 1033-dlnm.rmd, 1106-wqs.rmd, 1107-qgcomp.rmd, 1108-bkmr.rmd
- **新增ABM**: 1110-abm.rmd

### YAML Header Template
```yaml
---
title: 'ABM 基于主体建模：流行病学传播仿真'
date: '2026-01-24'
categories:
- 特殊应用
- 建模方法
- 传染病模型
image: figure/abm-network-cover.png
description: 使用R语言进行基于主体的建模(ABM)，模拟传染病在网络中的传播过程。
---
```

### 文章结构草案
1. **什么是ABM** (500字)
   - 基本概念
   - 与ODE模型的对比（表格形式）
   - 流行病学应用场景

2. **R中的ABM工具** (800字)
   - EpiModel: 网络流行病学建模（重点）
   - NetLogoR: 空间显式模型（简要）
   - 其他工具对比表（RNetLogo, simecol）
   
3. **实战：SIR网络传播模型** (2000字)
   - 问题背景
   - EpiModel实现步骤
     - 网络设置
     - 疫情参数配置
     - 模型运行
   - 结果解读
   
4. **可视化** (800字)
   - 静态网络传播图（igraph + ggplot2）
   - 动态感染人数变化（gganimate）
   
5. **进阶拓展** (300字)
   - 参数敏感性分析（简要提及）
   - 干预措施模拟（概念）
   - 学习资源推荐

## Confirmed User Preferences
1. **实战案例**: 经典传染病模型（SIR/SEIR ABM实现）
2. **文章篇幅**: 简明教程（3000-5000字，30-40分钟阅读）
3. **可视化类型**: 两者都需要（动态仿真 + 静态统计图）
4. **工具对比深度**: 轻量对比（主讲EpiModel，简要介绍NetLogoR，提及其他）
5. **文件编号**: 1110-abm.rmd（特殊应用分类）
6. **ODE对比**: 概念层面对比（不需要完整ODE代码实现）
7. **封面图**: 自定义仿真网络传播图
8. **依赖管理**: 仅在文章内说明安装，不更新AGENTS.md

## Technical Decisions (Final)
- **文件名**: 1110-abm.rmd
- **文件路径**: E:\99 Project\05 R语言\doc\1110-abm.rmd
- **主要工具**: EpiModel（详细） + NetLogoR（简要）
- **示例模型**: SIR模型（网络传播版本）
- **可视化工具**: 
  - 静态图: ggplot2 + igraph（网络图）
  - 动态图: gganimate（感染人数变化）
- **对比方式**: 概念表格对比ABM vs ODE模型

## Scope Boundaries
- INCLUDE: 
  - ABM基本概念与流行病学应用场景（简明介绍）
  - EpiModel重点讲解（网络流行病学建模，R中最成熟的ABM工具）
  - NetLogoR简要介绍（空间显式模型，适合地理传播）
  - 其他工具简要提及（RNetLogo, simecol）
  - 一个完整SIR/SEIR ABM实例（使用EpiModel）
  - 传播网络可视化（静态网络图）
  - 感染人数时间序列图（动态gganimate）
  - 模型参数设置与结果解读
  - 与传统ODE模型的简单对比（概念层面）
- EXCLUDE:
  - NetLogo软件本身的详细教程
  - 复杂的数学推导（保持实用导向）
  - 社会科学ABM（专注流行病学）
  - 深入的参数校准与敏感性分析（可作为"进阶拓展"简要提及）
  - 大规模并行计算（超出简明教程范围）
