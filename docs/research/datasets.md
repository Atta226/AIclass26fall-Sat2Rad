# 数据与预处理上下文

核验日期：2026-09-17。此文件记录数据来源和计划，**尚未下载或读取本地 SEVIR 样本**。项目任务以 [context.md](../project/context.md) 为准。

## Dataset / Observation Table

| Dataset / 资料 | Type | Variables | Spatial Resolution | Temporal Resolution | Coverage | Role | Official Link |
|---|---|---|---|---|---|---|---|
| GOES-16 ABI | 卫星仪器观测 | C02、C09、C13 | 星下点标称 0.5/2/2 km，离轴足迹变大 | CONUS 5 min；其他扫描模式不同 | GOES 观测域；本项目取 SEVIR 美国事件 | 输入来源 | [波段](https://www.goes-r.gov/spacesegment/ABI-tech-summary.html)、[模式](https://www.goes-r.gov/spacesegment/abi.html) |
| GOES-16 GLM | 闪电光学观测 | events/groups/flashes；SEVIR 为 flashes | 约 8–14 km 仪器足迹 | 连续观测，2 ms 仪器帧率；学习输入另做聚合 | 美洲及邻近海洋，实际依视场 | 闪电输入来源 | [GLM](https://www.goes-r.gov/spacesegment/glm.html) |
| MRMS | 多传感器产品系统 | CREF、QPE 等多个独立产品 | 代表性网格 1 km | 代表性更新 2 min，需核对具体产品 | 美国及相关业务区域 | GREMLIN/QPE 文献标签来源 | [NOAA NSSL](https://www.nssl.noaa.gov/projects/mrms/) |
| SEVIR | 配对、多分辨率事件数据 | vis / ir069 / ir107 / lght / vil | 0.5 / 2 / 2 / 闪电点事件 / 1 km | 非闪电模态 49 帧、5 min、4 h | CONUS 2017–2019 事件；每块约 384 × 384 km | 本项目主要数据与官方 synrad 基准 | [AWS 数据](https://registry.opendata.aws/sevir/)、[官方工具](https://github.com/MIT-AI-Accelerator/eie-sevir) |
| GREMLIN CONUS3 | 加工配对资料 | ABI、GLM、MRMS CREF | 统一 3 km | 匹配容差≤2.5 min；GLM 15 min 聚合；实际样本节奏待文件核验 | CONUS，2020/2021/2022 | 另一 Target 的辅助基准；非现成 VIL 外测 | [2020](https://doi.org/10.5061/dryad.h9w0vt4nq)、[2021](https://doi.org/10.5061/dryad.zs7h44jf2)、[2022](https://doi.org/10.5061/dryad.2jm63xstt) |
| FY-4A + CMA radar | 各论文自建数据 | AGRI、CREF，部分加 DEM | 各研究不同，不能统一填为 4 km | 依论文 | 中国各研究区域 | 领域文献参照 | [FY-4A 工作](https://doi.org/10.3390/rs13112229)、[Attention U-Net](https://doi.org/10.3390/s23010081)；统一加工集公开入口未确认 |
| Himawari + Australian radar/lightning | Hu 等研究配对数据 | 红外、地基闪电、1 km 高度反射率切片 | 目标 2 km、128 × 128 | 需完整数据说明核验 | 澳大利亚研究区域 | 生成式方法参照，不是 VIL/CREF 同一 Target | [论文](https://doi.org/10.1175/AIES-D-25-0016.1)、[项目](https://yuguanghu.com/SHRIMP-Page/)；加工集下载未确认 |
| Sat2Rdr | SRDiff 使用的数据名 | 具体传感器与标签字段待核验 | 未确认 | 未确认 | 未确认 | 保留待调查线索 | [SRDiff 论文](https://doi.org/10.1109/TGRS.2026.3686188)；独立官方数据入口未确认 |

SEVIR 初始论文描述超过 10,000 个事件；后续版本、模态交集和筛选后的可用样本数不同。不得把其他工作的样本量直接当成本项目训练样本量。以下载后的 CATALOG、版本和筛选记录为准。[数据论文](https://proceedings.neurips.cc/paper_files/paper/2020/hash/fa78a16157fed00d7a80515818432169-Abstract.html)

AWS 登记提供 `s3://sevir`（us-west-2），声明数据使用无额外限制；代码许可证单独核对。官方数据工具与 NeurIPS 实验仓库不是同一对象。原始卫星资料公开不等于各论文加工集、划分和 QC 自动可复现。

## SEVIR 官方 synrad 与本项目的差异

| 项目 | 官方论文 §3.4 | 当前计划 |
|---|---|---|
| 输入 | ir069、ir107、lght | 以同组合建立基础，再研究 C02 |
| 闪电 | IR 时刻之前 5 min flashes → 48 × 48 | 5 min 作为参照；其他历史窗为实验变量 |
| 输入空间处理 | resize 到 384 × 384 VIL 网格 | 统一 192 × 192 或原生分支 |
| Target | 384 × 384、1 km VIL | 192 × 192、2 km VIL |
| 归一化 | 使用训练集均值与标准差 | 重新以本项目训练子集拟合并保存 |
| 时间 | 当前时刻反演 | 当前时刻反演，另比较历史输入 |

来源：[原文 §3.4](https://proceedings.neurips.cc/paper/2020/file/fa78a16157fed00d7a80515818432169-Paper.pdf)。不能混淆“重现原论文”和“采用其结构的项目基线”。

## 预处理待定项与建议验收

1. 以 CATALOG 建立 event、模态、时刻和地理范围的对应；检查缺失模态与重复/重叠事件。49 帧是数据组织，不能保证每条记录所有模态都有效。
2. 同时保存原始编码值、质量掩码、解码方式和训练归一化参数。VIL 的非线性编码转换需按 [官方仓库](https://github.com/MIT-AI-Accelerator/eie-sevir) / 论文补充材料核对后实现，不能直接把 0–255 标为 kg/m²。
3. 地图投影、范围、像元中心及方向一致后才可 resize；不能只凭数组 shape 声称配准完成。数据已预配对也应抽样检查地标、事件时间与雷达/卫星错位。
4. 2 km 连续 VIL 的候选：面积均值、双线性插值。max / percentile pooling 改变标签为单元最大值/分位数，只可作为明确命名的敏感性任务。若定义物理平均，应先解码再平均；非线性编码下先平均编码再解码一般不等价。
5. 对不同粗化方案报告均值、P90/P95/P99、最大值、阈值面积、连通对象大小的变化，然后冻结一种主协议；保留原始 1 km 标签。
6. C02 夜间缺少可用太阳反射信号，不能当作普通 0 观测。比较全天 IR+GLM、白天加 VIS、显式缺失掩码/模态 dropout；共同白天子集上比较 VIS 增益，避免样本选择混淆。
7. GLM 过去时间窗可比较 1/5/10/15/30 min，但所有窗必须截止于 t，禁止引入 t 之后的闪电。候选表示包括 event/group/flash count、density 与 energy。SEVIR `lght` 主要是 flash 点记录，不保证保留原始 event/group/energy 全部字段；不可用的表示需要原始 GLM L2 资料，不能凭计划生成不存在的变量。
8. 原生多分辨率实验仍必须完成投影、物理范围、像元中心与时间对齐。保留不同数组分辨率不等于允许地理错位；记录每个 encoder 的输入网格和每次 feature resampling。

## Split 与数据泄漏

官方论文训练数据在 2019-06-01 之前，测试为该日及之后；synrad 的确定性模型用训练数据中的 20% 构造验证集。确切筛选代码和边界包含规则仍应在复现时核对。[原文 §3 与 §3.4](https://proceedings.neurips.cc/paper/2020/file/fa78a16157fed00d7a80515818432169-Paper.pdf)

项目原则为 **先划分事件/时间，再构建序列**。同一事件不能随机拆帧进入 train/test；不同 event ID 也可能来自同一云系或重叠时空块，需额外检查。跨日期边界的窗口应整体归属一侧或剔除；验证集只来自训练时段。标准化、阈值分位数、加权规则均只由训练数据确定，不能偷看测试集。

若改变原划分以加强风暴隔离，应单列新协议并报告样本数。另可按地区、季节、昼夜、强度分层评估，不能把 SEVIR 事件采样表现直接推广为连续业务气候分布表现。

## 其他资源的边界

CONUS3 采用共同 3 km 网格、10 km 假设云高视差订正、≤2.5 min 时差与 15 min GLM groups 累积。其数据页提供 Python/Fortran 读取方法，**不等于提供完整 GREMLIN 训练代码或原论文权重**。[2020 数据说明](https://datadryad.org/dataset/doi:10.5061/dryad.h9w0vt4nq)

GOES-R 页面公告计划于 2026-09-30 退役；上述现有入口本轮可检索，后续访问失败时从 [NOAA NESDIS](https://www.nesdis.noaa.gov/our-satellites/currently-flying/geostationary-satellites) 寻找迁移页面，并更新核验日期。
