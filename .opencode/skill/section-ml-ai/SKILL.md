---
name: section-ml-ai
description: 生成"机器学习与AI"类页面的超详细教程内容。触发条件:(1)用户要求编写机器学习算法、深度学习、AI框架教程;(2)涉及mlr3、tidymodels、xgboost、torch等框架;(3)用户需要讲解分类、回归、聚类、特征工程、模型调参;(4)用户提到随机森林、SVM、神经网络、集成学习等算法;(5)涉及模型评估、交叉验证、超参数优化。生成完整的ML教程,强调"问题定义→数据准备→模型训练→评估优化→可解释性",提供完整的建模流程和代码实现。
---

## 核心任务

生成机器学习与AI类教程(.rmd/.qmd),涵盖算法原理、工程实践、模型评估、可解释性。

## 必备内容结构

### YAML头部与setup代码块

```yaml
---
title: '[算法/框架名称]完整教程'
subtitle: '从原理到实践'
date: 'YYYY-MM-DD'
categories:
- 机器学习与AI
- [具体分类:监督学习/无监督学习/深度学习]
image: images/[topic]-cover.svg
description: 一句话概括算法用途
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo=TRUE, warning=FALSE, message=FALSE, 
                      fig.width=8, fig.height=5, fig.retina=2, 
                      out.width="100%", dpi=150)
```
```

### 标题层次结构(CRITICAL)

**MUST使用正确的标题层次**:

```markdown
## 一级标题(章节)  # 用于主要章节,生成目录
### 二级标题(小节)  # 用于子主题
#### 三级标题(详细步骤)  # 用于具体操作步骤
```

**CRITICAL RULE**:
- 一级标题(`##`)是生成目录的**唯一**途径
- 文章必须包含至少3个一级标题才会显示目录
- 单个`#`标题由Quarto从YAML的title字段自动生成,**NEVER手动添加**
- 如果文章只有`###`标题而无`##`标题,将**不会显示目录**

**正确示例**:
```markdown
## 教程目标  # ✅ 一级标题,会出现在目录中
### 适用场景  # ✅ 二级标题,不会出现在目录中但有层次结构
```

**错误示例**:
```markdown
### 教程目标  # ❌ 只用三级标题,目录不会生成
#### 适用场景  # ❌ 层次混乱
```

### 问题定义与适用场景

**必须包含**:
```markdown
## 教程目标

本教程介绍[算法/框架],适用于[问题类型]。

### 适用场景
- [场景1:数据特点+任务类型]
- [场景2]

### 不适用场景
- [场景1:说明原因]
- [场景2]

### 算法对比

| 算法 | 适用任务 | 优点 | 缺点 | 典型场景 |
|------|---------|------|------|----------|
| [本算法] | | | | |
| [对比算法1] | | | | |
```

### 核心原理解析

**从0开始讲解**:
```markdown
## 算法原理

### 核心思想

[用通俗语言解释算法如何工作]

### 工作机制

1. [步骤1]
2. [步骤2]
3. [步骤3]

[可选:用类比帮助理解]

### 数学表达

目标函数:

$$\min_{\theta} \mathcal{L}(\theta) = ...$$

其中:
- $\theta$: [参数含义]
- $\mathcal{L}$: [损失函数]

**关键超参数**:
- `param1`: [含义、作用、调参建议]
- `param2`: [含义、作用、调参建议]
```

### 机器学习工作流概览

**必须提供流程图**:
```markdown
## ML工作流程

```
数据准备 → 特征工程 → 模型选择 → 训练 → 评估 → 调参 → 部署
   ↓         ↓          ↓        ↓      ↓       ↓
 清洗     标准化      基线模型   交叉    指标   网格搜索
 划分     编码        算法对比   验证    选择   贝叶斯优化
```

### 数据准备

**完整的数据处理流程**:
```markdown
## 数据准备

### 数据加载

{r load-data}
library(mlr3verse) # 或tidymodels
set.seed(2026)

# 使用示例数据
data <- ...

### 数据探索(EDA)

{r eda}
# 查看数据结构
str(data)

# 检查缺失值
summary(data)

# 可视化分布
ggplot(data, aes(...)) + geom_histogram()

### 数据划分

{r split-data}
# 70%训练,30%测试
set.seed(2026)
train_idx <- sample(nrow(data), 0.7 * nrow(data))
train_set <- data[train_idx, ]
test_set <- data[-train_idx, ]

# 或使用rsample
library(rsample)
data_split <- initial_split(data, prop = 0.7, strata = target)
train_set <- training(data_split)
test_set <- testing(data_split)

### 特征工程

{r feature-engineering}
# 标准化
library(recipes)
rec <- recipe(target ~ ., data = train_set) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors())

rec_prep <- prep(rec, training = train_set)
train_proc <- bake(rec_prep, new_data = train_set)
test_proc <- bake(rec_prep, new_data = test_set)
```

### 模型训练

**框架化的训练流程**:
```markdown
## 模型训练

### 基线模型

{r baseline}
# 先建立简单基线
baseline_model <- simple_method(train_set)
baseline_pred <- predict(baseline_model, test_set)

### 目标模型

{r train-model}
# 使用mlr3示例
library(mlr3verse)

# 创建任务
task <- TaskClassif$new(
  id = "demo",
  backend = train_proc,
  target = "target"
)

# 创建学习器
learner <- lrn("classif.ranger", 
  num.trees = 500,
  mtry = 3,
  predict_type = "prob"
)

# 训练
learner$train(task)

