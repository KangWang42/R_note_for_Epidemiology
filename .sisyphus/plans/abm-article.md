# ABM（基于主体建模）文章生成计划

## 目标
为R语言学习笔记Quarto网站增加一篇关于ABM（Agent-Based Modeling）在流行病学中应用的进阶级教程文章。

## 需求总结
- **内容范围**: 流行病学ABM应用（传染病传播建模、疾病干预模拟）
- **工具选择**: 主讲EpiModel，简要介绍NetLogoR，提及其他工具
- **难度级别**: 进阶级（⭐⭐）- 假设读者有基础R知识
- **分类归属**: 特殊应用（与卫生经济学、质性研究、信号处理并列）
- **实战案例**: 经典SIR/SEIR传染病模型
- **文章篇幅**: 简明教程（3000-5000字，30-40分钟阅读）
- **可视化**: 静态网络图（igraph+ggplot2）+ 动态时间序列（gganimate）
- **ODE对比**: 概念层面对比（表格形式）
- **文件编号**: 1110-abm.rmd
- **封面图**: 自定义仿真网络传播图

## 技术决策
- 文件路径: `doc/1110-abm.rmd`
- 主要R包: EpiModel, NetLogoR, igraph, ggplot2, gganimate
- 示例模型: SIR网络传播模型
- 验证方法: `quarto render doc/1110-abm.rmd`

## 任务清单

### 准备阶段
- [ ] 调研EpiModel和NetLogoR的最新文档和示例代码
- [ ] 准备SIR模型的参数设置和网络配置
- [ ] 设计文章结构和代码示例框架

### 内容创作
- [ ] 编写1110-abm.rmd主体内容
  - YAML header（title, date, categories, image, description）
  - Section 1: ABM概念介绍（500字）
    - 基本概念
    - 与ODE模型对比表格
    - 流行病学应用场景
  - Section 2: R工具对比（800字）
    - EpiModel详细介绍
    - NetLogoR简要介绍
    - 其他工具对比表
  - Section 3: SIR实战案例（2000字）
    - 问题背景
    - EpiModel实现步骤（网络设置、参数配置、模型运行）
    - 结果解读
  - Section 4: 可视化展示（800字）
    - 静态网络传播图代码
    - 动态感染人数变化图代码
  - Section 5: 进阶拓展（300字）
    - 参数敏感性分析提示
    - 干预措施模拟概念
    - 学习资源推荐

### 可视化资源
- [ ] 生成封面图（网络传播仿真图）
  - 运行ABM仿真生成网络图
  - 保存为 doc/images/abm-network-cover.png 或 doc/figure/abm-network-cover.png

### 配置更新
- [ ] 更新 doc/_quarto.yml
  - 在"特殊应用"分类下添加ABM文章链接
  - 确保导航栏和侧边栏都包含新文章

- [ ] 更新 doc/0001-guide.rmd
  - 在"统计方法专题 > 高级方法"或"特殊应用专题"中添加ABM链接
  - 在"按使用场景选择 > 做流行病学研究"中添加ABM引用

### 验证测试
- [ ] 渲染单个文件验证
  - 运行 `quarto render doc/1110-abm.rmd`
  - 检查R包安装（EpiModel, NetLogoR, igraph, gganimate）
  - 确认代码无错误，图表正常生成

- [ ] 检查文章质量
  - 代码可执行性
  - 图表清晰度
  - 文字表达准确性
  - 链接有效性

- [ ] 全站渲染测试
  - 运行 `quarto render doc` 或 `quarto preview doc`
  - 检查导航栏、侧边栏链接正确
  - 确认文章在网站中正常显示

### 文档完善
- [ ] 检查AGENTS.md是否需要更新
  - 确认是否需要记录新增的R包依赖（用户选择仅在文章内说明）

## 验收标准
1. ✅ 文章文件 `doc/1110-abm.rmd` 创建成功
2. ✅ 文章包含完整的5个section，总字数3000-5000字
3. ✅ 包含至少1个完整的SIR ABM实例（EpiModel实现）
4. ✅ 包含静态网络图和动态时间序列图
5. ✅ 封面图生成并正确引用
6. ✅ `_quarto.yml` 和 `0001-guide.rmd` 正确更新
7. ✅ `quarto render doc/1110-abm.rmd` 成功执行无错误
8. ✅ 全站预览 `quarto preview doc` 正常，文章可访问

## 风险与注意事项
- EpiModel和NetLogoR包可能需要额外系统依赖（如rgdal、sf等）
- 网络仿真可能需要较长运行时间，需要合理设置参数
- gganimate动画生成可能需要ImageMagick或gifski
- 确保代码chunk设置正确（echo=TRUE, message=FALSE, warning=FALSE）
- 封面图文件大小控制在500KB以内

## 参考资源
- EpiModel官方文档: https://www.epimodel.org/
- NetLogoR文档: https://CRAN.R-project.org/package=NetLogoR
- SIR模型理论: 经典流行病学教材
- 仓库现有特殊应用文章: 1015, 1030, 1062, 1033, 1034, 1035, 1096, 1106-1108

## 执行顺序建议
1. 准备阶段（调研+设计）
2. 内容创作（主体文章编写）
3. 可视化资源（封面图生成）
4. 配置更新（导航和指南）
5. 验证测试（渲染+质量检查）
6. 文档完善（AGENTS.md检查）
