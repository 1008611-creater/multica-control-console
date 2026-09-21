# 审计结果汇总

## 1. GitHub 登录

- 网页登录：https://github.com/login
- 当前本机已登录账号：https://github.com/1008611-creater
- 权限范围：repo（读写私有仓库）、read:org、workflow、gist。
- 账号创建于 2026-03-17，目前无组织、无协作者；仓库均为「仅本人 admin」。

## 2. 仓库全景（29 个）

### 2.1 核心产品（私人仓库，有实际业务价值）

| 仓库 | 语言 | 大小 | 最后推送 | 说明 |
| --- | --- | --- | --- | --- |
| niannian-ai | TypeScript | 78.3MB | 2026-09-05 | 念念 AI 本地站点/工作台（含项目、作品、创作指引、Dola 渠道封装），本地 8788 端口 |
| niannian-ai-web | JS/TS | 62.5MB | 2026-08-16 | 念念 AI 视频工作台（sd2.cauai.fun），真实注册登录 + PostgreSQL 任务持久化 + 队列 |
| niannian-ai-canonical-local | JavaScript | 51.2MB | 2026-08-04 | 念念 AI 本地站点 canonical 副本（本地已有 retired 归档） |
| ans-platform | HTML/MDX/Python | 91.6MB | 2026-09-07 | ANS 官网 + AI 原生社区平台（prompts-chat 改造），线上 ans.cauai.fun |
| codex-team-skills | Python/JS | 77.3MB | 2026-09-07 | 团队 Codex skills 库（67 个技能、三窗口工作流、新人上手材料） |
| seedance2 | TypeScript | 16.1MB | 2026-07-15 | Seedance 2.0 周卡创作台 MVP（注册/卡密/额度/任务队列全链路） |
| kqs-api | Go | 10.6MB | 2026-07-11 | KQS API / Sub2API 私有运营部署仓库（Go+Vue+PostgreSQL） |
| nianniannzhixuan | JavaScript | 11MB | 2026-08-21 | dh.cauai.fun 前端镜像副本（童装动作迁移制作台） |
| niannianxuexi | Python | 38.6MB | 2026-08-13 | 念念 AI 提分 / DeepTutor（个性化 AI 学习助教） |
| niannianzhijian | TypeScript | 121.9MB | 2026-08-19 | 念念智剪 / OpenChatCut：本地优先、Agent 原生 AI 视频剪辑 |
| infinite-canvas-hb | TypeScript | 4.2MB | 2026-09-01 | 无限画布（Linux.do 开源项目定制版） |
| niannian-compounding-knowledge | JavaScript | 1.1MB | 2026-08-21 | 念念 AI 复利知识库（知识卡/SOP/三层分发骨架） |
| niannian-stocks | TypeScript | 0.7MB | 2026-08-06 | 股票相关（Vercel 部署过 artistic-vitality） |
| doubao-studio-sanitized-audit | - | 0MB | 2026-08-21 | 豆包工作室安全审计交付包（只含报告，不含源码） |
| ai-native-control | - | 0MB | 2026-08-08 | Codex 与 Hermes 协作的共享事实层 |

### 2.2 公开仓库（可对外展示/开源）

| 仓库 | 语言 | 说明 |
| --- | --- | --- |
| niannianzhijian | TypeScript | 念念智剪（公开，121.9MB，README 为 OpenChatCut） |
| liushubin-portfolio | HTML | 刘曙宾作品集（rebuild-v1.vercel.app） |
| 1111 | HTML | 简历站点（1111-tawny-rho.vercel.app，447.7MB） |
| resume1 | HTML | 简历（resume.lsb0713.online，GitHub Pages 已构建） |
| jianli | HTML | 简历（1008611-i5mp.vercel.app，已 404） |
| doubao-studio | TS | 豆包工作室 fork（上游 dorakoo/doubao-studio） |
| TradingAgents | Python | 金融多智能体框架 fork |
| worldmonitor | TS | 全球情报看板 fork |
| daihuo-ai-employees-skill | - | 带货 AI 员工 Skill 包（公开） |
| keshihua / resume / niannianzhijjian | - | 空壳/占位仓库 |

### 2.3 私人占位/零内容仓库（可归档或删除）

- 111、jianlizuizhongban、desktop-tutorial（0KB 级别）

## 3. 网站可用性（2026-09-08 实测）

### 3.1 可用且有价值

| 网站 | 状态 | 内容 |
| --- | --- | --- |
| ans.cauai.fun | 200 | ANS · 让 AI 永不停转（官网+社区平台，最完整的产品） |
| sd2.cauai.fun | 200 | 念念AI视频工作台（视频生成基础能力） |
| dh.cauai.fun | 200 | 童装动作迁移制作台 |
| cauai.fun / www.cauai.fun | 200 | 刘曙宾作品集（Vercel） |
| rebuild-v1.vercel.app | 200 | 同一作品集（Vercel 备用域名） |
| resume.lsb0713.online | 200 | 作品集（GitHub Pages） |
| 1111-tawny-rho.vercel.app | 200 | AI Agent 产品经理简历（视频生成方向） |
| seedance2-lovat.vercel.app | 200 | 目前显示 Image2 案例库（内容已改版） |
| worldmonitor.app | 200 | 上游公开项目（fork 的线上版） |
| deeptutor.info | 200 | DeepTutor 上游文档站 |

### 3.2 不可用

- resume1-ashen-chi.vercel.app → 404（已删除）
- 1008611-i5mp.vercel.app → 404（已删除）
- nas.mimo.fashion:5001 → 502（服务器在但反向代理挂了）
- demo.sub2api.org → 502
- lsb0713.online、mimo.fashion → SSL 握手失败

## 4. 安全扫描结论

- 扫描了 29 个仓库所有 .env*/密钥/证书/部署配置文件 + 高风险代码模式。
- 命中项全部来自 .env.example 模板（占位符 change-me/replace-with，或空值），未发现真实密钥、密码、DB 连接串或私钥入库。
- 提示：niannianzhijian 等仓库含大量构建产物（121.9MB），协作前建议把 node_modules/dist 加入 .gitignore 并清理历史。

## 5. 本地未同步代码（重要）

E:\codex 下大量目录没有 GitHub 远程，或处于非干净状态，供团队开发前必须先确认归属：

- niannianai/ 下多个分支副本（_clean-doubao 等，dirty 数百~数千文件）
- aisp/ 下 aixtgz、aidaihuo、billing-worktree（均无 origin 或大量未提交）
- archive/niannian-ai-canonical-local-retired-20260708（284 dirty）
- wangzhan/（62 dirty，Cloudflare Workers 相关）
- ppt_work/、paper-design/liquid-logo（上游项目 repo）、local-apps/OpenChatCut-0.2.3

## 6. 团队协作建议（下一步）

1. 建立团队组织（GitHub Organizations），仓库按「可开源 / 仅内部 / 保密」三档迁移。
2. 用组织 Team 批量授权，替代逐个仓库 add collaborator。
3. 优先交给团队的核心仓库：niannian-ai、niannian-ai-web、ans-platform、seedance2、niannianzhijian、codex-team-skills。
4. 治理动作：补 LICENSE、清理大文件历史、把密钥全改环境变量 + .gitignore、写 CONTRIBUTING.md。
