# 深度学习方法路线与候选设计

更新：2026-09-18。本文回答“用什么计算方法解决任务”，与 [气象领域路线](../project/knowledge.md) 分开。以下均为候选设计，尚无本项目训练结果。

## 方法路线

```text
统计/浅层回归 → CNN → Encoder–Decoder / U-Net
                         ├─ residual / attention / multiscale
                         ├─ cGAN / Pix2Pix-like translation
                         ├─ Transformer / hierarchical restoration models
                         └─ conditional diffusion / probabilistic generation

交叉维度：单帧或时序 × 融合位置 × 原生分辨率 × 损失函数 × 缺失模态
```

该图组织计算方法，不是按年份给 Satellite-to-Radar 领域排代际。Transformer、GAN 和 diffusion 可以与 CNN/多分支组合。

## 方法/模型体系表

| Method | 核心与项目用途 | Strength | Limitation | 确定性/概率性 | 相对成本与证据 |
|---|---|---|---|---|---|
| 线性回归、RF、浅层 CNN | 亮温/通道差/闪电特征到 VIL；检验复杂网络增益 | 简单、便于建立下限 | 像素方法上下文弱、对象结构难恢复 | 通常确定性 | 低；RF 为领域历史参照，具体项目版本待实现 |
| CNN / Encoder–Decoder / U-Net | 多尺度卷积与跳接，逐像元输出连续值 | 局地空间结构、训练和复现方便 | 单点损失可能平滑、长距离关系有限 | 确定性 | 低–中；SEVIR synrad 直接依据 |
| Residual / Attention / Multiscale U-Net | 加强特征选择与多尺度融合 | 强 CNN 对照候选 | 不能仅凭模块名保证改善强核 | 确定性 | 中；FY-4A 等直接工作，见文献表 |
| Multi-branch CNN | VIS、IR、GLM 分别编码后融合 | 保留分辨率差异与模态语义 | 配准、参数与显存成本上升 | 通常确定性 | 中；2018 多源 CNN 为先例 |
| cGAN / Pix2Pix-like | 条件生成器+判别器，重建项+adversarial loss | 可能恢复边缘和纹理 | 虚构强核、定量偏差、训练不稳；不保证校准 | 生成式，不自动等于概率模型 | 中；SEVIR cGAN 可作同数据参照 |
| Transformer / ViT | 注意力编码跨位置关系，解码为雷达场 | 大范围空间关系、跨模态交互 | 数据与算力要求取决架构；patch 化也可能损失局部细节 | 通常确定性 | 中–高；MAFormer/SRViT 为直接工作 |
| Hierarchical / Swin / restoration Transformer | 分层窗口、局部与全局特征用于稠密重建 | 可控注意力成本，适合图像恢复设计 | 本轮未确立其在本项目协议的优势 | 通常确定性 | 方法候选，不能当已验证领域 SOTA |
| Conditional diffusion / latent diffusion / DiT | 卫星条件下逐步生成或修正雷达样本 | 表达多解、结构与条件分布的可能性 | 多步推理、VAE 极值损失、幻觉和校准风险 | 随机生成；需概率评估 | 高且依采样步数；DiffSR/Hu/SRDiff 是不同实现 |

基础方法名称仅作分类；论文对象单独列在 [literature.md](literature.md)，不把 U-Net、SEVIR 数据集和论文标题当作同一层实体。通用 CV 方法的成功不能证明本任务收益。Transformer/DiT 不自动属于 Foundation Model，本轮未建立 foundation pretraining 优于任务专用基线的证据。

## 确定性与生成式学习

在平方损失理想条件下，最优点估计为条件均值 E[Y|X]；若条件分布包含位移或结构多解，平均可能表现为模糊与峰值减弱。L1 对应条件中位数，也不能保证恢复唯一真实强核。这是统计解释，不是每个模型必然低估全部极值的定律。

