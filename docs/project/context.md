# 研究背景与任务定义

更新：2026-09-17。本文是项目任务定义入口；研究状态见 [current_state.md](current_state.md)，证据与资源见 [文献表](../research/literature.md)。

## Scientific Problem

利用静止气象卫星的云顶辐射、水汽、云体形态及闪电信息，在地面天气雷达覆盖不足、遮挡或资料不可获得的条件下，估计降水系统的雷达代理场。关注系统位置、形态、强度分布和局地高 VIL 核心。

卫星覆盖广、观测连续，但辐射观测不能直接看清云内全部水凝物；天气雷达通过主动探测约束降水粒子的空间结构，但受覆盖、波束高度、地形和质量控制限制。两者互补，同时存在观测机制差异与映射非唯一性。因此本课题既是遥感反演，也是监督式跨模态空间回归。领域依据包括 [2018 synthetic radar CNN](https://doi.org/10.1175/JTECH-D-18-0010.1)、[SEVIR](https://proceedings.neurips.cc/paper_files/paper/2020/hash/fa78a16157fed00d7a80515818432169-Abstract.html) 和 [GREMLIN](https://arxiv.org/abs/2004.07906)。

## 当前项目 AI Task

**基于多模态气象卫星观测的同时刻雷达 VIL 场反演**。

| 项目 | 当前定义 | 状态 |
|---|---|---|
| Dataset | SEVIR 的 GOES-16 / NEXRAD 配对事件 | 已明确研究对象；本地尚无数据 |
| Input 候选全集 | C02、C09、C13、GLM | 已明确可研究模态；最终组合待消融 |
| Target | 与输入截止时刻相同的 NEXRAD-derived VIL 二维场 | 已明确，不自动改成 CREF 或雨强 |
| Lead Time | **0 min** | 已明确 |
| 空间方案 | 约 2 km，192 × 192，覆盖约 384 × 384 km | 当前计划；重采样算法待实验 |
| 时间步长 | 5 min | SEVIR 实验时间采样 |
| 单帧任务 | Satellite(t) → VIL(t) | 基础实验 |
| 多帧任务 | Satellite(t−kΔt:t) → VIL(t)，Δt=5 min | 重要对照，窗口未定 |
| 输出类型 | 确定性连续场为基础；条件分布/集合为研究候选 | 尚未选定最终模型 |

单帧属于 multimodal image-to-image regression / translation；历史序列属于 sequence-to-image current-time retrieval。使用历史不改变 Target 时间。Satellite(t−k:t) → Radar(t+Δt)、Δt>0 才是未来预测。

## Input / Target 的尺度

| 变量 | 仪器或来源 | 原生/资料空间尺度 | SEVIR 尺寸 | 进入当前方案的处理 |
|---|---|---|---|---|
| C02 / vis | GOES-16 ABI，可见光 | 星下点标称 0.5 km | 768 × 768 | 配准后降至 192 × 192；原生分支为候选 |
| C09 / ir069 | ABI，中层水汽红外 | 标称 2 km | 192 × 192 | 同一投影和范围核验后使用 |
| C13 / ir107 | ABI，长波红外亮温 | 标称 2 km | 192 × 192 | 同上；ir107 是数据键，不代表 C13 中心波长为 10.7 μm |
| GLM / lght | 连续闪电观测 | 约 8 km 星下点、14 km 视场边缘 | 点事件；基线栅格化为 48 × 48 | 先定义过去时间窗与计数对象，再栅格化、对齐至模型网格 |
| VIL / vil | NEXRAD 雷达衍生产品 | SEVIR 网格 1 km | 384 × 384 | 计划降至 192 × 192；保留原始标签供敏感性分析 |

ABI 的 C02/C09/C13 标称中心波长分别约为 0.64/6.9/10.3 μm。CONUS ABI 扫描为 5 min；全圆盘和中尺度扫描频率不同。GLM 仪器 2 ms 帧率不能当作训练样本间隔；项目使用聚合后的闪电场。来源：[ABI 波段](https://www.goes-r.gov/spacesegment/ABI-tech-summary.html)、[扫描模式](https://www.goes-r.gov/spacesegment/abi.html)、[GLM](https://www.goes-r.gov/spacesegment/glm.html)。详细数据定义见 [datasets.md](../research/datasets.md)。

## 研究边界

- VIL 是由反射率推导的垂直积分液态水估计，物理量通常为 kg/m²；SEVIR 存储编码不可直接当作物理单位。它不是地面降水率 mm/h，也不是累积降水 mm。
- Synthetic Radar 指生成雷达代理场，不是合成孔径雷达 SAR。
- Satellite QPE 以降水率/降水量为目标，属于邻近任务。Image-to-Image Translation 是方法层的表述，不能取代物理 Target 定义。
- 推理输入不包含雷达真值或未来卫星观测。雷达仅作监督和离线评价；NWP、DEM 尚未纳入项目基础输入。
- 高 VIL 与强对流/降水结构有关，但不能未经验证把某个 VIL 编码阈值命名为暴雨、冰雹或严重对流等级。

## 研究策略与选择理由

优先建立与 SEVIR 官方 synrad 相连的基线，再分离模态、时间、分辨率、损失及模型家族的影响。官方基线使用 IR069+IR107+GLM → 1 km VIL，不含 C02；项目的四模态、2 km、多帧方案属于扩展。复现与扩展应分别记录，不能把改变 Target 后的指标直接当作超过原论文的证据。

领域路线见 [knowledge.md](knowledge.md)；计算方法路线见 [methods.md](../research/methods.md)。当前没有统一协议下的跨论文 SOTA 排名。

## Previous Research Conversation

- 原始来源：[ChatGPT preliminary survey](https://chatgpt.com/share/6aaba84f-c8ec-83ee-9248-075cd80b7fa6)。
- 本轮同时读取用户于 2026-09-17 补充的完整粘贴文本（包含两轮调研回答、研究背景和中间 Prompt），合并重复内容并保留后一轮修正。
- 来源分层：用户定义决定研究范围；论文/官方仓库核验支持外部事实；对话中的建议保留为候选或待验证问题。历史对话不证明本项目已经训练、下载数据或完成复现。
- 本知识库保存独立可读的核心内容，不依赖共享链接继续有效；核验不足之处集中记录在 [literature.md](../research/literature.md) 与 [current_state.md](current_state.md)。
