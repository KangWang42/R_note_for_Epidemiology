# 领域专业术语表

本文档提供卫生经济学、质性研究、信号处理、环境流行病学等特殊领域的常用术语中英对照。

## 卫生经济学(Health Economics)

### 核心概念

| 中文 | 英文 | 缩写 | 定义 |
|------|------|------|------|
| 成本效果分析 | Cost-Effectiveness Analysis | CEA | 比较不同干预措施的成本与效果 |
| 成本效用分析 | Cost-Utility Analysis | CUA | 使用QALY作为效果指标的CEA |
| 成本效益分析 | Cost-Benefit Analysis | CBA | 将成本和效果都货币化 |
| 质量调整生命年 | Quality-Adjusted Life Year | QALY | 综合生存时间与生活质量的指标 |
| 伤残调整生命年 | Disability-Adjusted Life Year | DALY | 因疾病/伤残损失的健康生命年 |
| 增量成本效果比 | Incremental Cost-Effectiveness Ratio | ICER | (C1-C0)/(E1-E0) |
| 支付意愿阈值 | Willingness-to-Pay Threshold | WTP | 每QALY愿意支付的金额 |
| 马尔科夫模型 | Markov Model | - | 模拟健康状态转换的决策模型 |
| 决策树 | Decision Tree | - | 分支概率决策模型 |
| 敏感性分析 | Sensitivity Analysis | SA | 参数不确定性分析 |
| 概率敏感性分析 | Probabilistic Sensitivity Analysis | PSA | 蒙特卡洛模拟参数分布 |

### 成本分类

| 中文 | 英文 | 说明 |
|------|------|------|
| 直接医疗成本 | Direct Medical Costs | 诊断、治疗、药品费用 |
| 直接非医疗成本 | Direct Non-Medical Costs | 交通、陪护、营养费用 |
| 间接成本 | Indirect Costs | 生产力损失、误工费 |
| 无形成本 | Intangible Costs | 疼痛、焦虑等难以量化的成本 |

### R包对应

| 任务 | R包 | 核心函数 |
|------|-----|---------|
| 马尔科夫模型 | `heemod` | `define_state()`, `define_transition()` |
| 决策树 | `decisionSupport` | `mcSimulation()` |
| QALY计算 | `BCEA` | `bcea()` |
| PSA | `hesim` | `hesim::psm()` |

---

## 质性研究(Qualitative Research)

### 核心方法

| 中文 | 英文 | 说明 |
|------|------|------|
| 扎根理论 | Grounded Theory | 从数据中归纳理论 |
| 现象学研究 | Phenomenology | 探索个体经验本质 |
| 民族志 | Ethnography | 文化群体深度观察 |
| 叙事研究 | Narrative Research | 个人故事分析 |
| 案例研究 | Case Study | 深度单案例或多案例 |

### 编码与分析

| 中文 | 英文 | 定义 |
|------|------|------|
| 开放编码 | Open Coding | 初步标记数据片段 |
| 主轴编码 | Axial Coding | 建立范畴间关系 |
| 选择性编码 | Selective Coding | 形成核心范畴 |
| 主题分析 | Thematic Analysis | 识别重复模式/主题 |
| 内容分析 | Content Analysis | 系统量化文本特征 |
| 话语分析 | Discourse Analysis | 语言使用与社会意义 |
| 理论饱和 | Theoretical Saturation | 新数据不再产生新主题 |

### R包工具

| 任务 | R包 | 功能 |
|------|-----|------|
| 文本挖掘 | `tm`, `tidytext` | 分词、词频统计 |
| 主题模型 | `topicmodels` | LDA主题提取 |
| 情感分析 | `syuzhet`, `sentimentr` | 情感倾向判断 |
| 词云 | `wordcloud`, `wordcloud2` | 可视化高频词 |
| 共现网络 | `quanteda`, `igraph` | 词共现关系 |

---

## 信号处理(Signal Processing)

### 生物医学信号类型

