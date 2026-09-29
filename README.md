# AIclass26fall-Satellite-based-retrieval-of-radar-precipitation 

## 项目目录说明
```text
./
├── README.md         # 项目说明文档 (本文件)
├── data              # 只存放数据说明，所有数据均保存在./data1
├── docs              # 项目文档
├── models            # 五个模型各自独立，保存从github上clone下的原始目录
│   ├── DRDD
│   ├── EFSat2Rad
│   ├── Omni-Weather
│   ├── SEVIR
│   └── SRDiff
├── experiments       # 五个模型各自独立，保存模型训练权重、训练日志、配置参数、loss曲线等
│   ├── DRDD
│   ├── EFSat2Rad
│   ├── Omni-Weather
│   ├── SEVIR
│   └── SRDiff
├── outputs           # 五个模型各自独立，保存模型测试指标、可视化预测图像等
│   ├── DRDD
│   ├── EFSat2Rad
│   ├── Omni-Weather
│   ├── SEVIR
│   └── SRDiff
└── shared            # 所有模型共用的代码项目，用于后期对比模型表现时加载相同的metrics、losses、trainer等
```

## 分支管理事项

### 1. 总体原则

- `main` 分支为稳定分支，仅存放经过验证、可运行的代码。
- **严禁任何成员直接向 `main` 分支推送修改。**
- 每周开始工作前，必须先将远程 `main` 的最新内容同步到本地，再合并到自己的个人分支，然后开始本周工作。

### 2. 每周标准工作流

**第一步：同步远程 `main` 到本地**

```bash
git checkout main
git pull origin main
```

**第二步：切换到自己的个人分支**
- 如果个人分支已存在：
```bash
git checkout 分支名
```
- 如果个人分支尚未创建，从 main 新建并切换：
```bash
git checkout -b 分支名
```

**第三步：将最新 main 合并到个人分支**
```bash
git merge main
```

**第四步：在个人分支上进行开发并提交**
```bash
git add .
git commit -m "本次更新简要说明"
```

**第五步：将个人分支推送到远程**
```bash
git push origin 分支名
```