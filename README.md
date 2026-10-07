# AIclass26fall-Satellite-based-retrieval-of-radar-precipitation 项目目录结构说明

研究目标：利用 SEVIR 的 GOES-16 C02/C09/C13 与 GLM，反演**同一时刻的雷达 VIL**。当前计划采用 2 km、192×192、5 min；单帧和历史序列均为 Lead Time=0 的 retrieval。最终模态组合、重采样与模型待实验。

目前已建立第一版研究知识库，尚无本地数据、训练实现或实验结果。开始工作请依次阅读：

1. [研究背景与任务定义](docs/project/context.md)
2. [当前状态与未决问题](docs/project/current_state.md)
3. [文档导航](docs/README.md)

知识库整理自 [前期调研对话](https://chatgpt.com/share/6aaba84f-c8ec-83ee-9248-075cd80b7fa6)及用户补充正文，核验日期为 2026-09-17。论文、代码、数据与权重可用性分别记录，未将对话建议当作已完成实验。

## 📁 目录结构概览

```text
.
├── configs/          # 配置文件
├── data/             # 预处理数据集，存放小数据，公用数据集、大型数据集建议存放在/data1
├── docs/             # 项目文档
├── experiments/      # 实验记录与模型权重
├── outputs/          # 预测结果与评估图表
├── src/              # 核心源代码
├── .gitignore        # Git忽略规则
└── README.md         # 项目说明文档 (本文件)

```
