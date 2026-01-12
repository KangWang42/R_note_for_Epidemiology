# R 语言学习笔记

这是一个 R 语言数据科学学习笔记项目，记录数据分析的方法、实用 R 包的使用，以及精美可视化图表的复现。

## 在线访问

网站地址: [https://r.wk8686.top](https://r.wk8686.top)

## 内容分类

### R 包教程
- bruceR - 统计分析工具
- compareGroups - 描述性表格快速生成
- scitb - 快速生成基线表
- purrr - 函数式编程
- mlr3 - 机器学习全流程

### 数据可视化
- ggplot2 配色教程
- patchwork 多图拼接
- 图例自定义修改
- 桑基图绑制
- 地图绑制
- 森林图绑制
- 热图绑制完全指南
- 双坐标轴技巧
- cowplot 图形组合
- tidyplots 优雅可视化

### 统计方法
- Logistic 回归 - 二分类结局分析
- 生存分析 - Kaplan-Meier 与 Cox 回归
- 多元线性回归 - 连续结局分析
- Meta 分析 - 系统综述与效应合并
- 中介效应分析 - 机制探索
- 多水平/混合效应模型 - 嵌套数据分析
- 广义加性模型 (GAM) - 非线性关系建模
- Poisson/负二项回归 - 计数数据分析
- 限制性立方样条 (RCS) - 剂量-反应关系
- 双重差分法 (DiD) - 政策评估
- 倾向性得分匹配 (PSM) - 因果推断
- 时间序列分析 - 预测与趋势
- 卫生经济学分析 - 成本效果评价
- mlr3 机器学习 - 全流程指南

## 技术栈

- 文档框架: [Quarto](https://quarto.org/)
- 编程语言: R
- 部署: 自建服务器 + GitHub Actions 自动部署

## 项目结构

```
.
├── doc/                  # Quarto 源文件
│   ├── index.qmd        # 首页
│   ├── *.rmd            # 文章源文件
│   └── _quarto.yml      # Quarto 配置
├── public/              # 生成的静态网站
├── .github/workflows/   # GitHub Actions 自动部署
└── README.md
```

## 本地运行

```bash
# 克隆仓库
git clone https://github.com/KangWang42/R_note_for_Epidemiology.git

# 进入项目目录
cd doc

# 渲染网站
quarto render

# 预览
quarto preview
```

## License

MIT License
