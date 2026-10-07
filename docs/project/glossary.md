# 术语表

| 术语 | 本项目含义与边界 |
|---|---|
| Satellite-to-Radar Retrieval | 卫星观测到雷达或雷达衍生场的反演总称；必须另列 Target 与时间 |
| Synthetic Radar | 非雷达资料生成的雷达代理场；不是 SAR（合成孔径雷达） |
| Reflectivity / dBZ | 反射率 / 反射率对数单位；不是 mm/h |
| CREF / Composite Reflectivity | 垂直最大反射率形成的二维产品；不是 VIL |
| VIL | Vertically Integrated Liquid，雷达衍生垂直积分液态水估计；需区分 kg/m² 与存储编码 |
| QPE | Quantitative Precipitation Estimation，以降水率或降水量为目标 |
| Precipitation Retrieval | 降水反演，不能笼统代替所有雷达场重建 |
| Image-to-Image Translation | 方法层的图像模态映射；本项目是带物理量定义的连续场回归 |
| Sequence-to-Image Retrieval | 历史及当前观测估计当前目标；不必是预测 |
| Lead Time | Target 时间减去输入截止时间；本项目为 0 min，不等于产品延迟 |
| Nowcasting | 未来短时预测；雷达历史→未来雷达不是本项目核心 |
| GOES / ABI / GLM | 卫星系列 / 多光谱成像仪 / 闪电成像仪，不是三个并列数据集 |
| NEXRAD / MRMS | 天气雷达网络 / 多雷达多传感器产品系统 |
| SEVIR | 配对事件数据集，也有同名数据论文和多任务基准；不能将其当作模型名 |
| ir107 | SEVIR C13 数据键；ABI C13 名义中心波长约 10.3 μm |
| Event / Group / Flash | GLM 不同聚合层次；SEVIR 存储 flashes，不自动拥有所有原始 GLM 变量 |
| Encoded / Physical / Normalized VIL | 存储编码 / 物理值 / 模型归一化值，三者阈值不可混用 |
| Frequency Bias | (hits+false alarms)/(hits+misses)，理想值 1；不是平均数值偏差 |
| FAR | 本文为 false alarm ratio = F/(H+F)，不是 F/(F+正确拒绝) |
| Deterministic / Probabilistic | 单一估计 / 条件概率表达；可采样不等于已经校准 |
| Foundation Model | 广泛预训练、可迁移模型的概念；Transformer/DiT 架构本身不构成此身份 |

外部定义与资料入口见 [context.md](context.md)、[datasets.md](../research/datasets.md) 和 [评价协议](../research/evaluation.md)。
