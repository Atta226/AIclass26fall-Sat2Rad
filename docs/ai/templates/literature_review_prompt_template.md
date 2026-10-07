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
## 2. Review Scope

请首先明确本综述的任务边界，并回答：

- 哪些工作属于本研究主题；
- 哪些工作看似相关但任务不同；
- 哪些任务不能直接比较；
- 是否存在不同 Input / Target / Lead Time / Resolution / Evaluation Protocol；
- 不同研究是否使用不同标签定义或事件标准。

如果任务定义不同，请分组综述，禁止直接比较指标。

---

## 3. Technical Evolution

请按照“方法为什么出现、解决了什么问题”的逻辑梳理技术演进，而不是按年份简单堆论文。

建议结构：

1. 传统方法 / 物理方法 / 统计方法
2. 早期机器学习
3. 早期深度学习
4. 主流网络架构
5. 时空建模方法
6. 生成式 / 概率方法
7. 多源融合方法
8. Foundation Model / Pretrained Model
9. 最新研究方向

每一类方法请说明：

- 核心思想；
- 主要解决什么问题；
- 相比前一阶段的改进；
- 主要优点；
- 主要局限；
- 适用任务；
- 对数据量的要求；
- 对算力的要求；
- 是否支持概率预测或多解；
- 是否具有业务部署价值。

---

## 4. Representative Papers

每个主要方向至少选择若干篇真正具有代表性的论文。

优先包括：

- Landmark Paper
- Frequently Used Baseline
- Strong Baseline
- Recent Representative Work
- Potential SOTA
- Operational / Applied Work

对每篇论文至少整理：

| Field | Content |
|---|---|
| Title | |
| Authors | |
| Year | |
| Journal / Conference | |
| DOI / Official Link | |
| Task | |
| Input | |
| Target | |
| Dataset | |
| Spatial Resolution | |
| Temporal Resolution | |
| Forecast Lead Time | |
| Model | |
| Key Innovation | |
| Baseline | |
| Metrics | |
| Main Result | |
| Limitation | |
| Code | |
| Weight | |
| Training Details | |
| Loss | |

不要只写论文摘要，要说明其在技术发展链条中的作用。

---

## 5. Method Comparison

请建立方法对比表：

| Method | Core Idea | Task | Strength | Weakness | Deterministic / Probabilistic | Compute Cost | Reproducibility |
|---|---|---|---|---|---|---|---|

重点比较：

- 建模对象是否相同；
- 是否考虑空间结构；
- 是否考虑时间演变；
- 是否能够处理生消过程；
- 是否表达不确定性；
- 是否容易出现模糊平均；
- 是否适合极端事件；
- 是否适合长提前量；
- 是否容易复现。

---

## 6. Dataset and Evaluation

请分别整理主要数据集和评价协议。

### Dataset Table

| Dataset | Data Type | Region | Resolution | Time Range | Availability | Representative Papers |
|---|---|---|---|---|---|---|

### Evaluation

请区分：

- Pixel-level Metrics
- Structure Metrics
- Event-based Metrics
- Threshold-based Metrics
- Probabilistic Metrics
- Physical / Domain-specific Metrics

对每种指标说明：

- 衡量什么；
- 优点；
- 局限；
- 是否可能与真实科学价值不一致；
- 是否可能对极端事件产生误导。

---

## 7. Scientific Challenges

不要只从“模型结构”总结问题。

请从以下角度分析：

- 数据质量
- 标签可靠性
- 观测误差
- 时空尺度
- 可预报性
- 极端样本稀缺
- 多解性
- 泛化能力
- 物理一致性
- 模型稳定性
- 计算效率
- 实时业务部署

每个问题请回答：

1. 为什么它重要；
2. 当前研究如何处理；
3. 仍然存在什么不足；
4. 哪些论文对这个问题有直接讨论。

---

## 8. Evidence Chain

对于任何“某方法更好”“某方法是SOTA”“某方向更有前景”的判断，请给出完整证据链：

- 比较任务是否相同；
- Dataset 是否相同；
- Split 是否一致；
- Evaluation Protocol 是否一致；
- Baseline 是否公平；
- 是否有统计显著性或多个案例支持；
- 是否只在单一 Benchmark 上领先；
- 是否存在计算成本显著增加的问题。

不要把“指标更高”直接等价为“科学问题解决得更好”。

---

## 9. Reproducibility

对重要方法检查：

- Paper
- Official Code
- Pretrained Weight
- Dataset
- Training Script
- Configuration
- Hyperparameters
- Loss
- Data Preprocessing
- Evaluation Script

请明确区分：

**论文公开 ≠ 代码公开 ≠ 权重公开 ≠ 训练细节公开 ≠ 可完整复现。**

---

## 10. Final Output

最终综述请包含：

1. Research Scope
2. Task Definition
3. Technical Evolution
4. Representative Papers
5. Method Comparison
6. Dataset Comparison
7. Evaluation Protocol
8. Scientific Challenges
9. Reproducibility Analysis
10. Strong Baselines
11. Potential SOTA
12. Open Research Questions
13. Recommended Next Research Step
14. Search Keywords

最后给出一个简短判断：

> 如果现在开始一个新的【研究主题】项目，最值得复现的 Baseline 是什么，最值得进一步研究的方向是什么，为什么？

---

## 11. Verification Requirements

必须遵守：

- 不编造论文；
- 不编造 DOI；
- 不仅凭标题判断论文内容；
- 优先使用论文原文、出版社页面、作者主页和官方仓库；
- Official Repository 与 Third-party Implementation 必须区分；
- 无法确认的信息写“未确认”；
- 最新 / SOTA 必须核验时间和 Benchmark；
- 对关键结论尽量进行交叉验证；
- 不得将不同任务、不同数据集、不同评价协议的数字直接比较。
