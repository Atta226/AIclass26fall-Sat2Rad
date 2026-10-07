# Satellite-to-Radar 领域知识

更新：2026-09-18。本文件回答气象遥感问题；网络结构与训练路线另见 [methods.md](../research/methods.md)。

## 观测与反演

ABI 可见光反映有日照条件下的反射与云体纹理；红外亮温及空间梯度约束云顶状态；水汽通道反映一定垂直范围内的大气辐射贡献，而不是直接的地面雨强测量。GLM 反映闪电活动，对对流识别有互补信息，但无闪电不能等价为无降水。参见 [ABI](https://www.goes-r.gov/spacesegment/ABI-tech-summary.html)、[GLM](https://www.goes-r.gov/spacesegment/glm.html)。

天气雷达反射率 Z 与水凝物粒径分布及散射有关；dBZ 是 Z 的对数表示。CREF 是垂直方向最大反射率构成的二维场；VIL 根据垂直反射率分布及经验关系估计液态水积分；QPE 另需降水反演、质量控制与可能的雨量计订正。它们不是可互换标签。MRMS 是多雷达、多传感器产品系统，NEXRAD 是雷达网络；不能把 SEVIR 的 NEXRAD VIL 自动改写成 MRMS CREF。参见 [MRMS 官方说明](https://www.nssl.noaa.gov/projects/mrms/) 与 [2018 原文数据章节](https://doi.org/10.1175/JTECH-D-18-0010.1)。

## 领域发展路线

以下是本次对话所覆盖工作的组织方式，不是全领域穷尽年表，也不表示后一种方法必然取代前一种。

1. 物理/经验关系与统计映射：从卫星亮温、通道差、闪电和环境信息估计降水或雷达代理量。QPE 路线提供背景，但必须区分其 Target。
2. 2018 多源多分辨率 CNN：OPC-CNN 将 GEO 卫星、地基闪电和 RAP 融合，估计 NEXRAD VIL；提供不同分辨率分支的直接先例。
3. 2020 SEVIR：以配对事件数据支持 synthetic radar；官方 U-Net 与不同损失构成可复现基准。SEVIR 是数据集与基准体系，不是单个模型。
4. 2021 GREMLIN / FY-4A：红外+GLM 到 MRMS CREF，以及 FY-4A 到 CREF；形成与 GOES-VIL 不同的协议组。
5. Attention、损失设计、多通道与多尺度改进：FY-4A Attention U-Net、ER-UNet、DRC-Net、MCDA-UNet、EMA-U-Net-DEM。只承认各自论文协议内的证据。
6. 并行扩展：MAFormer、SRViT 提供直接 Transformer 反演工作；SEVIR cGAN、DiffSR、Hu 等 diffusion、SRDiff 探索生成式映射。EF Sat2Rad 则属于未来预测的方法参照。

全部题名、年份、证据限制和链接统一在 [literature.md](../research/literature.md)，不要凭这条路线重新推断模型架构或排行榜。

### 2021–2026 直接 Satellite-to-Radar 中的 U-Net 家族路线

在本轮收集的直接 CREF/VIL 文献内，可以把一条主要路线概括为：

```text
U-Net → Attention U-Net → 面向强回波的结构/损失改进 → 多通道独立编码 + Channel/Spatial Attention
```

- 2021 FY-4A 工作以 U-Net 从静止卫星观测估计 CREF，构成该系列的基础参照。
- 2023 卷期的 *Radar Composite Reflectivity Reconstruction Based on FY-4A Using Deep Learning* 同时比较 IR-only 与 VIS+IR，并比较 U-Net 与 Attention U-Net。论文报告 Attention U-Net 整体更好，但仍指出强回波强度存在低估，说明注意力并未消除极值恢复问题。[开放全文](https://pmc.ncbi.nlm.nih.gov/articles/PMC9824039/)
- 2024 ER-UNet 针对回波强度、位置与细节恢复继续优化，并在其自建 FY-4A/CREF 协议内优于 U-Net。[论文](https://doi.org/10.3390/rs16020275) `ER` 的正式含义是 **Echo Reconstruction**；现有证据不支持把名称扩写为 “enhanced residual”。
- MCDA-UNet（论文 DOI 登记年份 2025，期刊卷期为 2026）用 5 个卫星通道、channel-separated encoding、channel attention 与 spatial attention 重建 CREF，并按不同反射率强度评价。[论文](https://doi.org/10.1016/j.atmosres.2025.108619)
- 2026 EMA-U-Net-DEM 进一步把多尺度注意力与 DEM 引入 FY-4A CREF retrieval，说明多尺度和辅助地形仍在发展。[论文](https://doi.org/10.3390/rs18172866)

这条路线说明 CNN/U-Net 仍是强而实用的领域基线，也暴露了持续问题：强核低估、通道间差异、尺度错配和区域泛化。它不意味着后续论文在统一数据、Target、split 和指标上形成了可直接比较的年度 SOTA 排名。

### GLM 初步调研：时间窗和表示本身就是研究变量

GLM 不应被处理成一个没有时间定义的普通图像通道。SEVIR 官方 synrad 将目标时刻之前 5 min 的 flashes 栅格化为 48×48，再与 IR 一起映射到 VIL；GREMLIN CONUS3 则将 ABI、GLM 和 MRMS 配到共同 3 km 网格，卫星—雷达最大时间差约 2.5 min，GLM groups 累积约 15 min，并做基于假设云高的视差订正。两种公开实践已经说明 5 min 不是唯一合理选择。细节与来源见 [datasets.md](../research/datasets.md)。

GLM 的作用已有文献证据。直接反射率工作 GREMLIN 通过 channel-withholding、空间信息屏蔽和 LRP 表明，网络的高反射率技巧同时依赖辐射梯度和闪电；GLM 对定位强回波尤其有价值。[Hilburn et al., 2021](https://doi.org/10.1175/JAMC-D-20-0084.1) 邻近的 ABI+GLM QPE 工作在相同网络与训练设置下比较 w/GLM 和 w/o GLM，报告闪电资料对降水反演、尤其重降水有帮助。[Yang et al., 2023](https://doi.org/10.1109/TGRS.2023.3322352) SEVIR 把 5 min flashes 纳入官方 VIL baseline，则提供了与本项目 Target 最接近的实践依据。证据支持“闪电具有增量信息”，但不能直接决定本项目最优时间窗、表示或收益幅度。

本项目把下列两组变量列为未来实验，而不是预处理常量：

1. 截止于目标时刻 `t` 的 1/5/10/15/30 min 聚合窗；
2. event count、group count、flash count、density 与 energy 等表示。

这些表示依赖原始资料是否保留相应 GLM 字段。SEVIR `lght` 主要提供 flash 位置/时间，不能假设它天然包含 event、group 和 energy；若需完整表示，应从原始 GLM 产品另建配对资料。研究时必须同时报告高 VIL 的 POD/CSI/FAR、频率偏差和无闪电降水表现，避免把更多闪电简单等同于更准确的 VIL。

### 可见光是独立研究问题，不只是再加一个通道

可见光与红外提供不同观测约束：红外主要描述云顶辐射温度，可见光在有日照时提供云体反射率、边界、纹理和细尺度结构。FY-4A Attention U-Net 论文直接比较 IR-only 与 VIS+IR，并报告加入 VIS/NIR 后整体表现改善，构成可见光对 CREF reconstruction 有用的直接依据；同时，强回波仍有低估，说明可见光不是强核问题的充分解。[Yang et al., 2023](https://doi.org/10.3390/s23010081)

本项目应把两个问题分开：第一，在共同白天子集上，C02 是否相对 IR+GLM 提供独立增益；第二，怎样把只在白天有效的 C02 纳入全天模型。第一问用严格配对的 V01 消融回答，第二问比较昼夜分支、availability mask 和 modality dropout。由于 C02 的空间分辨率高于 IR，它还与原生多分辨率假设相交，但不能把“加入 C02”和“改变融合架构”的联合收益全部归因于可见光。

## 当前科学问题

| 问题 | 机制与风险 | 已有尝试及当前项目需要回答的内容 |
|---|---|---|
| 非唯一性与可观测性 | 相近云顶外观可能对应不同云内水凝物；标签本身也有误差 | GREMLIN 利用空间上下文/闪电；验证历史演变能否进一步约束 VIL |
| 强值长尾 | 大量弱值可主导全场统计；MSE 对单个大误差敏感但不保证强核恢复 | 比较加权损失、分层采样与生成模型，联合检查漏报和虚警 |
| 分辨率不一致 | VIS 降采样损失纹理；GLM 上采样不增加有效观测信息；VIL 粗化改变极值 | 对照统一网格与多分支，先测标签重采样带来的变化 |
| 空间/时间错位 | 卫星视差、导航、扫描时段和雷达时间匹配可能引入位移 | 记录投影、像元中心、时间容差；并用邻域/对象指标检查 |
| 昼夜与缺失 | C02 夜间没有可用的太阳反射信息；零值不等同普通观测 | IR 基础模型、昼夜分支或模态掩码；不能因填零而声称解决缺测 |
| 泛化 | 事件抽样、地区/季节/天气型改变输入与标签分布 | 时间隔离，按地区/季节/昼夜分层；CONUS3 CREF 可作另一任务验证，非直接 VIL 外测 |
| 空间与时间一致性 | 锐利结构可能是虚构；逐帧合理输出也可能闪烁 | 强核匹配、FSS、连续案例；生成集合还需校准评价 |

## 稳定认识与证据边界

SEVIR synrad 的 Table 2 显示，cGAN+MAE 的感知相似性优势并不对应所有数值指标和高阈值 CSI 的优势。因此视觉锐利度不能替代气象有效性。Hu 等的 diffusion 研究也报告结构与分布改进不必伴随全部像素指标改进。这些是特定协议下的观察，不能扩展成“GAN 总差”或“Diffusion 总好”。[SEVIR 原文](https://proceedings.neurips.cc/paper/2020/file/fa78a16157fed00d7a80515818432169-Paper.pdf)、[Hu 等](https://doi.org/10.1175/AIES-D-25-0016.1)。

前期对话认为 lead=0 的单帧/多帧公平比较、C02 缺失处理、GLM 表示和 VIL 粗化值得研究；这属于当前问题清单，不是已经证明“从未有人研究”的首创性结论。正式选题还需针对这些问题补检索。
