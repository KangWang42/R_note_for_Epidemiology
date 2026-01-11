# R 语言学习笔记 📊

这是一个 R 语言数据科学学习笔记项目，记录数据分析的方法、实用 R 包的使用，以及精美可视化图表的复现。

## 🌐 在线访问

- **网站地址**: [https://r.wk8686.top](https://r.wk8686.top)

## 📚 内容分类

### 📦 R 包教程
- bruceR - 统计分析工具
- compareGroups - 描述性表一快速生成
- scitb - 快速生成基线表一
- purrr - 函数式编程
- mlr3 - 机器学习全流程

### 📈 数据可视化
- ggplot2 配色教程
- patchwork 多图拼接
- 图例自定义修改
- 桑基图绘制
- 地图绑制
- 森林图绘制
- 热图绑制完全指南
- 双坐标轴技巧
- cowplot 图形组合
- tidyplots 优雅可视化

### 🔬 数据分析
- 时间序列分析
- 卫生经济学分析
- R Markdown 教程

## 🛠️ 技术栈

- **文档框架**: [Quarto](https://quarto.org/)
- **编程语言**: R
- **部署**: 自建服务器 + GitHub Actions 自动部署

## 📂 项目结构

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

## 🚀 本地运行

```bash
# 克隆仓库
git clone https://github.com/你的用户名/仓库名.git

# 进入项目目录
cd doc

# 渲染网站
quarto render

# 预览
quarto preview
```

## 📝 License

MIT License
