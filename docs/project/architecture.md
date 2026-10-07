# 数据流与实现边界（计划）

当前仓库尚无模型或训练代码，下面是待实现的数据流，不能当作现有功能。

```text
SEVIR CATALOG / 原始各模态
  → event/time 划分与重叠检查
  → 解码、质量掩码、配准与因果时间窗
  → 训练集归一化 / 冻结 Target 重采样
  → early-resize 单网格，或各模态原生/近原生网格的独立 encoder
  → 单帧 [C,H,W] 或序列 [T,C,H,W] 特征
  → 物理尺度对齐与 feature fusion / pyramid decoding
  → 确定性或条件生成候选模型
  → VIL(t) / VIL(t) 集合
  → 反归一化、统一评价与分层诊断
  → 配置、预测、指标、图表和实验记录
```

`data/` 存小样本或清单；大型数据路径配置化。`configs/` 记录数据版本、通道、Target、split、时间窗、loss、seed、指标。`src/` 将读取/预处理、模型、训练和评价分开。`experiments/` 记录运行与权重，`outputs/` 记录预测和诊断。以上目录已有，但尚无实现文件。

实现时严格区分 encoded/physical/normalized VIL；缺失掩码一路传播；GLM 聚合截止 t；历史窗口不能跨 split。原生多分辨率保留的是采样尺度，不免除投影、范围、像元中心和时间对齐。公共规范：[datasets.md](../research/datasets.md)、[methods.md](../research/methods.md)、[evaluation.md](../research/evaluation.md)。
