# 模型复现

`reproductions/` 是研究／复现层，用于保存从官方第三方实现到本项目已验证 Benchmark 结果的完整可追溯路径。它不是重新实现模型、也不是将第三方源码复制进 `src/` 的地方。

## 生命周期

~~~text
1. 建立模型复现骨架
2. 核验论文、官方仓库与许可证
3. 运行 scripts/add_upstream_submodule.sh
4. 固定上游提交版本
5. 完成 UPSTREAM.md
6. 建立官方运行环境
7. 验证官方推理
8. 保存参考证据
9. 实现并验证项目适配器
10. 生成规范预测结果
11. 运行统一评估
12. 证据完整后才标记为 benchmark_ready
~~~

每个模型复现目录均保留 `README.md`、`UPSTREAM.md`、`STATUS.md`，以及 `upstream/`、`adapters/`、`patches/`、`reference/`、`tests/`。仅在官方来源信息完成核验后，才可使用 [scripts/add_upstream_submodule.sh](../scripts/add_upstream_submodule.sh)；具体规则见[复现工程契约](../docs/engineering/reproduction.md)。
