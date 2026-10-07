# 脚本

`scripts/` 存放项目级、可复用的工程工具。

## add_upstream_submodule.sh

~~~bash
bash scripts/add_upstream_submodule.sh <model-key> <official-repository-url>
~~~

该工具会校验项目根目录和模型标识，要求复现骨架已经存在，避免覆盖已占用的 `upstream` 路径；随后将子模块注册到 `reproductions/<model-key>/upstream/<repository-name>`，并在 `UPSTREAM.md` 中记录已核验的 Git 来源信息。

只有在论文、官方仓库、许可证和目标模型标识均已核验后，才可运行该脚本。本骨架阶段未添加任何子模块。