| 信号类型 | 英文 | 采样频率 | 应用 |
|---------|------|---------|------|
| 心电图 | Electrocardiogram (ECG/EKG) | 250-500 Hz | 心律失常检测 |
| 脑电图 | Electroencephalogram (EEG) | 128-512 Hz | 癫痫、睡眠分期 |
| 肌电图 | Electromyography (EMG) | 1000-2000 Hz | 肌肉活动 |
| 心率变异性 | Heart Rate Variability (HRV) | - | 自主神经功能 |
| 脉搏波 | Photoplethysmography (PPG) | 50-100 Hz | 血氧、心率 |

### 核心分析方法

| 中文 | 英文 | 缩写 | 用途 |
|------|------|------|------|
| 快速傅里叶变换 | Fast Fourier Transform | FFT | 时域→频域 |
| 小波变换 | Wavelet Transform | WT | 时频局部化分析 |
| 变分模态分解 | Variational Mode Decomposition | VMD | 信号自适应分解 |
| 经验模态分解 | Empirical Mode Decomposition | EMD | 非线性非平稳信号 |
| 希尔伯特-黄变换 | Hilbert-Huang Transform | HHT | 瞬时频率提取 |
| 功率谱密度 | Power Spectral Density | PSD | 频率成分能量分布 |
| 短时傅里叶变换 | Short-Time Fourier Transform | STFT | 时变频谱 |

### HRV时域指标

| 指标 | 英文全称 | 含义 |
|------|---------|------|
| SDNN | Standard Deviation of NN intervals | NN间期标准差,总体HRV |
| RMSSD | Root Mean Square of Successive Differences | 连续NN间期差值的均方根,副交感活性 |
| pNN50 | Percentage of NN50 | 连续NN间期差>50ms的百分比 |
| SDSD | Standard Deviation of Successive Differences | 连续NN间期差的标准差 |

### HRV频域指标

| 指标 | 频段 | 含义 |
|------|------|------|
| VLF | 0.003-0.04 Hz | 极低频,长期调节 |
| LF | 0.04-0.15 Hz | 低频,交感+副交感 |
| HF | 0.15-0.4 Hz | 高频,副交感活性 |
| LF/HF | - | 交感-副交感平衡 |
| TP | 0-0.4 Hz | 总功率 |

### R包工具

| 任务 | R包 | 核心函数 |
|------|-----|---------|
| ECG分析 | `RHRV`, `heartBeat` | `LoadBeat()`, `CreateHRVData()` |
| 小波变换 | `wavelets`, `WaveletComp` | `dwt()`, `analyze.wavelet()` |
| VMD | `VMDecomp` | `vmd()` |
| 频谱分析 | `signal`, `seewave` | `periodogram()`, `spec()` |
| 滤波器 | `signal` | `butter()`, `filtfilt()` |

---

## 环境流行病学(Environmental Epidemiology)

### 核心概念

| 中文 | 英文 | 说明 |
|------|------|------|
| 混合暴露 | Mixture Exposure | 多种污染物同时暴露 |
| 滞后效应 | Lag Effect | 暴露后延迟出现的健康效应 |
| 剂量-反应关系 | Dose-Response Relationship | 暴露水平与健康结局的关系 |
| 累积暴露 | Cumulative Exposure | 长期暴露总量 |
| 窗口期 | Critical Window | 易感时间段 |
| 协同效应 | Synergistic Effect | 联合效应>单独效应之和 |
| 拮抗效应 | Antagonistic Effect | 联合效应<单独效应之和 |

### 分析方法

| 方法 | 英文 | 缩写 | 适用场景 | R包 |
|------|------|------|---------|-----|
| 分布滞后非线性模型 | Distributed Lag Non-linear Model | DLNM | 温度/空气污染滞后效应 | `dlnm` |
| 加权分位数和 | Weighted Quantile Sum | WQS | 混合物总效应+成分权重 | `gWQS` |
| 分位数g计算 | Quantile g-Computation | qgcomp | 混合物效应分解 | `qgcomp` |
| 贝叶斯核机器回归 | Bayesian Kernel Machine Regression | BKMR | 非线性、交互作用 | `bkmr` |
| 弹性网回归 | Elastic Net | - | 高维变量选择 | `glmnet` |

### 环境暴露指标

