# 机器学习超参数调优指南

本文档提供常用机器学习算法的超参数调优建议和搜索空间。

## 随机森林(Random Forest)

### 核心超参数

| 参数 | 含义 | 默认值 | 推荐搜索范围 | 调优策略 |
|------|------|-------|-------------|----------|
| `ntree` | 树的数量 | 500 | [100, 500, 1000] | 越多越好,但收益递减 |
| `mtry` | 每次分裂的变量数 | √p(分类)/p/3(回归) | [√p/2, √p, 2√p] | 最重要,grid search |
| `nodesize` | 叶节点最小样本数 | 1(分类)/5(回归) | [1, 5, 10, 20] | 防止过拟合 |
| `maxnodes` | 最大叶节点数 | NULL | [10, 50, 100] | 控制树复杂度 |

### 调优示例(mlr3)
```r
library(mlr3)
library(mlr3tuning)

# 定义搜索空间
search_space <- ps(
  mtry = p_int(lower = 2, upper = 10),
  ntree = p_int(lower = 100, upper = 1000),
  nodesize = p_int(lower = 1, upper = 20)
)

# 网格搜索
tuner <- tnr("grid_search", resolution = 10)
```

### 调优顺序
1. **先调`mtry`**(影响最大)
2. 再调`ntree`(观察收敛)
3. 最后调`nodesize`(防止过拟合)

---

## XGBoost

### 核心超参数分层

#### 第一层:控制过拟合
| 参数 | 含义 | 默认值 | 推荐范围 | 说明 |
|------|------|-------|---------|------|
| `eta` (learning_rate) | 学习率 | 0.3 | [0.01, 0.1, 0.3] | 越小越保守,需更多树 |
| `max_depth` | 树的最大深度 | 6 | [3, 5, 7, 9] | 深度越大越易过拟合 |
| `min_child_weight` | 叶节点最小权重和 | 1 | [1, 3, 5, 7] | 越大越保守 |
| `subsample` | 样本采样比例 | 1 | [0.6, 0.8, 1.0] | <1时随机采样 |
| `colsample_bytree` | 特征采样比例 | 1 | [0.6, 0.8, 1.0] | 每棵树的特征比例 |

#### 第二层:提升性能
| 参数 | 含义 | 默认值 | 推荐范围 |
|------|------|-------|---------|
| `gamma` | 分裂所需最小损失降低 | 0 | [0, 0.1, 0.2] |
| `lambda` | L2正则化 | 1 | [0, 1, 10] |
| `alpha` | L1正则化 | 0 | [0, 0.1, 1] |

### 调优策略

**阶段1:固定学习率,调树结构**
```r
# 固定 eta = 0.1, nrounds = 100
params_stage1 <- list(
  max_depth = c(3, 5, 7, 9),
  min_child_weight = c(1, 3, 5),
  subsample = c(0.8, 1.0),
  colsample_bytree = c(0.8, 1.0)
)
```

**阶段2:调正则化参数**
```r
params_stage2 <- list(
  gamma = c(0, 0.1, 0.2),
  lambda = c(0, 1, 10),
  alpha = c(0, 0.1, 1)
)
```

**阶段3:降低学习率,增加迭代次数**
```r
# 学习率减半,迭代次数翻倍
eta = 0.05
nrounds = 200  # 或使用early_stopping
```

### Early Stopping
```r
xgb_model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 1000,
  watchlist = list(train=dtrain, test=dtest),
  early_stopping_rounds = 50,  # 50轮无改善则停止
  verbose = 1
)
```

---

## 支持向量机(SVM)

### 核心超参数

| 参数 | 含义 | 默认值 | 推荐范围 | 调优建议 |
|------|------|-------|---------|----------|
| `C` | 惩罚参数 | 1 | [0.01, 0.1, 1, 10, 100] | 对数尺度搜索 |
| `kernel` | 核函数 | radial | [linear, radial, poly] | 先试radial |
| `gamma` | RBF核参数 | 1/p | [0.001, 0.01, 0.1, 1] | 仅radial/poly核 |
| `degree` | 多项式核次数 | 3 | [2, 3, 4] | 仅poly核 |

### 调优示例
```r
# 径向基核(RBF)
tune_grid <- expand.grid(
  C = 10^seq(-2, 2, length=5),       # 对数尺度
  gamma = 10^seq(-3, 1, length=5)
)

# 线性核
tune_grid_linear <- expand.grid(
  C = 10^seq(-2, 2, length=10)
)
```

### 核函数选择
- **linear**: 高维数据(p >> n)
- **radial(RBF)**: 默认选择,适用广泛
- **polynomial**: 图像数据,特征交互

---

## 神经网络(Deep Learning)

### 核心超参数

| 参数类别 | 参数 | 推荐范围 | 说明 |
|---------|------|---------|------|
| **网络结构** | `layers` | 2-5层 | 浅层先尝试 |
| | `units` | [32, 64, 128, 256] | 2的幂次 |
| **优化器** | `learning_rate` | [1e-4, 1e-3, 1e-2] | Adam默认1e-3 |
| | `optimizer` | Adam/RMSprop | Adam优先 |
| **正则化** | `dropout` | [0.2, 0.3, 0.5] | 防止过拟合 |
| | `L2 penalty` | [1e-5, 1e-4, 1e-3] | 权重衰减 |
| **训练** | `batch_size` | [32, 64, 128] | 根据内存调整 |
| | `epochs` | [50, 100, 200] | 使用early stopping |

