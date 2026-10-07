# 文档体系说明

## 第一版研究知识库导航

更新：2026-09-18。先读任务与状态，再按需要展开；不需要重读共享聊天才能继续项目。

| 文件 | 职责与本轮增加内容 |
|---|---|
| [project/context.md](project/context.md) | 科学背景、当前 Input/Target、lead=0、2 km/5 min、来源与任务边界 |
| [project/knowledge.md](project/knowledge.md) | 气象/遥感观测机制、2021–2026 U-Net 家族路线、GLM 初调研、科学挑战与证据边界 |
| [project/glossary.md](project/glossary.md) | VIL/CREF/QPE、观测与编码、方法/任务术语 |
| [project/current_state.md](project/current_state.md) | 已知、未决、真实仓库状态、下一步和资源限制 |
| [project/decisions.md](project/decisions.md) | 已确认边界、暂定方案、文档组织与未决策事项 |
| [project/roadmap.md](project/roadmap.md) | 数据审计→协议→基线→消融→生成/泛化路线 |
| [project/architecture.md](project/architecture.md) | 待实现数据流、目录职责与编码/掩码边界 |
| [project/ai_prompt.md](project/ai_prompt.md) | 后续 AI 读取顺序、事实/候选区分与更新规范 |
| [research/methods.md](research/methods.md) | 独立 AI 方法路线、28 个可迁移 CV 候选表、DRDD/PairFlow SOTA 迁移备选、长时序/原生多分辨率/GLM、loss 与迁移顺序 |
| [research/literature.md](research/literature.md) | 16 篇已有工作、完整书目/正式入口、代码/权重审计、可比组与纠错 |
| [research/datasets.md](research/datasets.md)（新增） | 数据集表、原始与模型尺度、配准/粗化/缺失、split 防泄漏 |
| [research/evaluation.md](research/evaluation.md)（新增） | 图像/阈值/结构/极值/概率评价，公式、单位与不平衡限制 |
| [research/hypothesis.md](research/hypothesis.md) | 五项核心未来假设：长时序、多分辨率、GLM、DRDD 少样本、白天可见光；以及扩展假设与反证条件 |
| [research/experiments.md](research/experiments.md) | 控制实验候选与记录要求；当前无结果 |

`skills/` 中原有领域文件尚为空，本轮不为凑结构重复填入相同知识；稳定知识集中在 knowledge、datasets 与 evaluation。`ai/templates/` 是可复用 Prompt，不是已完成研究的证据。

`ai/codex.md`、`ai/claude.md`、`ai/workflow.md` 含其他 EC/METAR 项目旧正文，已加停用标记。适用规范是 [project/ai_prompt.md](project/ai_prompt.md)。

## 目录结构

```text

docs/
│
├── README.md                # 文档体系说明（当前文件）
│
├── project/                 # 项目核心认知文档
│   ├── context.md           # 项目背景与整体介绍
│   ├── architecture.md      # 系统/算法架构说明
│   ├── decisions.md         # 关键技术决策记录
│   ├── current_state.md     # 当前项目状态
│   ├── roadmap.md           # 项目规划路线
│   ├── glossary.md          # 专业术语说明
│   ├── ai_prompt.md         # AI 协作规范
│   └── knowledge.md         # 长期经验与知识沉淀
│
├── research/                # 科研相关文档
│   ├── literature.md        # 文献调研
│   ├── hypothesis.md        # 科学问题与研究假设
│   ├── methods.md           # 方法设计
│   ├── datasets.md          # 数据资料与预处理协议
│   ├── evaluation.md        # 独立评价协议
│   ├── experiments.md       # 实验记录
│   └── papers/              # 论文资料
│
├── skills/                  # 可复用技术能力说明
│   ├── meteorology.md       # 气象领域知识规范
│   ├── satellite.md         # 卫星数据处理规范
│   ├── radar.md             # 雷达数据处理规范
│   ├── pytorch.md           # 深度学习开发规范
│   └── deployment.md        # 部署相关规范
│
└── ai/                      # AI 工具使用说明
    ├── claude.md            # Claude 使用规范
    ├── chatgpt.md           # ChatGPT 使用规范
    ├── codex.md             # Codex 使用规范
    └── workflow.md          # AI 协作流程

```
