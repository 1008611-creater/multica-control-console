# 模板：AIGC 比赛抽卡

## 元数据

- 风险等级：L3
- 责任角色：内容生产
- 把关角色：用户
- 项目身份：`aigc-contest-draw-v1`
- 通用状态机：[`aigc-batch-workflow.md`](aigc-batch-workflow.md)


## 目标

为 AIGC 比赛准备一批国内版 Midjourney 候选图：先完成提示词和免费自检，用户当次授权后保持三个并发作业槽位出图并回收回执。

## 输入

- `PROJECT_CONTEXT.md`
- `CONSTRAINTS.md`
- `projects/AIGC比赛抽卡/project_state.yaml`
- `skills/第四批-AIGC比赛抽卡/mxai-contest-draw/SKILL.md`
- 用户本批提供的比赛要求、画面清单、比例和数量

## 输出

1. 本批提示词清单：每张含用途、画面、比例、版本和风险词结果；
2. 免费自检结果：桥、脚本和提示词是否通过；
3. 授权后的作业回执：作业号、序列号、图片路径、状态；
4. 待用户 4 选 1 的候选清单。未入选不得写成已采用。

## 硬约束

- 未获得用户当次明确授权前，不得调用付费出图接口。
- 每批只请求一次授权；默认最多 15 张，约每张 6 积分。
- 不登录、不代发、不自动发布，不读取凭据。
- 同一提示词已在跑时必须复用作业，不得为了“保险”重复扣费。
- Queue timeout or download failure preserves the serial and tries free download first; confirmed generation failure may be resubmitted within this authorization; while the batch is non-terminal and an executable or retryable item exists, keep three slots and use failed-item retries for short slots; a single failure does not stop the batch; login failure still stops.

## 验收

- [ ] 引用了项目 ID `aigc-contest-draw-v1`；
- [ ] 免费自检通过，或明确写出阻塞原因；
- [ ] 付费提交前有用户当次授权；
- [ ] 每张图有真实回执路径，缺失项标「缺」；
- [ ] 候选图与用户最终选择分开记录。

## 失败处理

桥离线、代理离线、登录失效、提示词未通过或授权缺失时，输出“阻塞原因 + 缺失项 + 解除条件”。单张生成失败保留原始回执，可在本批授权内受控并发重提交并记录新作业号、序列号和扣费；不得改用其他付费渠道自动补跑。
