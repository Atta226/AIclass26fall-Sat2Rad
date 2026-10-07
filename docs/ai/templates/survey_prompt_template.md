你是一名熟悉气象遥感与智能气象、卫星遥感反演雷达降水 / 卫星到雷达的图像翻译和深度学习、图像到图像翻译、视频图像翻译、生成式模型的科研助手。

我正在开展一个关于基于深度学习的卫星遥感雷达降水反演的初步文献调研。

当前阶段的目标不是立即选择某一个模型，而是先建立这个方向的：

* 任务定义
* 技术发展路线
* 代表性方法
* 代表性论文
* 数据集
* Evaluation Protocol
* 当前主要科学问题
* 可复现性情况
* Baseline 与潜在 SOTA 候选

为后续开展正式研究和模型选择提供依据。

请先不要直接回答 Survey 内容，而是根据我下面提供的研究背景，帮我生成一份完整、结构化、可直接用于 ChatGPT / Claude 等大模型开展 Survey 的 Prompt。

---

# 1. 我的研究背景

## 研究领域

气象人工智能 / 卫星遥感 / 计算机视觉

## 具体研究问题

基于卫星遥感观测的雷达降水反演（Satellite-to-Radar Retrieval

## 我真正希望解决的问题

我希望利用气象卫星观测中包含的云顶温度、水汽和云体结构等信息，反演与强对流和降水相关的雷达观测场，从而在缺少或无法获得雷达观测的情况下，利用覆盖范围更广的卫星资料估计降水系统的空间分布和强度结构。

具体而言，基于 SEVIR 数据集中时空配准的 GOES-16 卫星观测与 NEXRAD 雷达 VIL 数据，研究如何建立从卫星图像到雷达 VIL 场的映射关系，并重点关注强降水和强对流区域的位置、形态及强度能否被准确重建。

## Input

模型推理时能够获得的数据：
- GOES-16 C02 可见光观测
  - 原始空间分辨率：0.5 km
  - 原始图像大小：768 × 768
- GOES-16 C09 红外水汽观测
  - 原始空间分辨率：2 km
  - 原始图像大小：192 × 192
- GOES-16 C13 红外亮温观测
  - 原始空间分辨率：2 km
  - 原始图像大小：192 × 192
- GOES-16 GLM 闪电观测
  - 原始空间分辨率约：8 km
  - 连续观测
- C02、C09、C13 等卫星图像时间间隔为 5 min
- 不同空间分辨率的数据在进入模型前进行空间配准和重采样，统一到2km空间网格

- 模型输入既可以采用单时刻多源卫星观测，也可以采用过去一段时间到当前时刻的多源卫星观测序列


## Target / Output

【最终希望预测、反演或识别的对象】

- 雷达 VIL（Vertically Integrated Liquid，垂直积分液态水）二维连续场

原始 VIL：

- 原始空间分辨率：1 km
- 原始图像大小：384 × 384

模型使用的 Target：

- 将原始 VIL 重采样到统一的 2 km 空间网格
- Target 图像大小：192 × 192
- 与输入卫星数据进行时间和空间配准

模型重点恢复：

- 降水和强对流区域的位置
- 降水系统的空间形态
- VIL 强度分布
- 局地高 VIL 区域
- 强对流系统内部的精细空间结构

需要注意：

VIL 从原始 1 km 网格重采样到 2 km 网格主要是为了与卫星输入建立统一的空间对应关系，不代表雷达观测本身发生了变化。

## 时间尺度


- 时间分辨率：5 min
- 任务可以采用单时刻或多时刻卫星观测作为输入
基础时间分辨率：

- 5 min

任务可以采用单时刻或多时刻卫星观测作为输入。

### 1. 单时刻反演

输入：

Satellite(t)

输出：

VIL(t)

即利用当前时刻 t 的多源卫星观测反演同一时刻的雷达 VIL 场。


### 2. 多时刻序列反演

输入：

Satellite(t0), Satellite(t0+Δt), ..., Satellite(t-Δt), Satellite(t)

输出：

VIL(t)

其中：

