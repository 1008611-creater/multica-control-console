# 模板：AIGC 批次工作流

## 用途

这是一份可复用的 AIGC 抽卡批次模板。它把一批图片拆成两个部分：

- **Multica 负责管流程**：批次身份、提示词清单、状态、授权门、受控并发进度、人工选图和回执；
- **本地抽卡桥负责做执行**：提交一张图、等待结果、按序列号补下载、校验文件。

Multica 不登录平台、不替用户发布，也不把抽卡桥的运行日志当成唯一事实来源。

## 元数据

- 风险等级：L3
- 责任角色：内容生产
- 把关角色：用户
- 适用范围：需要批量生成、逐张执行、人工选图的 AIGC 任务

## 目标

为一批 AIGC 图片建立可重复的工作流：先免费检查，再等待本批次的当次授权，然后一次提交一张；每张图都留下真实回执，最后由用户完成选图确认。

## 输入

必填配置：

```yaml
batch_id: "缺"
project_id: "缺"
prompt_manifest: "缺"
model: "缺"
aspect_ratio: "缺"
count: "缺"
authorization:
  paid_generation: "awaiting"
concurrency_policy: "max_three_concurrent"
output_directory: "缺"
receipt_path: "缺"
selection_policy: "user_only"
```

还需要：

- 项目状态真源和项目 README；
- 本批提示词清单；
- 抽卡桥能力说明；
- 本批用户要求的尺寸、数量、风格和命名规则；
- 验收条件与失败处理规则。

未知字段写「缺」，不能用默认值补齐。

## 输出

1. 批次配置与免费检查结果；
2. 每张图一条可追溯回执；
3. 当前批次状态；
4. 候选图清单与用户选图记录；
5. 阻塞原因、影响范围和解除条件（如果失败）。

## 状态机

```text
draft
  │ 配置和提示词齐全
  ▼
linted
  │ 免费检查通过
  ▼
awaiting_authorization
  │ 用户当次授权本批付费生成
  ▼
running_bounded_parallel
  │ 保持三个作业槽位；任一作业终态后立即补位
  ├───────────────┐
  │ 全部候选已回收 │ 输入/桥/扣费状态需要人工核实
  ▼               ▼
awaiting_selection blocked
  │ 用户完成选图       │ 补齐输入或完成核实
  ▼               └──────────────► linted / running_bounded_parallel
accepted
```

### 状态含义与进入条件

| 状态 | 人话 | 可以做什么 | 不可以做什么 |
|---|---|---|---|
| `draft` | 还没准备好 | 补批次配置和提示词 | 出图、标记完成 |
| `linted` | 免费检查通过 | 等待授权或修正非付费问题 | 直接调用付费生成 |
| `awaiting_authorization` | 已准备好，等用户点头 | 展示预计数量、模型、比例和消耗 | 自动把历史授权当本次授权 |
| `running_bounded_parallel` | strict three-concurrent execution | immediately refill terminal slots; use authorized failed-item retries when independent items are fewer than three | fewer than three active slots while an executable or retryable item exists; more than three; unauthorized resubmission |
| `awaiting_selection` | 图已回收，等用户选 | 展示候选图和真实回执 | 把候选图写成最终采用 |
| `accepted` | 用户已确认并且回执齐全 | 进入独立的发布准备流程 | 自动发布或代替用户发布 |
| `blocked` | 有明确问题，必须停 | 记录问题和解除条件 | 猜测缺失数据、继续扣费 |

### 允许的状态转换

| 当前状态 | 下一状态 | 必须满足 |
|---|---|---|
| `draft` | `linted` | 配置、提示词、路径和验收项齐全，免费检查通过 |
| `linted` | `awaiting_authorization` | 已确认本批参数，尚未调用付费生成 |
| `awaiting_authorization` | `running_bounded_parallel` | 用户在本次对话明确授权本批付费生成 |
| `running_bounded_parallel` | `running_bounded_parallel` | a successful result or saved failure receipt remains within this batch authorization | unauthorized retry or missing receipt |
| `running_bounded_parallel` | `awaiting_selection` | all planned images have a result, or remaining images are explicitly marked not generated |
| 任意执行状态 | `blocked` | 缺输入、桥异常、扣费状态不明或需要人工核实 |
| `blocked` | `linted` | 缺失输入已补齐，且没有进入付费执行 |
| `blocked` | `running_bounded_parallel` | 缺口补齐，或失败项获得本批授权内的重提条件 |
| `awaiting_selection` | `accepted` | 用户写明选中编号，回执和文件路径复核通过 |

禁止直接跳转：

