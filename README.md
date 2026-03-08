# OpenClaw Skills Healthcheck Workflow

A production-oriented workflow to verify whether your current OpenClaw skills can be reliably invoked before critical tasks.

---

## English

### What this repo does

This workflow performs:
1. **Eligibility snapshot** via `openclaw skills check`
2. **Smoke tests** for critical ready skills (`clawhub`, `github`, `gog`, `mcporter`, `nano-pdf`, `summarize`, `tmux`, `video-frames`)
3. **Integration checks** for env-dependent skills (`GEMINI_API_KEY`, `GOG_KEYRING_PASSWORD`, `TAVILY_API_KEY`)
4. Generates both:
   - Markdown report
   - JSON report

### Why this matters

For high-stakes usage, "installed" is not enough. You need to verify:
- CLI availability
- auth state
- key env variables
- real command execution

### Quick Start

```bash
cd openclaw-skills-healthcheck-workflow
chmod +x scripts/run_skills_healthcheck.sh
bash scripts/run_skills_healthcheck.sh
```

With env checks enabled:

```bash
GEMINI_API_KEY=xxx \
GOG_KEYRING_PASSWORD=xxx \
TAVILY_API_KEY=xxx \
bash scripts/run_skills_healthcheck.sh
```

### Output

Reports are generated in `reports/`:
- `skills-healthcheck-<timestamp>.md`
- `skills-healthcheck-<timestamp>.json`

### Decision Rule

- `FAIL > 0` => **Not ready** for critical production tasks
- `FAIL = 0` and only `WARN` => **Conditionally ready** (missing optional integrations)
- `FAIL = 0` and `WARN = 0` => **Fully ready**

---

## 中文

### 这个仓库做什么

该工作流用于在执行关键任务前，检查 OpenClaw 的 Skills 是否“可调用、可鉴权、可执行”。

包含四层检查：
1. 用 `openclaw skills check` 做**就绪快照**
2. 对关键技能做 **smoke test**（不只看安装）
3. 对依赖环境变量的技能做 **集成检查**
4. 输出 **Markdown + JSON 双报告**

### 为什么重要

“装了”不等于“能用”。
关键任务前必须确认：
- 命令是否存在
- 账号是否已认证
- key/密码是否已注入
- 实际命令是否跑通

### 快速使用

```bash
cd openclaw-skills-healthcheck-workflow
chmod +x scripts/run_skills_healthcheck.sh
bash scripts/run_skills_healthcheck.sh
```

带环境变量做全量检查：

```bash
GEMINI_API_KEY=xxx \
GOG_KEYRING_PASSWORD=xxx \
TAVILY_API_KEY=xxx \
bash scripts/run_skills_healthcheck.sh
```

### 输出产物

位于 `reports/` 目录：
- `skills-healthcheck-<timestamp>.md`
- `skills-healthcheck-<timestamp>.json`

### 判定规则

- 只要 `FAIL > 0`：视为**不可用于关键任务**
- `FAIL = 0` 但有 `WARN`：视为**有条件可用**
- `FAIL = 0` 且 `WARN = 0`：视为**完全可用**

---

## Notes

- This workflow intentionally separates **blocking** vs **non-blocking** checks.
- You can wire this script into cron/CI before scheduled jobs.
