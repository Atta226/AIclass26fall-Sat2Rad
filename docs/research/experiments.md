# 实验设计与记录

更新：2026-09-18。**当前没有任何已运行实验或本项目指标。** 下表是候选顺序，不是完成清单。

| ID | 目的 | 改变变量 | 固定/报告内容 | 状态 |
|---|---|---|---|---|
| D00 | 数据与 Target 审计 | VIL 粗化 mean/bilinear/max（max 单列标签语义） | 同原始事件，分布/峰值/面积变化 | 未执行 |
| B00 | 官方 synrad 复现锚点 | 尽量保持官方 1 km IR+GLM 协议 | 官方划分、预处理、损失/指标/版本；权重先验收 | 未执行 |
| B01 | 项目 2 km 基线 | 冻结 Target 后适配 U-Net；加统计参照 | 项目 split、编码/单位、训练预算 | 未执行 |
| M01 | GLM 模态净贡献 | IR / IR+GLM | 共同样本子集，昼夜、强度分层；与 G01 分开回答“有没有用”和“怎样表示” | 未执行 |
| V01 | 可见光独立作用 | 共同白天子集上的 IR+GLM vs IR+GLM+C02；再比较 C02 early resize/native branch | 固定太阳天顶角条件、Target、split、loss 和预算；边界、定位、FSS、强核；不得混用不同样本集 | 未执行 |
| V02 | 可见光昼夜可用性 | 昼夜分支 vs availability mask/modality dropout | 夜间 C02 视为不可用观测；全天、白天、夜间分别报告 | 未执行 |
| T01 | 核心未来方向：单帧 vs 长时序多帧→当前单帧 | T=1/3/7/13；先 frame stacking 隔离历史信息，再比较显式时序模型 | 输出始终为 VIL(t)；固定 split/loss/Target，控制参数量和预算；按强核与生命周期分层 | 未执行 |
| G01 | 闪电表示 | 1/5/10/15/30 min；event/group/flash count、density、energy（按实际字段） | 输入截止 t，所有其他模态不变；高 VIL 与无闪电降水分层 | 未执行 |
| F01 | 多分辨率 | early resize vs 单次末端上采样 vs native multi-encoder/feature-pyramid decoder | 投影/范围/时间与标签相同，容量/算力对照；报告各阶段分辨率 | 未执行 |
| L01 | 极值损失 | 基础 L1/L2 与高值加权 | 数据、模型、阈值；POD/FAR/频率联合 | 未执行 |
| A01 | 强模型对照 | strong CNN / SRViT 适配 | 信息、Target、split、loss 与预算尽量一致 | 未执行 |
| P01 | 生成价值 | cGAN / conditional diffusion | 成员数、采样成本、校准；与确定性分开评分 | 未执行 |
| S01 | SOTA 迁移备选与少样本 | U-Net/strong deterministic vs DRDD（首选）vs PairFlow（Flow Matching 备选）；训练样本比例 1/5/10/25/100% | 同一 paired subset、Target、split；重复 seed；学习曲线、结构/强核、训练与推理成本；另报告预训练依赖 | 未执行 |

每次运行至少记录：问题/Hypothesis ID、代码版本、数据清单及哈希、split、输入与时间窗、Target 单位/变换、缺测策略、模型参数、loss、seed、硬件与训练预算、权重路径、评价配置、原始结果、失败案例、结论与限制。

一次改变一个主变量；不能把增加 GLM、历史帧、复杂 backbone 和新 loss 的联合收益全归给模型。出现负结果同样记录，不能只保留有利样本或最好的生成成员。