GAN 加入分布/纹理约束，但“雷达般的纹理”不等于当前个例的正确水凝物结构；普通确定性 Pix2Pix 生成器也未必提供有意义的集合离散度。Diffusion 允许条件采样，价值应由强核识别、分布、FSS 和概率校准共同检验，不能用视觉锐利替代条件准确性。直接依据：[SEVIR synrad](https://proceedings.neurips.cc/paper/2020/file/fa78a16157fed00d7a80515818432169-Paper.pdf)、[Hu 等](https://doi.org/10.1175/AIES-D-25-0016.1)、[SRDiff 代码](https://github.com/42xingxing/SRDiff)。

## 时序方法：历史信息和架构分别比较

### 明确保留的未来方向

当前已调研的直接 Satellite-to-Radar retrieval 文献以单帧/当前时刻输入为主。因此，本项目将“较长历史卫星序列 → 当前单帧 VIL”作为未来方向之一：

```text
Satellite(t−n:t) → VIL(t),  Lead Time = 0
```

历史序列可能提供单帧缺少的移动、云顶降温、云体扩张、对流增强/减弱和闪电趋势，从而减少仅凭瞬时云顶外观推断云内水凝物的非唯一性。这里需要验证的是**时序信息是否有用**，随后才是**哪种时序架构更好**。

| 方法 | 表示 | 用途与限制 |
|---|---|---|
| Frame stacking U-Net | [T,C,H,W] → [T×C,H,W] | 第一层时序对照；固定窗口，缺少显式时序状态 |
| ConvLSTM / ConvGRU | 按历史顺序更新空间隐状态 | 检验显式记忆；顺序计算与长序列训练成本 |
| 3D CNN / Temporal CNN | 时空卷积或时间维卷积 | 局部演变模式；窗口、边界和感受野须明确 |
| 时空/Video Transformer | 时空注意力或分块注意力 | 更长依赖候选；与 CNN 比较时控制训练预算 |

建议 T=1/3/7/13，分别覆盖当前、过去 10/30/60 min 加当前。所有输出仍是 VIL(t)。若研究 15 min 历史，在 5 min 步长且包含两端时为 4 帧，不能误写为 3 帧。

历史提供移动、降温、膨胀及闪电变化的潜在线索；是否稳定改善 lead=0 反演须实验。先用 frame stacking 隔离“增加历史信息”的贡献，再比较 ConvLSTM/ConvGRU、3D CNN、时空 Transformer 或适合长序列的状态空间模型。EF Sat2Rad 是 future radar，不能用它的预报分数证明这里的多帧收益。参见 [EF 论文](https://arxiv.org/abs/2310.19515)。

## 多模态、多分辨率与缺失

| 方案 | 具体设计 | 需要控制的混淆 |
|---|---|---|
| Early fusion | 全部配准到 192²，通道拼接 | 输入变换、GLM 插值、VIS 信息损失 |
| Feature/native-resolution fusion | VIS 768²、IR 192²、GLM 栅格分别编码，特征层融合 | 增益来自分辨率还是更大参数量 |
| Attention/gating fusion | 按位置与模态选择信息 | attention 图不是因果解释证据 |
| Late fusion | 模态独立估计后合并 | 无法充分建模底层跨模态交互，仍可作对照 |
| Missing-modality model | 输入掩码、modality dropout 或昼夜分支 | 训练缺失分布必须覆盖推理；零填充值不得与真实值混淆 |

模态候选：C09+C13；再加 GLM；白天加 C02；最后检验统一缺失模态模型。NWP/DEM 是领域工作中的辅助信息，本项目没有决定加入；若加入必须记录实时可用时刻，不能用未来分析资料泄漏答案。

用户提供的项目历史是：2025 年前序任务先把不同资料统一到同一空间分辨率，且没有加入闪电；2026 年计划明确检验“保留原生分辨率”和“加入 GLM”是否带来增益。这是项目内部背景，不是公开论文结论。

“不预先统一分辨率”仍需要统一地理投影、覆盖范围、像元中心和时间；区别在于不把所有观测一开始就插值成同一数组。推荐实验结构为各模态在原生或近原生网格独立编码，在一个或多个物理尺度上对齐特征，再由 decoder 输出目标 VIL 网格。仅在最后附加一个上采样层可作为最小对照，但若低分辨率编码已经丢失 VIS 纹理，该层不能凭空恢复信息。F01 应同时比较 early resize、单次末端上采样和 multi-encoder/feature-pyramid decoding，并控制参数量、输入物理范围与 Target。

## 可迁移 AI/CV 模型候选表

下表整理前期对话给出的迁移候选，并在 2026-09-18 对关键论文/仓库重新核验。等级表示**对本项目的候选优先级**，不是原任务排行榜；所有模型都尚未在 SEVIR Satellite→VIL 的统一协议上验证。

### 当前 SOTA 迁移备选与推荐顺序

这里的“SOTA 备选”指从 2026 年最新跨域 I2I 方法中选出的**待迁移前沿模型**，不是已经在 Satellite-to-Radar 榜单上取得 SOTA。前期对话的推荐顺序现明确为：

| 顺位 | 候选 | 为什么进入 SOTA 备选 | 当前限制 |
|---:|---|---|---|
| **1** | **DRDD（首选/最佳推荐）** | 2026 CVPR 主会；直接面向 paired cross-domain I2I；把 domain harmonization 与 residual semantic mapping 解耦；尤其强调 limited paired data 的数据效率；官方代码和预训练模型已公开。Satellite→VIL 同样是有配对监督的跨域稠密场映射，因此任务形式、少样本动机和复现条件三方面最匹配。 | 尚未在气象数据、VIL 极值或物理一致性上验证；diffusion 成本和预训练域差异仍需测试。 |
| **2** | **PairFlow（Flow Matching 备选）** | 2026 CVPR Workshop；专门研究 paired I2I，以条件 Flow Matching 同时追求 perceptual quality 与 structural fidelity；包含 aerial imagery→map，和“遥感观测→空间场”的结构较接近；论文还强调较低训练计算量。 | Workshop 证据等级低于 DRDD 主会；公开 checkpoint 尚未确认；aerial→map 仍不等于 Satellite→VIL，也没有少样本优势的直接结论。 |

因此，若只迁移一个 2026 前沿模型，优先 DRDD；若需要比较两条最新生成路线，则使用 `DRDD（diffusion/residual decoupling）` 对比 `PairFlow（flow matching）`。LBM、DBIM、DDBM、BBDM 等作为第二梯队 bridge/translation 参照。

### 跨域 I2I、Bridge、Flow 与 Diffusion

| 模型 | 年份·会议 / 原任务 | 等级 | 论文 | 官方实现 / 权重状态 | 迁移判断 |
|---|---|---|---|---|---|
| DRDD | 2026 CVPR；paired cross-domain I2I | **Top-1 SOTA 迁移备选；最佳推荐** | [CVF](https://openaccess.thecvf.com/content/CVPR2026/html/Lin_Decoupled_Residual_Denoising_Diffusion_Models_for_Unified_and_Data_Efficient_CVPR_2026_paper.html) | [GitHub，含预训练模型](https://github.com/HKU-HealthAI/DRDD) | 跨域任务形式、limited paired data 动机、代码和权重完整度最匹配；优先检验少样本学习曲线。 |
| PairFlow | 2026 CVPRW；paired I2I、aerial→map | **Top-2 SOTA 迁移备选；Flow Matching 路线** | [CVF](https://openaccess.thecvf.com/content/CVPR2026W/AIGENS/html/Mahara_PairFlow_Efficient_Flow_Matching_for_Paired_Image-to-Image_Translation_with_Perceptual_CVPRW_2026_paper.html) | [GitHub](https://github.com/amaha7984/PairFlow)；checkpoint 未确认 | paired Flow Matching、结构保真、遥感→地图任务和训练效率具有吸引力；Workshop 与权重状态使其优先级低于 DRDD。 |
| RDBM | 2026 CVPR；restoration/translation bridge | Medium–Strong | [CVF](https://openaccess.thecvf.com/content/CVPR2026/papers/Wang_Residual_Diffusion_Bridge_Model_for_Image_Restoration_CVPR_2026_paper.pdf) | [GitHub](https://github.com/MiliLab/RDBM)；权重待验收 | residual 调制可区分需修改区域；主要证据仍来自 degraded→clean。 |
| LBM | 2025 ICCV Highlight；cross-domain I2I、depth/normal | **Strong** | [CVF](https://openaccess.thecvf.com/content/ICCV2025/papers/Chadebec_LBM_Latent_Bridge_Matching_for_Fast_Image-to-Image_Translation_ICCV_2025_paper.pdf) | [GitHub](https://github.com/gojasper/LBM)；HF 权重 | 连续稠密场和 single-step inference 与本任务较匹配。 |
| DBIM | 2025 ICLR；fast diffusion bridge | **Strong** | [OpenReview](https://openreview.net/pdf?id=eghAocvqBk) | [GitHub](https://github.com/thu-ml/DiffusionBridge)；复用 DDBM checkpoints | 用较少 NFE 加速 bridge，适合评价概率式反演与业务速度的折中。 |
| Dual-approx Bridge | 2025 CVPR；deterministic I2I | **Strong** | [CVF](https://openaccess.thecvf.com/content/CVPR2025/papers/Xiao_Deterministic_Image-to-Image_Translation_via_Denoising_Brownian_Bridge_Models_with_Dual_CVPR_2025_paper.pdf) | [GitHub](https://github.com/bohan95/dual-app-bridge)；checkpoint 待验收 | 强调确定性映射与 GT fidelity，适合单一监督 VIL 场。 |
| Scaling Diffusion for Perception | 2025 CVPR；depth/flow/dense perception | Medium–Strong | [CVF](https://openaccess.thecvf.com/content/CVPR2025/papers/Ravishankar_Scaling_Properties_of_Diffusion_Models_For_Perceptual_Tasks_CVPR_2025_paper.pdf) | [GitHub，含权重](https://github.com/scaling-diffusion-perception/scaling-diffusion-perception) | 证明 diffusion 可用于连续稠密预测；也提示训练/推理成本必须单独核算。 |
| PhysicsGen | 2025 CVPR；image→physical relation benchmark | Medium–Strong（方法论） | [arXiv](https://arxiv.org/abs/2503.05333) | [GitHub/数据与基线](https://github.com/physicsgen/physicsgen) | 用于支撑“视觉真实不等于物理正确”的研究设计，不直接作为 backbone。 |
| DDBM | 2024 ICLR；distribution A→B | **Strong** | [OpenReview](https://openreview.net/forum?id=FKksTayvGo) | [GitHub，含 checkpoints](https://github.com/alexzhou907/DDBM) | endpoint bridge 与 Satellite→Radar 数学形式接近，是 DBIM/CDBM 的基础。 |
| CDBM | 2024 NeurIPS；bridge acceleration | Medium–Strong | [OpenReview](https://openreview.net/forum?id=FFJFGx78OK) | [统一仓库](https://github.com/thu-ml/DiffusionBridge)；CDBM 部分仍待完整发布 | 理论上降低推理成本，当前复现优先级低于 DBIM。 |
| UNSB | 2024 ICLR；unpaired I2I | Weak–Medium | [OpenReview](https://openreview.net/forum?id=uQBW7ELXfO) | [GitHub](https://github.com/cyclomon/UNSB)；有 checkpoints | SEVIR 已严格配对，主动放弃配对信息的理由不足。 |
| BBDM | 2023 CVPR；paired cross-domain I2I | **Strong** | [CVF](https://openaccess.thecvf.com/content/CVPR2023/papers/Li_BBDM_Image-to-Image_Translation_With_Brownian_Bridge_Diffusion_Models_CVPR_2023_paper.pdf) | [GitHub，含模型入口](https://github.com/xuekt98/BBDM) | Bridge 路线 landmark，直接从 source domain 向 target domain 建模。 |
| I²SB | 2023 ICML；I2I/restoration bridge | Medium–Strong | [PMLR](https://proceedings.mlr.press/v202/liu23ai.html) | [NVIDIA GitHub，含权重](https://github.com/NVlabs/I2SB) | 支持一般 Pix2Pix-style I2I；原验证仍偏 restoration。 |
| Palette | 2022 SIGGRAPH；conditional I2I diffusion | Medium / Landmark | [arXiv](https://arxiv.org/abs/2111.05826) | 未确认原作者完整训练仓库；[常用实现明确为非官方](https://github.com/Janspiry/Palette-Image-to-Image-Diffusion-Models) | 历史基线价值高，当前迁移优先级低于 bridge/DRDD/LBM。 |

### 多帧→单帧、Video 与确定性 Restoration

| 模型 | 年份·会议 / 原任务 | 等级 | 论文 | 官方实现 / 权重状态 | 迁移判断 |
|---|---|---|---|---|---|
| DGAF-VSR | 2026 CVPR；video→video SR | Medium–Strong | [CVF](https://openaccess.thecvf.com/content/CVPR2026/html/Xu_Rethinking_Diffusion_Model-Based_Video_Super-Resolution_Leveraging_Dense_Guidance_from_Aligned_CVPR_2026_paper.html) | 论文材料已公开；官方独立仓库/权重待确认 | 可借鉴历史帧对齐与 dense guidance；输出头需改为 sequence→VIL(t)。 |
| FlashVSR | 2026 CVPR；streaming VSR | Medium | [CVF](https://openaccess.thecvf.com/content/CVPR2026/html/Zhuang_FlashVSR_Towards_Real-time_Diffusion-Based_Streaming_Video_Super_Resolution_CVPR_2026_paper.html) | [GitHub](https://github.com/OpenImagingLab/FlashVSR)；[HF 权重](https://huggingface.co/JunhaoZhuang/FlashVSR) | one-step、streaming、稀疏注意力适合效率研究，但依赖大型视频生成体系。 |
| PS-SR | 2026 CVPR；video SR | Medium | [Project](https://waq2001.github.io/PS-SR-page/) | [GitHub](https://github.com/HiDream-ai/PS-SR)；权重下载说明已列 | 适合作为 diffusion 采样加速参考，任务差距仍大。 |
| STCDiT | 2026 CVPR；video SR | Medium | [CVF](https://openaccess.thecvf.com/content/CVPR2026/papers/Chen_STCDiT_Spatio-Temporally_Consistent_Diffusion_Transformer_for_High-Quality_Video_Super-Resolution_CVPR_2026_paper.pdf) | [Project/Code 入口](https://jychen9811.github.io/STCDiT_page/)；权重待验收 | anchor-frame guidance 有启发，但工程与显存成本高。 |
| QMambaBSR | 2025 CVPR；burst→single | **Strong（概念）/ Medium（复现）** | [CVF](https://openaccess.thecvf.com/content/CVPR2025/papers/Di_QMambaBSR_Burst_Image_Super-Resolution_with_Query_State_Space_Model_CVPR_2025_paper.pdf) | 未确认官方代码和权重 | 任务形态最接近 Satellite(t−n:t)→VIL(t)，但不能在无实现时列为首轮复现。 |
| MamEVSR | 2025 CVPR；image+event video SR | Medium–Strong | [CVF](https://www.openaccess.thecvf.com/content/CVPR2025/html/Xiao_Event-based_Video_Super-Resolution_via_State_Space_Models_CVPR_2025_paper.html) | 官方仓库/权重未确认 | 多模态时序结构可借鉴；event camera 与 GLM 的物理语义不同。 |
| VSRM | 2025 ICCV；video SR | Medium–Strong | [CVF](https://openaccess.thecvf.com/content/ICCV2025/papers/Tran_VSRM_A_Robust_Mamba-Based_Framework_for_Video_Super-Resolution_ICCV_2025_paper.pdf) | [GitHub](https://github.com/PhuTran1005/VSRM)；可训练，正式权重待验收 | 线性复杂度适合较长窗口；需把 video output 改为 current VIL。 |
| Burstormer | 2023 CVPR；burst/multiframe→single | **Strong** | [CVF](https://openaccess.thecvf.com/content/CVPR2023/papers/Dudhane_Burstormer_Burst_Image_Restoration_and_Enhancement_Transformer_CVPR_2023_paper.pdf) | [GitHub](https://github.com/akshaydudhane16/Burstormer)；模型入口需逐项验收 | 多帧→单图的结构与本项目长时序方向直接接近。 |
| VRT | 2022；video restoration | **Strong** | [arXiv](https://arxiv.org/abs/2201.12288) | [GitHub，训练/测试/权重](https://github.com/JingyunLiang/VRT) | 成熟时空 Transformer 参照；需要适配输入/输出模态。 |
| RVRT | 2022 NeurIPS；recurrent video restoration | **Strong** | [arXiv](https://arxiv.org/abs/2206.02146) | [GitHub，含多帧权重](https://github.com/JingyunLiang/RVRT) | recurrent 设计适合长序列和有限显存；对齐模块需适应云体生消。 |
| MambaIRv2 | 2025 CVPR；image restoration | Medium–Strong | [CVF](https://openaccess.thecvf.com/content/CVPR2025/papers/Guo_MambaIRv2_Attentive_State_Space_Restoration_CVPR_2025_paper.pdf) | [GitHub](https://github.com/csguoh/MambaIR)；模型生态 | 现代确定性空间 backbone，对照“空间建模是否已足够”。 |
| MaIR | 2025 CVPR；image restoration | Medium | [CVF](https://openaccess.thecvf.com/content/CVPR2025/papers/Li_MaIR_A_Locality-_and_Continuity-Preserving_Mamba_for_Image_Restoration_CVPR_2025_paper.pdf) | [GitHub，含 pretrained 入口](https://github.com/pseudo-sue/MaIR) | 高效空间建模，但同域 restoration 与本任务 domain gap 较大。 |
| Restormer | 2022 CVPR Oral；image restoration | Medium | [CVF](https://openaccess.thecvf.com/content/CVPR2022/papers/Zamir_Restormer_Efficient_Transformer_for_High-Resolution_Image_Restoration_CVPR_2022_paper.pdf) | [GitHub，含 releases](https://github.com/swz30/Restormer) | 成熟 deterministic baseline，易改通道；不是跨模态方法。 |
| NAFNet | 2022 ECCV；image restoration | Medium | [ECCV](https://www.ecva.net/papers/eccv_2022/papers_ECCV/papers/136670017.pdf) | [GitHub，含预训练模型](https://github.com/megvii-research/NAFNet) | 简洁卷积恢复基线，适合测复杂模块是否真的必要。 |

迁移顺序建议为：先完成 SEVIR 官方 baseline；再以 Burstormer/VRT/RVRT 检验多帧价值，以 Restormer/NAFNet 或 MambaIRv2 做确定性强对照；2026 前沿 I2I 首选 DRDD，第二个 SOTA 迁移备选为 PairFlow；随后比较 LBM、DBIM/DDBM/BBDM 等 bridge 路线。任何候选都必须通过本项目统一 Target、split、输入信息和预算才能形成结论。

## Loss 选择与控制

- L1/L2/Huber：建立定量参照，明确是在编码域还是物理域计算。
- intensity/threshold weighting：提高高 VIL 权重，但同时监控 FAR、面积膨胀与频率偏差；权重由训练集确定。
- SSIM、gradient、perceptual/content：可约束形态，不能取代数值校准；自然图像特征的 LPIPS/VGG 对气象场的适用性有限。
- adversarial + reconstruction：以 SEVIR cGAN+MAE 为参照；损失比例需验证集选取。
- diffusion objective：需记录预测 noise/x0/v 等参数化、噪声日程、采样步数和 VAE；不可把不同论文都写成相同损失。
- BCE/focal 只适用于另行定义的超阈值分类辅助头；不能直接替代连续 VIL 回归而不说明任务变化。physics-informed/frequency loss 保留为待调查，不虚构已成立的守恒关系。

## 候选优先级

首轮：复现 SEVIR 官方 synrad U-Net/cGAN 锚点并建立项目 2 km U-Net。第二轮：模态、GLM、可见光、历史窗口、标签粗化与多分辨率分支对照。前沿生成模型按 **DRDD 第一、PairFlow 第二** 的顺序迁移：DRDD 重点回答少样本数据效率，PairFlow 重点回答 Flow Matching 的结构保真和训练效率。具体实验见 [experiments.md](experiments.md)，评价见 [evaluation.md](evaluation.md)。二者是当前 SOTA 迁移备选，不是已经取得的 Satellite-to-Radar SOTA。