- `draft → running_bounded_parallel`；
- `awaiting_authorization → accepted`；
- `awaiting_selection → shipped`；
- 未经本批授权自动重新提交同一张图；重提必须保留原始失败回执，并建立新作业号/序列号与 `retry_of` 关联。

## 三道必须分开的门

1. **付费生成授权**：用户是否允许本批调用付费出图；
2. **最终选图确认**：用户从候选图中选哪一张；
3. **发布或对外发送授权**：用户是否要把已选结果发到平台。

前一扇门通过，不代表后两扇门自动通过。

## 免费检查路径

在 `draft` 或 `blocked` 状态可以做免费检查：

- 检查批次字段是否齐全；
- 检查提示词数量、比例、命名和输出路径；
- 检查桥是否在线、接口契约是否匹配；
- 检查回执文件格式。

免费检查不得调用付费生成接口，也不得把检查结果写成“已出图”。

## 单张回执格式

每张图片至少记录：

```yaml
item_id: "C01"
job_id: "缺"
status: "缺"
serial: "缺"
file_path: "缺"
file_sha256: "缺"
width: "缺"
height: "缺"
retry_allowed: false
user_selection: "缺"
notes: ""
```

真实字段缺失时写「缺」。`user_selection` 只能由用户填写，不能由执行角色推断。

## 硬约束

- 付费生成必须有本批次当次授权；历史授权不自动续期；
- While the batch is non-terminal and an executable or retryable item exists, keep three bridge jobs in `running` or `queued`; use authorized failed-item retries to fill short slots; shared browser locks must not downgrade the batch to single concurrency;
- For `queued` or download failure, preserve the serial and try free download first; for confirmed generation failure, preserve the failure receipt and resubmit within authorization; use failed-item retries to fill short slots; a single failure does not pause the batch;
- 能按同一序列号免费补下载时，只补下载，不重新生成；
- 不登录、不代发、不自动发布，不读取或保存 Cookie、Token、密钥；
- 原始生产目录只读引用，候选图不能写成已入选。

## 验收

- [ ] 批次配置包含 `batch_id`、`project_id`、提示词清单、模型、比例、数量、授权状态、并发策略、输出目录和回执路径；
- [ ] 免费检查结果已落文件，且没有调用付费生成；
- [ ] 每个已执行编号都有真实作业号、序列号、状态和文件路径，未知项写「缺」；
- [ ] 状态转换符合本模板，不存在跳过授权或跳过人工选图；
- [ ] 失败编号的每次重提都有授权来源、新作业号、新序列号和扣费状态；不静默无限重试；
- [ ] 用户选图和候选图分开记录；
- [ ] 发布动作仍停在独立的人工授权门；
- [ ] `npm run verify` 通过。

## 失败处理

- 配置或提示词缺失：停在 `draft`，补齐后重新免费检查；
- 免费检查失败：停在 `blocked`，记录具体字段和解除条件；
- 缺少本批付费授权：停在 `awaiting_authorization`，不调用付费接口；
- Bridge offline, browser-lock timeout, or missing authorization: enter `blocked`; site generation failure preserves evidence and uses authorized failed-item retries to keep three slots while executable or retryable work exists; unknown deduction is recorded as missing and never guessed;
- Interpret the bridge execution `status` separately from `result.status` / `resultStatus`. Automatic resubmission requires an explicitly retryable confirmed failure (`retryAllowed: true`) and a known no-charge result (`billed: false` or an explicit zero deduction). Never resubmit `queued`, `receipt_pending`, `download_failed`, `need_login`, ambiguous submit/poll outcomes, or unknown deduction;
- 全部候选没有用户选图：停在 `awaiting_selection`，不标记 `accepted`；
- 发布没有平台最终回执：保持未发布，不写成 `shipped`。

## Multica Issue 正文

将以下正文复制到 Multica Issue，并替换尖括号字段：

```text
你正在执行一个 AIGC 批次工作流。

项目 ID：<project_id>
批次 ID：<batch_id>
提示词清单：<prompt_manifest>
模型：<model>
比例：<aspect_ratio>
数量：<count>
回执文件：<receipt_path>

先完成免费检查并把结果写入回执。检查通过后，停在 awaiting_authorization，等待用户当次授权；没有授权不得调用付费生成。

After authorization, enter running_bounded_parallel: while the batch is non-terminal and an executable or retryable item exists, keep three bridge jobs in `running` or `queued`; refill every terminal slot immediately; use authorized failed-item retries for short slots; unknown deduction or missing authorization enters blocked.

全部候选回收后进入 awaiting_selection，等待用户填写最终选中编号。只有用户确认、路径存在、回执齐全时，才改为 accepted。发布或对外发送另开授权门。

禁止登录、代发、自动发布、读取凭据或把候选图写成最终采用。
```
