# Research Roadmap

更新：2026-09-18。当前仅完成知识整理，后续阶段均未执行。

| 阶段 | 工作 | 完成证据 |
|---|---|---|
| 0 — Project Memory | 当前任务、领域/方法分离、论文/代码/数据/未决问题 | 本轮 Markdown 已落地；资源限制显式记录 |
| 1 — 数据与观测审计 | CATALOG、样本、编码、时间/空间配准、GLM 和 C02 缺失 | 可复用清单、样本统计、质量掩码和单位定义 |
| 2 — 固定实验协议 | 2 km Target、事件/日期隔离、阈值、FSS 窗口、指标 | 划分文件、配置与指标最小验证；原协议/扩展分开 |
| 3 — 最小基线 | 官方 synrad 可用性检查；项目 IR+GLM U-Net、统计参照 | 可加载数据、可训练、预测和一致评价闭环 |
| 4 — 科学控制实验 | 优先验证单帧 vs 长时序多帧→当前单帧，再独立研究 GLM、白天 C02、原生多分辨率、粗化和极值损失 | T1/T3/T7/T13；G01 的 1–30 min；V01/V02 可见光；F01 三种尺度处理；强核、生命周期、成本和饱和证据 |
| 5 — 模型家族与少样本 | strong CNN、时序适配；DRDD 第一 SOTA 迁移备选、PairFlow 第二/Flow Matching 备选；再扩展 bridge/diffusion | 同协议收益/成本；1/5/10/25/100% 学习曲线；结构保真、生成校准与复现状态 |
| 6 — 泛化与论文 | 地区/季节/昼夜、极端事件、时间一致性 | 明确证据范围；可复现配置、代码和结果包 |

研究逻辑：Scientific Problem → AI Task → Dataset Construction → 已有文献针对性精读 → Baseline → Model/Weight Acquisition → Experiment Design → Training & Evaluation。

下一轮优先解决数据定义与 [当前问题](current_state.md)，不继续无边界增加模型清单。
