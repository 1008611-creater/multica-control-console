# Multica CLI / MCP 安装评估

评估日期：2026-09-21

## 已安装组件

| 组件 | 来源 | 版本 | 安装位置 | 状态 |
|---|---|---:|---|---|
| `multica` CLI | Multica 官方 GitHub Release | 0.5.0 | `C:\Users\lsb\.multica\bin\multica.exe` | 可用 |
| `multica-mcp` | 社区项目 `strider2038/multica-mcp` | 0.2.0 | `C:\Users\lsb\bin\multica-mcp.exe` | 已安装，待配置 PAT |

两个目录都已加入当前用户 PATH。

## 只读验证

官方 CLI 已验证可用：

- `multica version`
- `multica auth status`
- `multica workspace list`
- `multica issue list`
- `multica agent list`
- `multica skill list`
- `multica workspace mcp list`

当前 CLI 观察到：

- 默认 workspace 可访问；
- 已有历史 Issue、Agent 和 Skill；
- workspace MCP 列表为空；
- CLI 可以直接承担日常 workspace/Issue/Agent 管理。

社区 MCP 已验证二进制和配置门禁：

- Windows x64 Release 压缩包 SHA-256 已校验；
- 设置 `MULTICA_BASE_URL` 和 `MULTICA_READ_ONLY=true` 后运行；
- 未提供 `MULTICA_TOKEN` 时按预期拒绝启动；
- 未保存、打印或写入任何 PAT。

## 结论

当前最有用的是官方 CLI：它已经能直接完成本项目下一步的只读审计、Issue 创建/查询和 Agent 管理。

社区 MCP 适合在“希望从 Codex/Claude/Cursor 直接调用 Multica”时再启用。启用时应优先：

1. 单独创建最小权限 PAT；
2. 先用 `MULTICA_READ_ONLY=true` 做工具发现；
3. 确认 API 版本兼容后再开放写操作；
4. 不把 PAT 写入仓库、Issue、日志或 MCP 配置文件。

## 推荐顺序

```text
官方 CLI 跑通试跑
→ 社区 MCP read-only 工具发现
→ 明确需要跨 Agent/IDE 调用后再开放写操作
```

## 来源

- 官方 CLI 文档：<https://multica.ai/docs/cli>
- 官方 Desktop/CLI 关系：<https://multica.ai/docs/desktop-app>
- 官方 MCP 管理命令：<https://github.com/multica-ai/multica/blob/main/apps/docs/content/docs/cli.mdx>
- 社区 MCP：<https://github.com/strider2038/multica-mcp>