- Δt = 5 min
- 输入包含过去一段时间直到当前时刻 t 的多源卫星观测
- 输入时间窗口可以根据实验设置选择，例如过去 30 min、60 min 或更长时间
- 利用云系移动、发展、增强和减弱等时间演变信息辅助当前时刻 VIL 反演

该任务属于当前时刻反演，而不是未来时刻降水预报。

核心研究之一是比较：

单时刻卫星信息 → 当前 VIL与多时刻卫星序列 → 当前 VIL

之间的性能差异。

## 空间尺度

模型统一空间网格：

- 空间分辨率：2 km
- 图像大小：192 × 192

单个样本覆盖范围约为：

- 384 km × 384 km

研究空间尺度：

- 区域尺度
- 对流系统尺度

重点关注：

- 中小尺度对流系统
- 强降水区域
- 对流云团空间结构
- 局地高 VIL 核心区域

## 数据条件

使用公开的 SEVIR（Storm EVent ImageRy）多源气象数据集。

当前可使用的数据包括：

- GOES-16 C02 可见光观测
- GOES-16 C09 红外水汽观测
- GOES-16 C13 红外亮温观测
- GOES-16 GLM 闪电观测
- 雷达 VIL 产品

不同数据源具有不同的原始空间分辨率，因此需要进行：

- 时间匹配
- 空间配准
- 空间重采样
- 多模态数据对齐

最终统一到 2 km、192 × 192 的空间网格。

其中：

- C02、C09、C13 和 GLM 等卫星观测作为模型 Input
- VIL 作为监督学习的 Target
- 数据具有连续时间信息，因此既可以构建单时刻样本，也可以构建多时刻序列样本


## 当前已知方法

未知

## 当前最关心的问题

- 对于 Satellite → Radar VIL 任务，应该选择哪些具有代表性的 Baseline？

- 当前任务属于何种类型的深度学习任务？

- GAN、Transformer、Diffusion 等方法中，哪些适合当前 Satellite-to-Radar 任务？

- 哪些方法具有公开代码，并且能够真正复现？

- 哪些方法提供公开预训练权重，或者能够较容易迁移到当前数据？

- 单时刻卫星输入和多时刻卫星序列输入，哪种任务设计更适合 VIL 反演？

- 如何有效融合 C02、C09、C13 和 GLM 等不同模态、不同原始空间分辨率的数据？

- 对于多时刻输入，应该采用 ConvLSTM、时空 Transformer、Video Transformer，还是其他时序建模方式？

- 当前方法能否准确恢复高 VIL、强降水和强对流核心区域？

- 模型是否容易出现空间位置正确但强度偏弱、强降水区域过度平滑等问题？

- MSE、MAE、SSIM 等常规图像指标是否足以评价该任务，还需要哪些针对强降水和强对流结构的气象评价指标？

- 当前 Satellite-to-Radar 相关研究已经发展到什么程度，还有哪些值得进一步研究的问题？
---

# 2. 请为我生成的 Survey Prompt 必须覆盖以下内容

## A. Task Definition

要求 Survey 首先区分该领域中可能存在的不同任务定义。

至少分析：

* Input
* Target
* AI Task
* 时间分辨率
* 空间分辨率
* Forecast Lead Time 或预测范围
* Deterministic / Probabilistic
* Evaluation Protocol

如果不同论文研究的任务不同，不允许直接比较性能。

---

## B. Technical Taxonomy

要求建立技术谱系，而不是简单罗列论文。

按照：

【传统方法】
→【早期深度学习】
→【主流深度学习】
→【生成式方法】
→【最新研究方向】

梳理方法发展。

每一类方法说明：

* 核心思想
* 主要解决什么问题
* 相比前一类方法改进在哪里
* 优点
* 局限
* 适用场景
* 计算成本
* 是否表达不确定性

---

## C. Representative Papers

每个主要方向至少给出若干篇代表论文。

每篇论文至少整理：

* Title
* Authors
* Year
* Journal / Conference
* DOI 或正式论文链接
* Task
* Input
* Target
* Dataset
* Model
* Innovation
* Baseline
* Metrics
* Main Results