### 调优示例(torch)
```r
library(torch)

# 定义搜索空间
hyperparams <- list(
  lr = c(1e-4, 1e-3, 1e-2),
  dropout = c(0.2, 0.3, 0.5),
  hidden_units = c(64, 128, 256)
)

# 带early stopping的训练
train_with_es <- function(model, train_dl, valid_dl, patience=10) {
  best_loss <- Inf
  epochs_no_improve <- 0
  
  for (epoch in 1:max_epochs) {
    # 训练...
    valid_loss <- validate(model, valid_dl)
    
    if (valid_loss < best_loss) {
      best_loss <- valid_loss
      epochs_no_improve <- 0
      # 保存最佳模型
    } else {
      epochs_no_improve <- epochs_no_improve + 1
      if (epochs_no_improve >= patience) break
    }
  }
}
```

---

## 梯度提升树(GBM/LightGBM)

### LightGBM超参数

| 参数 | 含义 | 默认值 | 推荐范围 |
|------|------|-------|---------|
| `num_leaves` | 叶节点数 | 31 | [20, 31, 50, 100] |
| `learning_rate` | 学习率 | 0.1 | [0.01, 0.05, 0.1] |
| `feature_fraction` | 特征采样比例 | 1.0 | [0.6, 0.8, 1.0] |
| `bagging_fraction` | 样本采样比例 | 1.0 | [0.6, 0.8, 1.0] |
| `min_data_in_leaf` | 叶节点最小样本数 | 20 | [10, 20, 50] |

### 调优建议
1. **num_leaves与max_depth关系**:
   - `num_leaves` ≤ 2^(max_depth)
   - 优先调`num_leaves`(LightGBM特色)

2. **防止过拟合组合**:
   - 减小`num_leaves`
   - 增大`min_data_in_leaf`
   - 使用`feature_fraction`和`bagging_fraction`

---

## 通用调优策略

### 1. 搜索方法选择

| 方法 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| **网格搜索** | 参数少(≤3个) | 全面,可解释 | 计算量大 |
| **随机搜索** | 参数多(>3个) | 高效,覆盖广 | 可能遗漏最优 |
| **贝叶斯优化** | 计算成本高 | 样本高效 | 复杂,难解释 |

### 2. 搜索空间设计

**对数尺度搜索**(学习率、正则化参数):
```r
learning_rate = 10^seq(-4, -1, length=10)
# 而非 seq(0.0001, 0.1, length=10)
```

**线性尺度搜索**(树的数量、层数):
```r
ntrees = seq(100, 1000, by=100)
```

### 3. 交叉验证设置

```r
# 小数据集:10折
cv_folds = 10

# 大数据集:5折
cv_folds = 5

# 时间序列:时间序列CV
# 使用mlr3的time-series resampling
```

### 4. 计算资源分配

**并行计算**:
```r
library(future)
plan(multisession, workers = 4)  # 使用4核

# mlr3自动并行
future::plan("multisession")
```

---

## 调优示例:完整流程(mlr3)

```r
library(mlr3)
library(mlr3tuning)
library(mlr3learners)

# 1. 定义任务
task <- tsk("iris")

# 2. 选择学习器
learner <- lrn("classif.xgboost")

# 3. 定义搜索空间
search_space <- ps(
  eta = p_dbl(lower = 0.01, upper = 0.3, logscale = TRUE),
  max_depth = p_int(lower = 3, upper = 10),
  nrounds = p_int(lower = 50, upper = 500),
  subsample = p_dbl(lower = 0.6, upper = 1),
  colsample_bytree = p_dbl(lower = 0.6, upper = 1)
)

# 4. 选择调优方法
tuner <- tnr("random_search")

# 5. 定义重采样策略
resampling <- rsmp("cv", folds = 5)

# 6. 创建调优实例
instance <- TuningInstanceSingleCrit$new(
  task = task,
  learner = learner,
  resampling = resampling,
  measure = msr("classif.acc"),
  search_space = search_space,
  terminator = trm("evals", n_evals = 50)
)

# 7. 执行调优
tuner$optimize(instance)

# 8. 查看最佳参数
instance$result_learner_param_vals
```

---

## 常见错误与纠正

### ❌ 错误1:在整个数据集上调参
```r
# 错误:数据泄漏
tune_model(full_data)
```
**纠正**:
```r
# 在训练集上调参,测试集评估
tune_model(train_data)
final_eval(test_data)
```

### ❌ 错误2:搜索空间过大
```r
# 错误:10个参数 × 10个值 = 10^10组合
grid <- expand.grid(
  param1 = 1:10,
  param2 = 1:10,
  # ... 10个参数
)
```
**纠正**:
- 分阶段调参
- 使用随机搜索/贝叶斯优化
- 减少参数数量(固定次要参数)

### ❌ 错误3:忽略计算成本
```r
# 错误:每次调参训练1000棵树
nrounds = 1000  # 在调参中固定
```
**纠正**:
```r
# 使用early stopping
nrounds = 1000
early_stopping_rounds = 50  # 50轮无改善停止
```

---

## 参考资源

- **mlr3book调参章节**: https://mlr3book.mlr-org.com/tuning.html
- **XGBoost参数指南**: https://xgboost.readthedocs.io/en/latest/parameter.html
- **LightGBM参数**: https://lightgbm.readthedocs.io/en/latest/Parameters.html
- **Hyperparameter Tuning论文**: Bergstra & Bengio (2012)
