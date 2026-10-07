# 已调研论文、代码与可复现资源

核验日期：2026-09-18。范围覆盖[前期对话](https://chatgpt.com/share/6aaba84f-c8ec-83ee-9248-075cd80b7fa6)实际讨论的直接工作；可迁移 AI/CV 候选集中收录在 [methods.md](methods.md)，避免与直接领域论文混成排行榜。

## 阅读规则与证据等级

- **Primary**：卫星到同时刻雷达/雷达衍生场；仍需按 VIL/CREF 等分组。
- **Dataset**：数据集与基准论文，例如 SEVIR；其中 synrad 实验属于 Primary。
- **Related**：QPE 或未来雷达预测，不能和当前 VIL 分数直接比较。
- **Method**：一般方法迁移；本文件不另外扩展通用 CV 论文列表，模型类别见 [methods.md](methods.md)。

论文存在、正文可读、代码公开、权重可获取、实验可复现是五个不同状态。`Public code: Not found` 表示本轮未找到可确认的公开实现，不表示证明其不存在。DOI/出版信息已通过官方页面或 Crossref 登记核对；部分出版社正文请求受访问限制，表中明确保留未核验细节，不凭摘要填齐完整协议。

## Representative Papers

下表用简称导航到后面的完整书目。Lead Time=0 表示当前场估计，不表示没有产品延迟；“待分实验”不纳入直接排名。

| Paper | Year | Category | Task | Input | Target | Lead Time | Model | Dataset | Code | Role |
|---|---:|---|---|---|---|---|---|---|---|---|
| [P01 Synthetic Radar CNN](https://doi.org/10.1175/JTECH-D-18-0010.1) | 2018 | Primary | synthetic radar | GEO VIS/IR、地基闪电、RAP | NEXRAD VIL | 0 | 多分辨率 DAG CNN | 自建美国/近海资料 | Not found | Landmark；多源分支先例 |
| [P02 SEVIR](https://proceedings.neurips.cc/paper_files/paper/2020/hash/fa78a16157fed00d7a80515818432169-Abstract.html) | 2020 | Dataset | synrad；另有 nowcasting | synrad: IR069+IR107+GLM | VIL | synrad=0 | U-Net、不同损失/cGAN | SEVIR | [官方](https://github.com/MIT-AI-Accelerator/neurips-2020-sevir) | Dataset benchmark；最接近项目 |
| [P03 GREMLIN](https://doi.org/10.1175/JAMC-D-20-0084.1) | 2021 | Primary | reflectivity estimation | ABI C07/C09/C13、GLM | MRMS CREF | 0 | CNN encoder–decoder | GOES/MRMS 研究配对集 | 完整训练实现未确认 | IR+闪电直接领域依据 |
| [P04 FY-4A U-Net](https://doi.org/10.3390/rs13112229) | 2021 | Primary | CREF estimation | FY-4A AGRI | CREF | 0（当前场；精确匹配待复核） | U-Net | 自建 FY-4A/radar | Not found | FY-4A 路线 |
| [P05 FY-4A Attention U-Net](https://doi.org/10.3390/s23010081) | 2023 | Primary | CREF reconstruction | FY-4A、地形；IR/VIS 配置 | CREF | 0 | Attention U-Net | 自建配对集 | Not found | 昼夜配置与注意力参考 |
| [P06 ABI+GLM QPE](https://doi.org/10.1109/TGRS.2023.3322352) | 2023 | Related | precipitation retrieval | ABI、GLM | 降水估计，非 VIL | 当前估计；累积/匹配窗待复核 | CNN | GOES/MRMS | Not found | Related QPE；闪电融合 |
| [P07 MAFormer](https://doi.org/10.3390/atmos14121723) | 2023 | Primary | reflectivity reconstruction | 卫星资料；通道清单待全文复核 | reflectivity | 当前场；精确时差待核 | local/global attention Transformer | 论文自建集，细节待核 | Not found | 直接 Transformer 候选 |
| [P08 ER-UNet](https://doi.org/10.3390/rs16020275) | 2024 | Primary | CREF reconstruction | FY-4A | CREF | 0（匹配细节待核） | Echo Reconstruction UNet | 研究自建集 | 未找到可确认地址 | 强 CNN/损失设计候选 |
| [P09 EF Sat2Rad](https://doi.org/10.1175/AIES-D-23-0041.1) | 2024 | Related | future radar | 卫星历史序列 | 未来雷达场 | >0，最长约 2 h | Earthformer 类 Transformer | SEVIR 实验体系 | [官方](https://github.com/caglarkucuk/earthformer-satellite-to-radar) | Temporal method reference |
| [P10 SRViT](https://arxiv.org/abs/2406.16955) | 2024 | Primary | reflectivity estimation | GOES ABI/GLM 配对资料 | CREF，3 km | 0 | ViT | GREMLIN CONUS3 | [官方](https://github.com/stockeh/srvit) | 开源 Transformer 候选 |
| [P11 DRC-Net](https://doi.org/10.1109/TGRS.2025.3526220) | 2025 | Primary | reflectivity emulation | GEO satellite；通道待全文复核 | reflectivity | 当前场；详细匹配待核 | Dynamic Residual Convolutional Network | 研究自建集，待核 | Not found | 动态卷积候选 |
| [P12 DiffSR](https://arxiv.org/abs/2411.06714) | 2025 | Primary | reflectivity synthesis | ABI/闪电与第一阶段估计 | MRMS CREF | 0 | ViT 初估+条件 diffusion | CONUS 配对资料 | Not found | 两阶段生成候选；预印本 2024 |
| [P13 Hu et al. diffusion](https://doi.org/10.1175/AIES-D-25-0016.1) | 2026 | Primary | synthetic radar | Himawari IR、地基闪电 | 1 km 高度反射率切片 | 0 | 条件 diffusion / U-Net | 澳大利亚配对资料 | 项目 Code 入口未成功访问 | 结构与分布评价参考 |
| [P14 MCDA-UNet](https://doi.org/10.1016/j.atmosres.2025.108619) | 2026 | Primary | CREF retrieval | 5 个卫星通道；清单待全文复核 | CREF | 当前场；详细匹配待核 | 多通道、双注意力 U-Net | 南京 S 波段雷达配对集 | Not found | 近期多通道候选 |
| [P15 EMA-U-Net-DEM](https://doi.org/10.3390/rs18172866) | 2026 | Primary | CREF retrieval | FY-4A AGRI、DEM | CREF | 0，snapshot | 多尺度注意力 U-Net | 四川 2023 年暖季 | Not found | 地形辅助参考 |
| [P16 SRDiff](https://doi.org/10.1109/TGRS.2026.3686188) | 2026 | Primary 候选/待分实验 | satellite-to-radar translation；下游 nowcasting | 卫星序列；公开版 IR069/IR107/GLM | SEVIR VIL / 其他实验标签待核 | 必须逐实验核对 | cross-modal adapter、DiT | SEVIR、Sat2Rdr | [官方](https://github.com/42xingxing/SRDiff) | 序列生成候选；公开版不完整 |

## 核心书目与入口

### P01 — 2018 Synthetic Radar CNN

**Creating Synthetic Radar Imagery Using Convolutional Neural Networks**. Mark S. Veillette, Eric P. Hassey, Christopher J. Mattioli, Haig Iskenderian, Patrick M. Lamey. *Journal of Atmospheric and Oceanic Technology*, 35(12), 2323–2338, 2018.

- [DOI](https://doi.org/10.1175/JTECH-D-18-0010.1) · [Publisher / 正文](https://journals.ametsoc.org/view/journals/atot/35/12/jtech-d-18-0010.1.xml)
- 核验：原文目标明确为 VIL；输入是当时的 GEO VIS/IR、Earth Networks 地基闪电和 RAP，不能改写成 SEVIR C02/C09/C13/GLM。CNN 分支融合不同尺度，原文与早期 RF 比较。
- Dataset：NEXRAD、RAP 等研究资料；完整配对训练集入口未找到。Public code: Not found；预训练权重未确认。

### P02 — SEVIR

**SEVIR: A Storm Event Imagery Dataset for Deep Learning Applications in Radar and Satellite Meteorology**. Mark Veillette, Siddharth Samsi, Chris Mattioli. *NeurIPS 2020*, Advances in Neural Information Processing Systems 33.

- [官方论文页](https://proceedings.neurips.cc/paper_files/paper/2020/hash/fa78a16157fed00d7a80515818432169-Abstract.html) · [Paper PDF](https://proceedings.neurips.cc/paper/2020/file/fa78a16157fed00d7a80515818432169-Paper.pdf)
- [GitHub：论文基线](https://github.com/MIT-AI-Accelerator/neurips-2020-sevir) · [GitHub：数据工具](https://github.com/MIT-AI-Accelerator/eie-sevir) · [Dataset](https://registry.opendata.aws/sevir/)
- 无需猜 DOI，会议正式页已足够。核验 synrad §3.4 和 Table 2：IR069/IR107/过去 5 min flashes 到 VIL；MSE、MSE+content、cGAN+MAE 三种损失。1 km 原协议与项目 2 km 扩展分开。
- 权重清单和下载脚本确实存在，但本轮仅验证到 Dropbox 网页响应，未验证二进制下载与加载。后续不能复用前期对话第一轮的“High / 权重肯定可获得”判断。

### P03 — GREMLIN

**Development and Interpretation of a Neural-Network-Based Synthetic Radar Reflectivity Estimator Using GOES-R Satellite Observations**. Kyle A. Hilburn, Imme Ebert-Uphoff, Steven D. Miller. *Journal of Applied Meteorology and Climatology*, 60(1), 2021.

- [DOI](https://doi.org/10.1175/JAMC-D-20-0084.1) · [Publisher](https://journals.ametsoc.org/view/journals/apme/60/1/jamc-d-20-0084.1.xml) · [arXiv，2020 预印本](https://arxiv.org/abs/2004.07906)
- [Project](https://overcast.cira.colostate.edu/overcast-syntheticradar) · [原训练资料 CONUS1](https://datadryad.org/dataset/doi%3A10.5061/dryad.m905qfv60) · [后续 CONUS3](https://doi.org/10.5061/dryad.h9w0vt4nq)
- C07/C09/C13 与 GLM 到 MRMS CREF；不是 VIL，也不是未来 NWP 输出。用途包括 NWP 初始化，不因此变成未来预测模型。
- 论文使用 channel-withholding、空间信息屏蔽和 LRP 分析，表明网络利用辐射梯度与闪电获得高反射率技巧；GLM 对强回波位置尤其有辨识价值。这是 H3 的直接 Satellite→Radar 文献支撑，但不等于在 SEVIR VIL 上已经完成消融。
- 空间上下文、红外与闪电贡献值得参考；公开数据读取工具、后续 SRViT 实现不自动等于原 GREMLIN 训练发布。Public code: Not found（原模型完整官方训练实现）；原权重未确认。

### P04 — FY-4A U-Net

**Deep Learning-Based Radar Composite Reflectivity Factor Estimations from Fengyun-4A Geostationary Satellite Observations**. Fenglin Sun, Bo Li, Min Min, Danyu Qin. *Remote Sensing*, 13(11), 2229, 2021.

- [DOI](https://doi.org/10.3390/rs13112229) · [Publisher](https://www.mdpi.com/2072-4292/13/11/2229)
- 书目已核验；本轮出版社正文直接访问受限。保留对话中的 FY-4A/CREF/U-Net 定位，具体通道、重采样、划分和指标数字待全文复核。Public code: Not found；权重与完整加工集未确认。

### P05 — FY-4A Attention U-Net

**Radar Composite Reflectivity Reconstruction Based on FY-4A Using Deep Learning**. Ling Yang, Qian Zhao, Yunheng Xue, Fenglin Sun, Jun Li, Xiaoqiong Zhen, Tujin Lu. *Sensors*, 23(1), 81, **2023 卷期；2022-12-22 在线发表**。

- [DOI](https://doi.org/10.3390/s23010081) · [Publisher](https://www.mdpi.com/1424-8220/23/1/81) · [开放全文](https://pmc.ncbi.nlm.nih.gov/articles/PMC9824039/)
- FY-4A 与地形到 CREF，Attention U-Net 对照 U-Net；保留日间 VIS+IR 与 IR 配置的研究线索。Public code: Not found；权重和完整加工数据入口未确认。
- 论文结论还指出模型整体能恢复回波形状与位置，但强回波强度仍有低估；因此它是“注意力改善但未解决强核”的直接例子。
- 论文在 IR-only 和 VIS+IR 配置间进行比较，并报告加入 VIS/NIR 后性能改善；这是 H2“白天可见光具有增量信息”的直接 CREF 文献支撑。项目复现必须限定共同白天样本，不能把样本时段差异误归因于 VIS。

### P06 — ABI+GLM QPE（邻近任务）

**Deep Learning for Precipitation Retrievals Using ABI and GLM Measurements on the GOES-R Series**. Yifan Yang, Haonan Chen, Kyle A. Hilburn, Robert J. Kuligowski, Robert Cifelli. *IEEE TGRS*, 61, 5302414, 2023.

- [DOI](https://doi.org/10.1109/TGRS.2023.3322352) · [NOAA 论文库/全文入口](https://repository.library.noaa.gov/view/noaa/61892)
- 以降水估计为目标，研究 ABI/GLM 融合，并与 GOES RRQPE 比较。可借鉴输入消融，不与 VIL/reflectivity 排分数。Public code: Not found；权重与可复现加工集未确认。
- 论文还在保持网络结构、损失、优化器和超参数一致的条件下训练 `CNN w/ GLM` 与 `CNN w/o GLM`，用于量化 GLM 贡献；结果支持闪电资料对降水反演、尤其重降水的作用。这是受控消融证据，但 Target 为 QPE，不能把其数值收益直接移植到 VIL。

### P07 — MAFormer

**MAFormer: A New Method for Radar Reflectivity Reconstructing Using Satellite Data**. Kuoyin Wang, Yan Huang, Tingzhao Yu, Yu Chen, Zhimin Li, Qiuming Kuang. *Atmosphere*, 14(12), 1723, 2023.

- [DOI](https://doi.org/10.3390/atmos14121723) · [Publisher](https://www.mdpi.com/2073-4433/14/12/1723)
- Axial Local Attention / Mixup Global Attention 的直接雷达重建工作。不是同名通用视觉 MAFormer。具体传感器通道、标签定义与划分未完成全文级复核，不能用同名 CV 仓库替代。Public code: Not found；权重与数据入口未确认。

### P08 — ER-UNet

**Intelligent Reconstruction of Radar Composite Reflectivity Based on Satellite Observations and Deep Learning**. Jianyu Zhao, Jinkai Tan, Sheng Chen, Qiqiao Huang, Liang Gao, Yanping Li, Chunxia Wei. *Remote Sensing*, 16(2), 275, 2024.

- [DOI](https://doi.org/10.3390/rs16020275) · [Publisher](https://www.mdpi.com/2072-4292/16/2/275)
- **ER = Echo Reconstruction**，前期文本的“enhanced residual”不应作为正式扩写。论文报告其在自建协议内对强回波的强度、位置和细节优于 U-Net；在没有架构证据前，不将该增益归因于 residual/multiscale。
- 对话前一轮称“官方代码有”，后一轮降为未确认；本轮未找到可靠仓库地址。Public code: Not found；权重与完整加工集未确认。它仍可作为待精读的直接领域论文。

### P09 — EF Sat2Rad（未来预测）

**Transformer-Based Nowcasting of Radar Composites from Satellite Images for Severe Weather**. Çağlar Küçük, Apostolos Giannakos, Stefan Schneider, Alexander Jann. *Artificial Intelligence for the Earth Systems*, 3(2), 2024.

- [DOI](https://doi.org/10.1175/AIES-D-23-0041.1) · [arXiv](https://arxiv.org/abs/2310.19515) · [Publisher](https://journals.ametsoc.org/view/journals/aies/3/2/AIES-D-23-0041.1.xml)
- [GitHub](https://github.com/caglarkucuk/earthformer-satellite-to-radar) · [Zenodo：权重与样例](https://zenodo.org/records/10033641)
- 最长约 2 h future radar，属于时序方法迁移。Zenodo 列有 `ef_sevir_sat2rad.zip` 与 `data.zip`；已确认入口与文件清单，未下载运行。不能拿其权重直接声称完成 lead=0 VIL 模型。

### P10 — SRViT

**SRViT: Vision Transformers for Estimating Radar Reflectivity from Satellite Observations at Scale**. Jason Stock, Kyle Hilburn, Imme Ebert-Uphoff, Charles Anderson. *ICML 2024 Workshop on Machine Learning for Earth System Modeling*，不是 ICML 主会论文。

- [arXiv](https://arxiv.org/abs/2406.16955) · [arXiv DOI](https://doi.org/10.48550/arXiv.2406.16955) · [GitHub / 权重目录入口](https://github.com/stockeh/srvit)
- 3 km CREF 估计；仓库列有 dataprep、训练/评价脚本与 weights 目录，数据链接指向 CONUS3 2020–2022。尚未验证 checkpoint 下载、完整性与加载；不能只凭目录把复现评级写为已完成。
- VIL 迁移需修改 Target、通道和尺度并重新验证；不能直接和 SEVIR synrad 数字排名。

### P11 — DRC-Net

**Enhancing Weather Radar Reflectivity Emulation From Geostationary Satellite Data Using Dynamic Residual Convolutional Network**. Jianwei Si, Haonan Chen, Lei Han. *IEEE TGRS*, 2025.

- [DOI](https://doi.org/10.1109/TGRS.2025.3526220) · [Publisher](https://ieeexplore.ieee.org/document/10829640/)
- 元数据、正式题名和 dynamic residual CNN 身份已核；具体输入通道、数据划分、损失与可复现配置尚未核验。Public code: Not found；权重和加工集未确认。

### P12 — DiffSR

**DiffSR: Learning Radar Reflectivity Synthesis via Diffusion Model from Satellite Observations**. Xuming He, Zhiwang Zhou, Wenlong Zhang, Xiangyu Zhao, Hao Chen, Shiqi Chen, Lei Bai. 2024-11 预印本；作者页面确认 ICASSP 2025 接收。

- [arXiv](https://arxiv.org/abs/2411.06714) · [全文](https://arxiv.org/html/2411.06714v1) · [作者发表信息](https://wenlongzhang0517.github.io/blog/2024-icassp-diffsr/)
- 先利用 ViT 做全图粗估计，再将粗估计与卫星/闪电用于条件 diffusion。这里的 global-scale/context 不应直接解释为“全球地区数据预训练”。
- 原文 Table I 的不同指标不全部同向，不能将作者 SOTA 表述移植为本项目结论。会议 DOI 本轮未确认，不猜写；Public code: Not found；权重未确认。数据为 CONUS ABI/MRMS 体系，完整版本/划分需进一步复核。

### P13 — Hu et al. diffusion

**Enhancing Production of Synthetic Radar Images from Geostationary Satellite Observations through Generative Diffusion Models**. Yuguang Hu, Daochang Liu, Alain Protat, Valentin Louf, Jordan Brook, Chang Xu. *Artificial Intelligence for the Earth Systems*, 5(1), e250016, 2026；2025-12-19 提前在线。

- [DOI](https://doi.org/10.1175/AIES-D-25-0016.1) · [Publisher](https://journals.ametsoc.org/view/journals/aies/5/1/AIES-D-25-0016.1.xml) · [作者项目](https://yuguanghu.com/SHRIMP-Page/) · [机构书目](https://research-repository.uwa.edu.au/en/publications/enhancing-production-of-synthetic-radar-images-from-geostationary/)
- Himawari IR 与地基闪电条件下生成雷达反射率；目标为 1 km 高度水平切片、2 km 网格，不是 VIL，也不应不加区分地写为 CREF。
- 项目页含 Code 按钮，但本轮访问未成功，未取得可确认的有效 GitHub 仓库地址；不猜测 URL。公开代码可用性、权重、加工数据待确认。

### P14 — MCDA-UNet

**MCDA-UNet: A satellite data-based model for radar composite reflectivity retrieval**. Qiangyu Zeng, Ling Li, Hao Wang, Jianxin He, Hua Wang, Yao Gao. *Atmospheric Research*, 330, 108619, 2026。

- [DOI](https://doi.org/10.1016/j.atmosres.2025.108619) · [Publisher](https://www.sciencedirect.com/science/article/pii/S0169809525007112)
- 5 通道、多通道特征提取及双注意力，南京 S 波段雷达配对。DOI 中 2025 不是卷期年；全部通道与实验细节待正文级复核。Public code: Not found；权重和加工集未确认。

### P15 — EMA-U-Net-DEM

**Retrieval of Warm-Season Radar Composite Reflectivity in Sichuan by Integrating FY-4A Multi-Channel Satellite Data and DEM Topographic Information**. Wen Kang, Hao Wang, Qiangyu Zeng, Tiantian Yu, Jiafeng Zheng, Zhi Li, Jinzhi Liao. *Remote Sensing*, 18(17), 2866, 2026-08-24。

- [DOI](https://doi.org/10.3390/rs18172866) · [Publisher](https://www.mdpi.com/2072-4292/18/17/2866)
- snapshot FY-4A+DEM→CREF；四川 2023 年 6–8 月。多尺度注意力与地形辅助具有领域参考价值，但单区域暖季结果不能证明跨年、跨区或 SEVIR-VIL 优势。Public code: Not found；权重、完整加工集未确认。

### P16 — SRDiff

**SRDiff: A Cross-Modal Diffusion Model for Satellite-to-Radar Translation in Precipitation Nowcasting**. You Qin, Jinming Cao, Ting Wang, Yifang Yin, Li Li, Shili Xiang, Ying Zhang, Roger Zimmermann. *IEEE TGRS*, 2026。

- [DOI](https://doi.org/10.1109/TGRS.2026.3686188) · [Publisher](https://ieeexplore.ieee.org/document/11489266/) · [GitHub](https://github.com/42xingxing/SRDiff)
- 论文元数据和官方仓库身份已确认；完整正文与各子实验的输入/输出时间对齐尚未完成核验。不能仅因标题含 nowcasting 就全排除，也不能仅因使用 SEVIR 就全部归入 lead=0。
- README 明确仅发布 full-SEVIR 的 cmca/base，排除部分消融、跨区实验与其他基线；需兼容 VAE checkpoint，数据、VAE 和训练后 SRDiff 权重不随仓库提供。Sat2Rdr 独立数据入口未确认。

## 代码与可复现资源表

“可用”只表示入口证据；本轮未安装依赖、训练或执行任何外部模型。

| Model / Paper | Code | Pretrained Weights | Dataset | Reproducibility | Potential Role |
|---|---|---|---|---|---|
| SEVIR U-Net / cGAN | [官方训练/测试仓库](https://github.com/MIT-AI-Accelerator/neurips-2020-sevir) | [下载脚本](https://github.com/MIT-AI-Accelerator/neurips-2020-sevir/blob/master/models/download_models.py)、[URL 清单](https://github.com/MIT-AI-Accelerator/neurips-2020-sevir/blob/master/models/model_urls.csv)；实际文件未验证 | [AWS](https://registry.opendata.aws/sevir/) | 代码/数据/权重机制可查；旧依赖与下载仍需运行验证 | 首个复现锚点 |
| SEVIR 数据工具 | [eie-sevir](https://github.com/MIT-AI-Accelerator/eie-sevir) | 不适用 | SEVIR | 数据工具，不是完整训练复现声明 | 数据检查 |
| SRViT | [官方仓库](https://github.com/stockeh/srvit) | 仓库 weights 目录；文件获取/加载未验证 | [CONUS3](https://doi.org/10.5061/dryad.h9w0vt4nq) | 公开内容较完整；未运行 | Transformer 适配候选 |
| EF Sat2Rad | [官方仓库](https://github.com/caglarkucuk/earthformer-satellite-to-radar) | [Zenodo](https://zenodo.org/records/10033641)，有文件名与大小 | SEVIR；Zenodo 样例 | 权重和样例入口可核验；未来任务 | 时序架构参考 |
| SRDiff | [官方仓库](https://github.com/42xingxing/SRDiff) | 未随仓库发布；VAE 是额外前置依赖 | SEVIR；Sat2Rdr 待核 | 部分代码公开，不具备开箱完整复现证据 | 高级生成候选 |
| GREMLIN | 原模型完整训练代码 Not found | 未确认 | [CONUS1](https://doi.org/10.5061/dryad.m905qfv60)、[CONUS3](https://doi.org/10.5061/dryad.h9w0vt4nq) | 数据读取示例≠训练实现 | 融合与可解释性参考 |
| Hu diffusion | [项目 Code 入口](https://yuguanghu.com/SHRIMP-Page/)本轮未成功访问 | 未确认 | 加工集入口未确认 | 未确认 | 概率与结构评价参考 |
| P01/P04/P05/P06/P07/P08/P11/P12/P14/P15 | Public code: Not found | 未确认 | 见各论文，完整加工集/划分多未确认 | 论文线索，不承诺可复现 | 按科研问题精读后选取 |

SEVIR 清单中的三个 synrad 文件名为 `mse_weights.h5`、`mse_vgg_weights.h5`、`gan_mae_weights.h5`。本轮 HEAD 检查得到 HTTP 200、`text/html`，只能证明分享页返回，不能证明得到 HDF5。后续检查真实文件类型、大小、哈希和模型加载后再更新状态。

## Comparable Groups

| Group | 任务/Target | 包括 | 比较边界 |
|---|---|---|---|
| G1 | 同时刻 SEVIR VIL | SEVIR synrad；本项目适配基线 | 1 km 与 2 km、模态、划分不同仍需分组 |
| G2 | GOES→MRMS CREF | GREMLIN、SRViT、DiffSR | 不等于同一数据版本/训练划分；不能自动互比 |
| G3 | 中国区域→CREF | FY-4A 系列、MCDA 等 | 不同区域、传感器、雷达、标签方案须复核 |
| G4 | Himawari→高度切片反射率 | Hu diffusion | 目标高度与切片定义必须保留 |
| G5 | 卫星历史→未来雷达 | EF Sat2Rad | lead>0，不与 G1 比 |
| G6 | 卫星→降水估计 | ABI+GLM QPE | 不同物理 Target |
| 待定 | SRDiff 各子实验 | translation / downstream nowcasting | 全文与 loader 时间索引确认后再归组 |

## Corrections / To Investigate

1. 2018 的目标补明确为 VIL；GLM 与其地基闪电输入不可混同。GREMLIN 则是 CREF。
2. SEVIR 是数据、论文与多任务基准三种相关对象；其官方 synrad 未包含 C02，目标不是本项目计划的 2 km。
3. ER-UNet 名称、残差架构推断和“官方代码已找到”的旧说法已纠正；仍需精读正文和代码发布声明。
4. DiffSR 2024 预印本/2025 会议、Hu 2025 online/2026 卷期、Attention U-Net 2022 online/2023 卷期分别记录，避免年份混用。
5. SRViT 是 ICML workshop；MAFormer 必须按完整题名识别；SRDiff 与其他同名超分辨率项目无关。
6. Sat2Rdr 数据身份、SRDiff 子实验 lead time、VAE 与 checkpoint 获取、Hu 代码入口、SEVIR 权重二进制可用性优先补核。
7. 部分 MDPI/IEEE/Elsevier 正文受访问限制；DOI 元数据真实不代表全部实验字段已核验。待核字段已留空说明，不新增虚构 GitHub 或未经确认性能数字。
8. 本轮没有证明“最新全领域 SOTA”，也没有证明本项目研究问题的绝对首创性。下一轮按问题搜索：`synthetic radar`、`satellite radar reflectivity retrieval`、`sequence-to-current VIL`、`GLM aggregation`、`VIL coarse-graining`、`probabilistic satellite-to-radar`。
