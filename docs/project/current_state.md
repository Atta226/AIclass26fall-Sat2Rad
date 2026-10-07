# Current State

更新：2026-09-18。新 AI 先读本文件与 [context.md](context.md)，再按任务进入研究文档。

## 项目实际状态

目前处于**第一版研究知识库 / 实验定义准备**阶段。本轮检查根目录与全部 Markdown；`src/`、`configs/`、`data/`、`experiments/`、`outputs/` 尚无实现、数据或结果文件。没有训练模型、没有本地 checkpoint、没有实验分数。外部论文结果不是本项目结果。

本轮任务是 Conversation → Project Knowledge：整理用户共享调研及补充全文、核验已有代表工作、实际保存 Markdown。没有把中间 Prompt 的“请做 Survey”再执行为新一轮全领域综述。

## Current Understanding

- 任务：SEVIR 多模态卫星 → **同一时刻 VIL**，Lead Time=0；多帧也是当前反演。
- 输入候选：C02/C09/C13/GLM。C02 的昼夜可用性、GLM 的表示和贡献需消融，不能理解为已经决定所有样本固定四通道。
- 当前实验方案：2 km、192×192、5 min，覆盖约 384×384 km；原始 VIL 为 1 km、384×384。2 km 是项目选择，粗化算法未定。
- VIL、反射率/CREF、降水率和累积降水必须区分。Satellite QPE 与 future radar 不参与本任务直接排名。
- SEVIR 官方 IR+GLM→VIL U-Net/cGAN 是最接近的文献基准；官方 synrad 为 1 km，不能与项目 2 km 结果直接宣称优劣。
- 当前 baseline 定义为 **SEVIR 官方 synrad**；另设项目 2 km 适配基线。用户说明 2025 年前序任务统一了输入分辨率且未加入闪电，2026 年将把原生多分辨率融合与 GLM 加入列为明确扩展。
- 本轮已调研的多数直接 Satellite→Radar retrieval 工作采用单时刻卫星输入；相比继续只更换单帧 backbone，融入较长历史序列、完成 **Satellite(t−n:t)→VIL(t)** 的多帧到单帧反演，是明确保留的未来研究方向。该判断描述当前文献样本，不等于断言全领域不存在多帧工作。
- 2026 前沿方法的当前推荐顺序为：**DRDD 第一 SOTA 迁移备选**，理由是主会 paired cross-domain I2I、limited paired data 目标以及公开代码/权重；**PairFlow 第二 SOTA 迁移备选**，代表 paired Flow Matching，理由是结构保真、aerial→map 相似性和较低训练成本。二者尚未在 Satellite→VIL 上验证。完整说明见 [methods.md](../research/methods.md)。
- 领域已有 CNN、注意力、多分辨率、Transformer 和生成式路线；“图像清晰”与“气象定量正确”是不同目标。
- 当前没有最终模型选择，也没有经统一协议证明的 SOTA。优先比较信息来源、时间、尺度与强核可靠性。

来源与限制：[context.md](context.md)、[literature.md](../research/literature.md)、[datasets.md](../research/datasets.md)。

## Open Questions

| 优先级 | 未决项 | 下一步需要的证据 |
|---|---|---|
| P0 | SEVIR 版本、模态覆盖、有效样本、编码/QC | CATALOG + 少量原始样本 + 官方转换定义 |
| P0 | 2 km VIL 使用物理均值还是其他粗化 | 原始/粗化分布与高值核心对照；不改变 VIL 目标身份 |
| P0 | 训练/验证/测试边界与风暴隔离 | 固定 event/time 清单、重叠事件审计 |
| P0 | 官方权重现在能否实际下载与加载 | 文件类型、哈希、依赖环境和前向运行 |
| P1 | 长时序多帧反演单帧是否优于单帧、窗口多长 | T1/T3/T7/T13 控制实验，Target 始终 t；按对流生命周期和强核分层 |
| P1 | C02 与 GLM 的独立增益 | 共同样本子集模态消融；昼夜分别评估 |
| P1 | GLM 5 min 或其他窗口/表示 | 1/5/10/15/30 min；先确认 event/group/flash/energy 字段和截止时刻，再比较强 VIL 表现 |
| P1 | early fusion、末端上采样或原生多分支 | 对齐投影/范围/时间与训练预算，控制参数差异；检查 VIS 纹理是否在早期丢失 |
| P1 | 高值损失与虚警的折中 | 阈值 CSI/POD/FAR、频率与对象指标 |
| P2 | Transformer / diffusion 是否值得 | 同协议强 CNN 对照、成本、强核与校准结果 |
| P2 | 是否加入 NWP/DEM、是否做跨区域任务 | 新输入实时可用性、额外数据与科学收益；尚未授权为固定方案 |
| P2 | CREF 辅助研究 / probabilistic retrieval | 独立任务协议；不得悄然替换当前 VIL |

VIL 已是当前 Target，不再把“VIL 还是雨强”写成未作决定。可讨论未来扩展，但必须新建决策记录。

## 核验完成与未完成

已整理 16 篇对话已有工作，提供正式论文入口、书目、任务分组和可复现状态；未核验的论文细节明确标记。确认 SEVIR、SRViT、EF Sat2Rad、SRDiff 仓库入口以及相关数据页面，不等于完成运行复现。

尚未解决：SEVIR 权重分享页仅确认 HTML 响应；SRViT 权重目录未验证文件加载；SRDiff 缺配套 VAE/训练权重、Sat2Rdr 独立数据入口和逐实验时间定义；Hu diffusion 项目 Code 入口未成功访问；ER-UNet 等若干工作未找到可靠公开仓库。完整记录见 [文献资源审计](../research/literature.md)。

## Next Actions

1. 读取少量 SEVIR 数据，核验编码、配准、GLM 字段和缺失掩码；生成数据清单。
2. 固定 Target 粗化、split 和 [evaluation.md](../research/evaluation.md) 的可执行参数。
3. 单独建立原官方 synrad 复现与项目 2 km U-Net 基线，再按 [experiments.md](../research/experiments.md) 消融。
4. 资源核验或实验产生新事实时同步本文件；候选方案只有经过决策才写入 [decisions.md](decisions.md)。

## 文档一致性与来源

原 [Codex](../ai/codex.md)、[Claude](../ai/claude.md)、[workflow](../ai/workflow.md) 含 EC/METAR/Web 项目遗留内容，本轮加了明确停用标记；其旧优先级和“已有 Web/API”不是本项目事实。适用规范在 [ai_prompt.md](ai_prompt.md)。

任务开始时用户已修改 `docs/ai/templates/survey_prompt_template.md` 与 `literature_review_prompt_template.md`；本轮保留原样。调研共享链接与补充正文来源记录在 [context.md](context.md)。
