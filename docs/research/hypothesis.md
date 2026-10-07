# Scientific Questions / Hypotheses

更新：2026-09-18。以下来自前期对话和项目方向确认，是待验证假设，不是既有实验结论或首创性声明。

## 用户明确提出并保留的后续研究假设

以下五项是当前课题后续准备重点验证的核心假设，不只是一般性的开放问题：

### 核心假设 1：长时序多帧信息有助于当前单帧反演

相较只输入目标时刻的一帧卫星观测，输入更长的历史卫星序列能够提供云体移动、发展、消散、云顶降温和闪电演变信息，从而改善当前时刻 VIL 的反演，尤其是强对流核心的定位和强度恢复。

```text
Satellite(t−n:t) → VIL(t), Lead Time = 0
```

验证方式：在同一数据划分、输入模态、loss 和训练预算下比较 T=1/3/7/13；先用 frame stacking 验证“历史信息本身”的价值，再比较 ConvLSTM、3D CNN、VRT/RVRT/Burstormer 等显式时序结构。若增益只来自更多参数、只出现在少数案例，或长窗口没有稳定改善，则该假设不成立。

### 核心假设 2：保留原生分辨率比预先统一分辨率更有效

2025 年前序任务先把所有输入统一到同一分辨率，可能在进入模型前丢失高分辨率卫星纹理。2026 年假设：让不同模态以原生或近原生分辨率分别编码，在特征层完成尺度对齐，并在 decoder 末端上采样到目标 VIL 网格，可以比 early resize 更好地恢复细节和强核结构。

验证方式：比较 `early resize`、`统一低分辨率编码 + 最后一层上采样`、`native multi-encoder + feature fusion + decoder upsampling`。三组必须使用相同物理覆盖范围、Target、split，并控制参数量和计算预算。若只有图像尺寸增大或输出变平滑，而强核、FSS、定位和数值误差没有稳定改善，则该假设不成立。

### 核心假设 3：文献支持 GLM 对强对流反演有增益；本项目检验其在 VIL 上的增益及最佳表示

“闪电信息有作用”已有相关论文支撑，不只是本项目的直觉：

