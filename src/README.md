# 稳定基准框架

`src/` 用于放置由本项目维护、经过验证且可复用的 Benchmark（统一基准）能力；它不是第三方模型仓库的镜像。

~~~text
sat2rad_bench/
├── data/           # 统一数据接口与数据约定
├── models/         # 统一模型接口与构建逻辑
├── evaluation/     # 统一评估接口与指标实现
├── visualization/  # 通用可视化能力
├── artifacts/      # 实验产物与元数据约定
└── pipelines/      # 可复用流程编排
~~~

这些目录当前仅为职责骨架。尚未实现 Dataset、模型、Trainer、Registry、Factory、指标或 Pipeline；第三方模型源码也不应复制到此处。
