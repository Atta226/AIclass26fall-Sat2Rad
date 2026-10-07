# DRDD Upstream Record

## Repository

- Official repository: https://github.com/HKU-HealthAI/DRDD.git
- Local path: `reproductions/drdd/upstream/DRDD`
- Git integration: submodule
- Branch at registration: `main`
- Commit: `9830fa0b58dfd7b1aa55e24ca3e81fd2185dd56c`
- Git describe: `9830fa0`
- Retrieved / registered: 2026-10-07
- Local modification at registration: None

## Reproduction status

The upstream repository is registered and pinned by the parent OpenNowcastLab repository.

The following items still require explicit verification before being treated as project facts:

- license;
- paper / official documentation;
- checkpoint source;
- checkpoint checksum;
- official environment;
- official preprocessing;
- official inference command;
- official training availability;
- evaluation protocol.

## Rules

- Keep `reproductions/drdd/upstream/DRDD` as close to official upstream as possible.
- Do not perform long-term OpenNowcastLab development directly inside the upstream repository.
- Compatibility changes should be documented under `reproductions/drdd/patches/`.
- Project adapters should be developed under `reproductions/drdd/adapters/`.
- Reference outputs should be stored under `reproductions/drdd/reference/`.
- Promote only verified reusable behavior into `src/`.