要求区分：

* Landmark Paper
* Strong Baseline
* Recent Representative Work
* Potential SOTA

---

## D. Dataset Survey

对主要公开 Dataset 整理：

* 数据来源
* 数据类型
* 空间覆盖
* 时间覆盖
* 时间分辨率
* 空间分辨率
* 样本规模
* Train / Validation / Test 划分
* 下载方式
* License
* 哪些论文使用过

---

## E. Evaluation

不要只列指标名称。

要求分析：

* 指标定义
* 适合评价什么
* 不适合评价什么
* 是否存在指标偏差
* 极端事件中是否可能产生误导

要求明确区分：

* Pixel-level Metric
* Structure Metric
* Event-based Metric
* Probabilistic Metric
* Physical / Domain-specific Evaluation

---

## F. Scientific Challenges

不要只总结“模型存在的问题”。

请从：

* 数据
* 物理过程
* 可预报性
* 极端事件
* 泛化
* 不确定性
* 观测误差
* 计算效率
* 业务应用

等角度总结当前主要科学问题。

每个问题至少回答：

1. 为什么它是问题；
2. 当前已有解决方法；
3. 目前还没有解决好的部分。

---

## G. Reproducibility

对每个重要模型检查：

* Paper 是否公开
* Code 是否公开
* Official Repository 是否存在
* Pretrained Weight 是否公开
* Dataset 是否公开
* Training Details 是否完整
* Loss 是否公开
* Hyperparameters 是否公开
* 能否完整复现

请特别强调：

**论文公开 ≠ 代码公开 ≠ 权重公开 ≠ 可完整复现。**

---

## H. Baseline 与 SOTA

不要简单回答：

“当前最好的模型是什么？”

而是分别判断：

* Classical Baseline
* Deep Learning Baseline
* Strong Baseline
* Generative Baseline
* Potential SOTA
* Operational Baseline

对于每个候选方法，从以下角度评价：

* Task Match
* Dataset Match
* Benchmark Performance
* Reproducibility
* Compute Cost
* Engineering Complexity
* Scientific Value

---

# 3. 文献核验要求

生成的 Survey Prompt 必须明确要求模型：

* 优先检索同行评审论文；
* 优先使用出版社页面、作者主页、官方仓库；
* 不得编造论文；
* 不得编造 DOI；
* 不得仅依据标题推断论文内容；
* 第三方 GitHub 与 Official Repository 必须区分；
* 无法确认的信息必须写“未确认”；
* Recent / SOTA 必须核验论文发表时间和 Benchmark；
* 尽量交叉验证论文、代码和项目主页。

---

# 4. 最终输出结构

生成的 Survey Prompt 应要求最终 Survey 至少包含：

1. Research Scope
2. Task Taxonomy
3. Technical Evolution
4. Representative Models
5. Representative Papers
6. Dataset Comparison
7. Evaluation Protocol
8. Reproducibility Comparison
9. Scientific Challenges
10. Baseline Recommendation
11. Potential Research Directions
12. Further Search Keywords

同时至少生成以下表格：

### Model Table

| Method | Task | Input | Output | Deterministic / Probabilistic | Dataset | Code | Weight | Loss |

### Paper Table

| Paper | Year | Task | Dataset | Model | Baseline | Metrics | DOI |

### Dataset Table

| Dataset | Data Type | Resolution | Coverage | Availability |

### Reproducibility Table

| Model | Code | Weight | Training Details | Loss | Dataset | Reproducible |

---

# 5. 输出要求

请首先分析我提供的研究背景中是否存在：

* 问题定义不清；
* Input / Target 不明确；
* Task 混淆；
* 时间尺度或空间尺度缺失；
* Survey 范围过宽；
* 已经预设某一种模型导致技术路线偏置。

如果存在这些问题，请先指出。

然后生成一份：

**完整、可直接复制给 ChatGPT / Claude 使用的 Survey Prompt。**

不要直接替我完成 Survey。

最终生成的 Prompt 应具有足够约束，使模型不会简单输出“论文列表”，而是完成一个结构化、可核验、面向科研决策的初步 Survey。
