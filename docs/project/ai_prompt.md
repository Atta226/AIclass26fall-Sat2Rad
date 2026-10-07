# 后续 AI 工作入口

本项目研究 SEVIR Satellite→同一时刻 VIL，Lead Time=0。每次开始先读 [context.md](context.md)、[current_state.md](current_state.md)、[decisions.md](decisions.md)，检查真实目录与已有改动；按任务继续读 [数据](../research/datasets.md)、[方法](../research/methods.md)、[文献资源](../research/literature.md)、[评价](../research/evaluation.md)。

- 以最新用户要求与真实文件为准；历史对话中的“公开/已完成”需要独立证据。
- 不把 QPE、CREF、VIL、nowcasting 混为同一任务；不从 Transformer/DiT 名称推断 Foundation Model 或 SOTA。
- 当前 2 km 网格是计划，方法、时间窗、模态选择仍待实验；保留未决项。
- 不把未找到代码写成代码绝不存在；不把仓库/权重目录存在写成已复现。资源记录必须有链接、核验日期和剩余限制。
- 实验先固定数据、标签与 split，再比较模型；避免风暴/时间泄漏、未来输入、测试集拟合归一化和事后挑选指标。
- 新结果写入 [experiments.md](../research/experiments.md)，再更新状态；新决策写入 decisions。不要编造结果填空。
- `docs/ai/` 内带 EC/METAR 的旧指南已标为历史材料，不是本项目工作指令。

本知识库是前期调研的可恢复上下文，不是要求每次重新开展完整 Survey 的 Prompt。