- **直接 Satellite→Radar 证据**：GREMLIN 使用 ABI C07/C09/C13 和 GLM lightning groups 重建 MRMS composite reflectivity。论文的 channel-withholding、空间信息屏蔽与 LRP 分析表明，高反射率技巧来自辐射梯度与闪电信息的共同作用；GLM 能帮助网络定位强雷达回波，作者称其在定位强回波方面具有独特价值。[Hilburn et al., 2021](https://doi.org/10.1175/JAMC-D-20-0084.1) · [开放预印本](https://arxiv.org/abs/2004.07906)
- **受控消融的邻近 QPE 证据**：Yang et al. 使用相同 CNN 架构、训练设置和 ABI 输入，专门比较 `CNN w/ GLM` 与 `CNN w/o GLM`。论文结论指出 lightning data 对 precipitation retrieval 有帮助，尤其是 heavy precipitation。[Yang et al., 2023](https://doi.org/10.1109/TGRS.2023.3322352) · [NOAA 全文](https://repository.library.noaa.gov/view/noaa/61892/noaa_61892_DS1.pdf)
- **VIL 基准实践**：SEVIR 官方 synrad 将过去 5 min flashes 与 IR069/IR107 一起输入模型，说明 GLM 已进入最接近本项目的公开 VIL baseline；但该实验本身不能替代本项目的无 GLM/有 GLM 严格消融。[SEVIR §3.4](https://proceedings.neurips.cc/paper/2020/file/fa78a16157fed00d7a80515818432169-Paper.pdf)
- **更早的 VIL 多源先例**：Veillette et al. 将闪电密度、静止卫星和 NWP 融合估计 NEXRAD VIL，并指出产闪电的孤立对流单体通常能被较好描绘；该论文支持闪电作为 VIL 输入的可行性，但不能单独量化 GLM 的净增益，因为它使用的是地基闪电资料且没有同配置 GLM 消融。[Veillette et al., 2018](https://doi.org/10.1175/JTECH-D-18-0010.1)

因此，本项目需要验证的更具体假设是：上述闪电增益能够迁移到当前 SEVIR→VIL 协议，并且聚合设计决定增益大小。2025 年前序任务没有加入闪电；2026 年先比较 `IR/VIS → VIL` 与 `IR/VIS + GLM → VIL`，再检验 1/5/10/15/30 min 聚合窗及 event、group、flash count、density、energy 等表示。

验证方式：先做无 GLM/有 GLM 的模态消融，再在相同样本上改变一个 GLM 变量。所有窗口截止于 `t`。只有当高 VIL 的 CSI/POD、定位或结构改善，同时 FAR 和频率偏差没有不可接受的恶化，才支持该假设；还要单列无闪电降水，防止模型把“无闪电”错误解释成“无降水”。

### 核心假设 4：DRDD 为第一 SOTA 迁移备选，PairFlow 为 Flow Matching 备选

当前 baseline 是 SEVIR 官方 synrad。前期对话推荐的最佳 2026 前沿迁移模型是 **DRDD**：它来自 CVPR 主会，直接研究 paired cross-domain I2I，突出 limited paired data，并公开代码与预训练模型。因此它同时满足任务形式接近、研究动机吻合和可复现性较强三个条件。

**PairFlow** 作为第二个 SOTA 迁移备选，代表 Flow Matching 路线。它直接处理 paired I2I，在 aerial→map 等任务中强调结构保真和较低训练成本，与“遥感观测→空间场”具有形式相似性。它的限制是 CVPR Workshop、checkpoint 未确认，且没有直接证明 limited paired data 优势，因此排在 DRDD 之后。

验证方式：使用相同的 1/5/10/25/100% paired training subsets、验证/测试集和重复随机种子，对比 U-Net/强确定性模型、DRDD 与 PairFlow，报告学习曲线、强核、结构、校准、训练和推理成本。主要假设是 DRDD 在少样本区间更有效；次要假设是 PairFlow 能以较低成本保持空间结构。若优势只出现在全量数据、视觉指标或单个 seed，就不支持相应假设。

### 核心假设 5：白天可见光能够提供红外缺少的云体结构信息

可见光反射率在白天能够呈现云体纹理、边界、局地起伏和细尺度结构，这些信息可能改善当前 VIL 的位置、形态和强对流核心识别。该方向也有直接文献依据：FY-4A Attention U-Net 工作同时研究 IR-only 与 VIS+IR，论文报告加入 VIS/NIR 后整体表现优于仅使用 IR；但模型仍存在强回波低估。[Yang et al., 2023](https://doi.org/10.3390/s23010081) · [开放全文](https://pmc.ncbi.nlm.nih.gov/articles/PMC9824039/) 2018 Synthetic Radar CNN 也把 1 km visible 与多个 IR、闪电和 NWP 共同用于 VIL 估计，提供多源 VIL 的较早先例，但没有隔离可见光净贡献。[Veillette et al., 2018](https://doi.org/10.1175/JTECH-D-18-0010.1)

本项目的具体假设是：在太阳天顶角满足可见光有效条件的**同一白天样本子集**上，`IR + GLM + C02` 相比 `IR + GLM` 能改善 VIL 的边界、定位、FSS 和强核识别；保留 C02 较高原生分辨率可能进一步优于先降采样后拼接。

验证方式：固定白天样本、Target、split、GLM、loss 和训练预算，比较无 C02/有 C02，以及 C02 early resize/native-resolution branch。不得用“全天 IR 模型”与“仅白天 VIS 模型”的不同样本集直接归因可见光。夜间 C02 不可用，应另外比较昼夜分支、显式 availability mask 或 modality dropout。若增益来自样本筛选、只改善普通图像观感，或在结构与强核指标上不稳定，则该假设不成立。

上述五项分别对应 H1、H4、H3、H9 和 H2；实验编号对应 T01、F01、M01/G01、S01 和 V01。

## 扩展假设表

| ID | 已知限制 → 已有尝试 | 尚未确定的问题 | 可检验假设与反证 |
|---|---|---|---|
| H1 长时序多帧→单帧 | 已调研的直接反演多数是单帧；卫星历史可提供移动、云顶降温、膨胀和闪电演变信息 | lead=0 的长时序是否能减少 Satellite→VIL 非唯一性，以及收益随窗口是否饱和 | 在同 split/loss/预算下，T3/T7/T13 相对 T1 稳定提高当前 VIL 的强核、结构和定位技巧；若收益只来自参数量、仅少数个例出现或长窗无稳定增益，则不支持该假设 |
| H2 C02 / 可见光 | FY-4A 的 IR-only 与 VIS+IR 对照支持 VIS/NIR 的增量作用；C02 具有较细空间结构但仅在有日照时有效 | 在共同白天子集上，C02 是否改善 VIL 边界、定位、FSS 和强核；原生 C02 分支是否优于先降采样 | 固定白天样本后加 C02 仍稳定改善；不同样本集、仅视觉变清晰或夜间错误填零造成的差异不支持该假设 |
| H3 GLM | GREMLIN 的 withholding/LRP 支持闪电对强回波定位的独特价值；ABI+GLM QPE 有 w/GLM 与 w/o GLM 受控比较；SEVIR 使用 5 min flashes | 文献增益能否迁移到本项目 VIL；1/5/10/15/30 min 与 event/group/flash count、density、energy 中哪些可用组合更好 | 先复现加 GLM 相对无 GLM 的强 VIL 改善，再证明特定表示稳定改善 CSI/POD 且不过度增加 FAR，并在无闪电降水上不系统退化 |
| H4 分辨率融合 | 0.5/2/约8 km 信息不等价；2025 前序任务已统一分辨率 | 原生多分支相对 early resize 和“最后一层上采样”的收益 | 控制容量后仍改善强核、FSS 和定位；只增加参数、输出尺寸或产生更平滑结果不算分辨率证据 |
| H5 极值损失 | 长尾与平均化 → weighted loss/GAN/diffusion | 召回与虚警折中 | P99 偏差和强核 CSI 改善且面积/频率不失真；只提高 POD 不足 |
| H6 概率重建 | 多解性 → 条件生成 | 清晰度与可信概率能否兼得 | CRPS、可靠性、强核与 FSS 一起提供证据；仅 LPIPS 改善不足 |
| H7 标签粗化 | 1→2 km 改变尾部分布 → 平均/插值/最大值 | 模型结论受预处理影响多大 | 未训练先量化标签变化；不同物理定义不可混作同一 Target 比分 |
| H8 泛化/一致性 | 事件抽样、地区/季节变化、逐帧闪烁 | 收益是否跨情景成立 | 分层与连续案例重复验证；只少数好例不构成普遍证据 |
| H9 前沿 I2I / 少样本迁移 | DRDD 强调 limited paired cross-domain I2I；PairFlow 强调 paired Flow Matching、结构保真和训练效率 | DRDD 是否提高少样本效率；PairFlow 是否以较低成本保持 VIL 空间结构 | 在 1/5/10/25% paired data 与重复 seed 下分别优于统一基线；只在全量数据、单一感知指标或单个 seed 占优不支持对应优势 |

每次实验必须预先列出主要指标、受控变量与何种结果会否定假设。参见 [实验设计](experiments.md) 和 [评价协议](evaluation.md)。

H1、H2、H3、H4、H9 是用户明确保留的核心未来方向。H1 研究历史卫星序列到**当前单帧** VIL，Lead Time 仍为 0；不得借用 future-radar nowcasting 的性能直接证明其成立。H2 必须在共同白天样本上评价，并把夜间可用性作为独立问题。SEVIR 官方 synrad 是 baseline 锚点；DRDD 是首选 SOTA 迁移备选，PairFlow 是 Flow Matching 备选，二者都不是本项目已经取得的结果。