**参数说明**:
- `num.trees`: 决策树数量,建议500-1000
- `mtry`: 每次分裂考虑的变量数,通常sqrt(p)
- `predict_type`: "response"输出类别,"prob"输出概率
```

### 模型评估

**系统的评估流程**:
```markdown
## 模型评估

### 预测

{r predict}
# 在测试集预测
prediction <- learner$predict_newdata(test_proc)

### 评估指标

{r metrics}
# 多个指标
measures <- msrs(c(
  "classif.acc",    # 准确率
  "classif.auc",    # AUC
  "classif.sensitivity",  # 灵敏度
  "classif.specificity"   # 特异度
))

scores <- prediction$score(measures)
knitr::kable(scores)

### 混淆矩阵

{r confusion}
prediction$confusion

### ROC曲线

{r roc}
library(pROC)
roc_obj <- roc(
  response = test_set$target,
  predictor = as.data.table(prediction)$prob.1
)

plot(roc_obj, main = paste("AUC =", round(auc(roc_obj), 3)))

### 交叉验证

{r cross-validation}
# 5折交叉验证
resampling <- rsmp("cv", folds = 5)
rr <- resample(task, learner, resampling)

# 聚合结果
rr$aggregate(measures)

# 各折表现
rr$score(measures)
```

### 超参数调优

```markdown
## 超参数优化

### 定义搜索空间

{r param-space}
library(paradox)

search_space <- ps(
  num.trees = p_int(lower = 100, upper = 1000),
  mtry = p_int(lower = 1, upper = 10),
  min.node.size = p_int(lower = 1, upper = 20)
)

### 网格搜索

{r grid-search}
tuner <- tnr("grid_search", resolution = 5)

instance <- TuningInstanceSingleCrit$new(
  task = task,
  learner = learner,
  resampling = rsmp("cv", folds = 3),
  measure = msr("classif.auc"),
  search_space = search_space,
  terminator = trm("none")
)

tuner$optimize(instance)

# 最优参数
instance$result

### 使用最优参数

{r final-model}
learner$param_set$values <- instance$result_learner_param_vals

# 重新训练
learner$train(task)
final_pred <- learner$predict_newdata(test_proc)
final_pred$score(measures)
```

### 特征重要性与可解释性

```markdown
## 模型可解释性

### 特征重要性

{r feature-importance}
# 提取重要性
importance <- learner$model$variable.importance
importance_df <- data.frame(
  feature = names(importance),
  importance = importance
) %>% arrange(desc(importance))

# 可视化
ggplot(importance_df[1:10,], 
  aes(x = reorder(feature, importance), y = importance)) +
  geom_col(fill = "#4f46e5") +
  coord_flip() +
  labs(title = "Top 10特征重要性", x = "", y = "重要性")

### SHAP值(可选)

{r shap, eval=FALSE}
library(shapviz)
# SHAP分析代码
```

### 模型保存与部署

```markdown
## 保存模型

{r save-model}
# 保存训练好的模型
saveRDS(learner, "models/final_model.rds")

# 保存预处理器
saveRDS(rec_prep, "models/preprocessor.rds")

## 加载与预测

{r load-predict}
# 加载模型
loaded_model <- readRDS("models/final_model.rds")
loaded_prep <- readRDS("models/preprocessor.rds")

# 对新数据预测
new_data_proc <- bake(loaded_prep, new_data = new_data)
pred <- loaded_model$predict_newdata(new_data_proc)
```

## 写作规范

### 完整性要求

- 必须包含完整的训练-评估-优化流程
- 必须提供交叉验证代码
- 必须展示多个评估指标
- 必须说明参数选择理由

### 可复现性

```r
# 所有随机操作设置seed
set.seed(2026)

# 说明环境信息
sessionInfo() # 或包版本
```

### 框架选择

- mlr3: 适合复杂ML流程、多模型对比
- tidymodels: 适合tidyverse用户、管道式工作流
- 原生包(xgboost/ranger): 适合单模型深入讲解

## 完整工作流程

### 步骤1:生成教程

- 提供完整的建模流程
- 至少2个模型(基线+目标)
- 包含调参和可解释性

### 步骤2:三项渲染验证

```bash
quarto render doc/[number]-[topic].rmd
quarto render doc/index.qmd
quarto render doc/sections/ml-ai.qmd
```

### 步骤3:更新导航

更新`_quarto.yml`、`0001-guide.rmd`、`README.md`。

### 步骤4:提交

```bash
git add doc/[number]-[topic].rmd models/ ...
git commit -m "新增ML教程:[算法名称]"
git push
```

## 质量检查

- [ ] 是否明确了算法适用场景?
- [ ] 是否讲解了核心原理?
- [ ] 是否包含完整的数据准备流程?
- [ ] 是否提供了交叉验证?
- [ ] 是否包含超参数调优?
- [ ] 是否展示了特征重要性?
- [ ] 是否提供了模型保存方法?
- [ ] 代码是否可复现?

## 参考模板

- `doc/1016-mlr3.rmd` - 完整的ML框架教程
- `doc/1079-kmeans.rmd` - "概念→流程→代码"结构示范
- `doc/1080-random-forest.rmd` - 算法详解示例

## 常见问题

**Q: 如何平衡理论与实践?**

A: 核心原理简明扼要(20%),完整实践流程详尽(80%)。避免数学推导过多。

**Q: 是否必须包含调参?**

A: 对ML算法教程,调参是必须的。至少展示网格搜索或随机搜索。

**Q: 如何选择评估指标?**

A: 分类任务:准确率、AUC、F1、混淆矩阵;回归任务:RMSE、MAE、R²。根据任务特点选择。
