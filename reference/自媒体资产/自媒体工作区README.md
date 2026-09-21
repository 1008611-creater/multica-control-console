# 自媒体工作区

工作目录：`E:\codex\niannianai\zimeiti`

主控线程：`019fd890-afc9-7ec0-8c3a-425ef617e91a`

## 已迁移内容

- `projects/self-media-skill-route/repos`：15 个自媒体相关开源项目
- `projects/trypost`：TryPost 开源社交媒体排期与发布项目
- `drafts`：aidaihuo 的自媒体内容草稿和可视化结果
- `assets/童装`：童装带货视觉样例及汇总文档

## 迁移边界

项目源码、Git 历史、公开配置和草稿已纳入工作区；`node_modules`、Python 虚拟环境、Next.js 构建缓存等可重建依赖未纳入。项目中的 `.env` 凭据文件保留在原位置，没有迁移或删除。

最终核验：路由项目 5,179 个文件、TryPost 2,600 个文件、草稿 225 个文件、童装素材 5 个文件；新工作区没有 `.env` 或证书文件。原位置仅保留 AiToEarn 的 `.env`、微信证书公私钥、抖音上传项目的 `.env` 和 TryPost 的 `.env`，共 5 个受保护文件。

## 使用方式

以后以本目录为唯一自媒体工作区。先读取 `AGENTS.md` 和 `skills/daily-self-media-operator/SKILL.md`，再按任务选择项目和技能；默认生成草稿和可视化预览，用户确认后才进入登录或发布步骤。小红书处理图文，抖音处理视频。