| 暴露 | 常用指标 | 单位 |
|------|---------|------|
| 空气污染 | PM2.5, PM10, NO₂, SO₂, O₃, CO | μg/m³, ppm |
| 重金属 | 铅、镉、汞、砷 | μg/L, μg/g |
| 内分泌干扰物 | 双酚A(BPA)、邻苯二甲酸酯(PAEs) | ng/mL |
| 持久性有机污染物 | 多氯联苯(PCBs)、二噁英 | ng/g脂肪 |
| 温度 | 日均温、最高温、最低温 | ℃ |

---

## 流行病学研究设计术语

| 中文 | 英文 | 缩写 | 特点 |
|------|------|------|------|
| 随机对照试验 | Randomized Controlled Trial | RCT | 因果推断金标准 |
| 队列研究 | Cohort Study | - | 前瞻性,计算发病率 |
| 病例对照研究 | Case-Control Study | - | 回顾性,稀有病 |
| 横断面研究 | Cross-Sectional Study | - | 患病率研究 |
| 巢式病例对照 | Nested Case-Control | NCC | 队列内匹配 |
| 病例交叉 | Case-Crossover | - | 自身对照,短期暴露 |

---

## 统计方法缩写对照

| 缩写 | 英文全称 | 中文 |
|------|---------|------|
| PSM | Propensity Score Matching | 倾向性得分匹配 |
| IPW | Inverse Probability Weighting | 逆概率加权 |
| DiD | Difference-in-Differences | 双重差分 |
| IV | Instrumental Variable | 工具变量 |
| RDD | Regression Discontinuity Design | 断点回归 |
| TMLE | Targeted Maximum Likelihood Estimation | 目标最大似然估计 |
| GEE | Generalized Estimating Equations | 广义估计方程 |
| LMM | Linear Mixed Model | 线性混合模型 |
| GAM | Generalized Additive Model | 广义加性模型 |
| SEM | Structural Equation Modeling | 结构方程模型 |
| RCS | Restricted Cubic Spline | 限制性立方样条 |

---

## 领域特定软件

### 卫生经济学
- **TreeAge Pro**: 决策树与马尔科夫模型(商业软件)
- **R包**: `heemod`, `dampack`, `BCEA`

### 质性研究
- **NVivo**: 质性数据编码(商业软件)
- **MAXQDA**: 混合方法分析(商业软件)
- **R包**: `RQDA`, `tm`, `quanteda`

### 信号处理
- **MATLAB**: 信号处理工具箱(商业)
- **Python**: `scipy.signal`, `mne`(EEG)
- **R包**: `signal`, `RHRV`, `wavelets`

### 环境流行病学
- **R包**: `dlnm`, `gWQS`, `qgcomp`, `bkmr`
- **SAS宏**: `%BKMR`, `%DLNM`

---

## 报告规范缩写

| 缩写 | 英文全称 | 用途 |
|------|---------|------|
| CONSORT | Consolidated Standards of Reporting Trials | RCT报告标准 |
| STROBE | Strengthening the Reporting of Observational Studies in Epidemiology | 观察性研究报告 |
| PRISMA | Preferred Reporting Items for Systematic Reviews and Meta-Analyses | 系统综述/Meta报告 |
| CHEERS | Consolidated Health Economic Evaluation Reporting Standards | 卫生经济学评价报告 |
| COREQ | Consolidated Criteria for Reporting Qualitative Research | 质性研究报告 |

---

## 参考资源

### 卫生经济学
- Drummond MF, et al. Methods for the Economic Evaluation of Health Care Programmes (4th ed)
- ISPOR (国际药物经济学与结果研究学会): https://www.ispor.org/

### 质性研究
- Braun & Clarke. Thematic Analysis (2006)
- CAQDAS (质性分析软件网络): https://www.surrey.ac.uk/computer-assisted-qualitative-data-analysis

### 信号处理
- Task Force of ESC/NASPE. Heart Rate Variability (1996)
- PhysioNet: https://physionet.org/ (生理信号数据库)

### 环境流行病学
- Carlin et al. Unraveling the Health Effects of Environmental Mixtures (2019)
- NIEHS (美国环境健康科学研究所): https://www.niehs.nih.gov/
