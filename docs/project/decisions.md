# Decisions

## 2026-09-17 — 当前研究边界（已确认）

依据用户研究背景与前期对话：核心 Dataset=SEVIR，Target=同一时刻 VIL，Lead Time=0 min。单帧与历史序列为待比较输入设计；不默认改成未来预测、CREF 或雨强。具体定义见 [context.md](context.md)。

## 2026-09-17 — 空间与模态方案（当前计划，未证明最优）

计划使用约 2 km、192×192、5 min 网格；输入候选含 C02/C09/C13/GLM。原生多分辨率、C02 昼夜策略、GLM 聚合、VIL 粗化算法尚未定案。四模态候选全集不等于强制所有实验使用全部模态。

## 2026-09-17 — 知识库组织（本轮执行）

优先填充现有 `project/` 与 `research/` 文件：context 定义任务、knowledge 存领域路线、methods 存 AI 路线、literature 存论文与代码、current_state 存状态。仅新增 [datasets.md](../research/datasets.md) 与 [evaluation.md](../research/evaluation.md)，因为二者有独立且较长的协议职责。

保留历史共享入口与用户两份已修改模板；不复制聊天记录，不将外部论文声称变成本项目实现事实。EC/METAR 指南标记为不适用，避免下一位 AI 继承错误项目优先级。

## 2026-09-18 — Baseline 与未来研究方向（已确认范围）

- 当前可复现锚点为 SEVIR 官方 synrad baseline；项目 2 km 版本单独命名和报告。
- 2025 年前序任务统一输入分辨率且未使用闪电；2026 年计划比较原生多分辨率融合、GLM 融合和长历史多帧→当前单帧 VIL。
- C02 可见光的白天增益单列为研究主题：先在共同白天子集做净贡献消融，再处理夜间缺测；不与 GLM 或多分辨率架构变化合并归因。
- GLM 的聚合窗与表示是实验变量，不只是固定 preprocessing。
- 2026 SOTA 迁移备选按 **DRDD 第一、PairFlow 第二** 排序。DRDD 是前期对话的最佳推荐，重点研究 limited paired data；PairFlow 代表 paired Flow Matching，重点研究结构保真与训练效率。这是待验证的模型选择优先级，不是已经取得的 Satellite-to-Radar SOTA 结论。

## 尚未形成的决策

最终模型、预训练权重、序列长度、loss、split、GLM 栅格定义、VIL 解码与降采样实现、NWP/DEM 输入、生成集合规模均未确定。SEVIR 官方 baseline、DRDD 和 PairFlow 都不是已训练的本项目模型或最终论文方法。
