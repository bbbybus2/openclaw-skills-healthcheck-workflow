# Skills Healthcheck Workflow (EN/中文)

## EN

1. Collect readiness map using `openclaw skills check`.
2. Execute CLI-level smoke tests for critical skills.
3. Execute integration tests for key-dependent skills.
4. Classify results into PASS / WARN / FAIL.
5. Output machine-readable JSON + human-readable Markdown.
6. Block important tasks if any FAIL exists.

## 中文

1. 先用 `openclaw skills check` 获取就绪全景。
2. 对关键技能执行 CLI 级 smoke test。
3. 对依赖密钥/密码的技能执行集成测试。
4. 将结果分类为 PASS / WARN / FAIL。
5. 同时输出 JSON（机器）与 Markdown（人工）报告。
6. 若存在 FAIL，阻断关键任务执行。
