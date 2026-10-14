# 《鲸歌计划》30秒悬疑试片与首批生产方案

日期：2026-10-08；项目 whale-pilot-v1。状态：PLAN/BUILD，用户已确认片名、30秒试片，并授权本次最多1000次普通模式v8.2图片生成，允许自由分轮，不再逐批重复索取额度授权。该上限不等于要耗尽，也不等于1000张已生成图片。平台余额/每次消耗尚缺；实际消耗按真实回执记账，未知提交先占用额度，不重提。参考素材上传、视频生成、登录代操作和对外发布未在本次授权中。

## 权威输入与创作边界

重新读取原始DOCX，SHA256：6e5b51fc021eee31c9b06b4d5c609cc237774d7f7c69e613b34bfe8f92f5dc62。原分镜120秒，本30秒版为授权创作压缩，不修改原件。原件片尾为旧片名，当前以用户确认的《鲸歌计划》制作。开篇水域未标明地球/木卫二，保持未定位。人物外貌、船舱布置与器材造型是本轮创作提案，不是原文事实；母图待人工验收，不提前宣称连续性通过。

主张：一段孤独的声音，被另一片海洋回应。前半安静、后半急促；不揭示完整未知物，不加战争和获救结局。主画幅16:9，不裁切原图，不做多格生产首帧。

## 30秒剪辑镜头表

| 镜头 | 秒数 | 画面首帧与镜头运动方案 | 原分镜依据 | 资产依赖 |
| --- | --- | --- | --- | --- |
| T01 | 0–3，3秒 | 阴云薄雾海面，贴近水面的缓慢推进；不出现船或鲸 | S01 | D04 |
| T02 | 3–7，4秒 | 幽暗深蓝水中巨大模糊远影，微量粒子；缓慢下沉，远影不能清晰显形 | S01 | D01 |
| T03 | 7–11，4秒 | 兰伯特在兔子洞号监听，先不做震惊表情；轻推近侧脸，耳机轻响 | S02 | A01、D02、A05 |
| T04 | 11–14，3秒 | 左小月侧脸看木星档案，目光专注；侧移露出监视器，声音先引出另一片海 | S04 | A02、A03、A06 |
| T05 | 14–17，3秒 | 木卫二冰面与小探测器；接近冰壳，撞击可在声音/切点发生，不把完成撞击画进首帧 | S05 | D05 |
| T06 | 17–21，4秒 | 小探测器刚入冰下黑海，单束冷白光、冰壳重压；镜头随探测器缓降，远处没有可辨生命 | S05 | D03 |
| T07 | 21–24，3秒 | 兰伯特轻微抬眼，插入仪器空白屏；两段信号开始吻合，0.8秒切仪器后回侧脸 | S06 | A01、A04、A05 |
| T08 | 24–28，4秒 | 黑水中冷银侧翼局部在画外将入画；急促掠过后硬切全黑，不露整体 | S07 | D06 |
| T09 | 28–30，2秒 | 黑底片名《鲸歌计划》，问题“它在寻找谁？”可单独试；一声低频尾音后静默 | S11、S12 | 后期文字/声音，不消耗图额度 |

总长3+4+4+3+3+4+3+4+2=30秒。运动与声音只是视频阶段方案，本轮不调用付费视频或音频。临时文案：“它歌唱，没有同类听得见。”→“冰层之下，另一片海洋。”→“这个频率……竟然完全吻合。”，前两句按原分镜内容缩写，另列为剪辑提案。52Hz信号作为剧情音效，不将科学断言用于真实宣传文案。

## 资产、提示词与首轮

统一冷钢蓝、稀疏冷银、小面积仪器暖光、克制写实，主体在单帧内可供运镜。先用D01/D02/D03各2次（6次请求）做风格锚点；检查是否单帧、可读、无完整普通鲸轮廓、空间可信和可运动。再进入D04–D06及A01–A06各2次（18次请求）。首波总24次，参数保存在下方清单，不以固定seed保证人物一致性。候选脸不合格先补母图，不盲目扩展大量人物镜头。

图片保存：E:\Multica-Control-Console\mj-automation\output\whale30-20261008。运行额度与提交记录：E:\Multica-Control-Console\mj-automation\run\whale30-20261008。未设置supent路径，不猜测或上传。已存在的其他项目原图保持原处；用复制素材功能前先确认目标。

提示词正文不含平台 -- 参数；明确设置v8.2、普通模式、16:9、raw以及逐项seed/stylize/chaos。提示词质量描述落到画面，人物、光线和运动前状态。文字、片名和精确波形不交给MJ乱画，本轮不做未经授权的本地像素编辑。

### D01 幽暗海水与巨大远影（T02）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. An underwater extreme wide shot in unlocated abyssal water. A tiny sparse trail of suspended particles crosses the near foreground. Far behind it, one enormous indistinct asymmetrical dark mass fades into blue-black water. Its shape is unreadable, neither a recognizable whale nor a visible creature anatomy. No eye, jaw or mouth is revealed. Almost all of the frame is negative space, just enough diffuse silver backscatter to sense impossible scale. The mass is still distant, not passing the camera yet.

参数：v8.2，普通，16:9，raw=true，stylize=90，chaos=5，seed=810801 / 810802。

### D02 兔子洞号监听船舱（T03）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. Inside the cramped research cabin of the vessel Rabbit Hole, an empty listening station occupies the left third, an aged steel desk with a compact acoustic receiver, wired over-ear headphones hanging at the desk edge and a small dark glass monitor. One circular porthole on the right shows dull grey water. Cold instrument glow and one dim amber task lamp, practical patched cabling, consistent human-scale geometry, view from the doorway at seated eye height. No readable screen content and no person, a reusable empty set plate.

参数：v8.2，普通，16:9，raw=true，stylize=70，chaos=3，seed=810811 / 810812。

### D03 木卫二冰下探测器（T06）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. An extreme wide underwater view beneath the thick ice shell of Europa. A tiny unmarked scientific descent probe occupies the upper-right third, its one narrow cold-white searchlight reaches down into an immense empty black ocean. The underside of pale fractured ice forms a heavy roof across the upper edge. Fine illuminated particles near the beam and almost total darkness beyond it, no visible animal or structure. The probe has just entered the water and has not reached the abyss.

参数：v8.2，普通，16:9，raw=true，stylize=90，chaos=5，seed=810821 / 810822。

### D04 阴云薄雾海面（T01）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A low ocean-level wide view of an unlocated grey sea beneath dense overcast sky. Thin fog hangs above long slow swells, a low horizon at the upper third. One modest swell in the foreground, empty middle distance, distant horizon barely visible, dim silver light breaking through a narrow seam in the clouds. No boat, land, animal or spectacle, a quiet shot before the camera descends under the surface.

参数：v8.2，普通，16:9，raw=true，stylize=65，chaos=3，seed=810831 / 810832。

### D05 木卫二探测器抵达冰壳（T05）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A cinematic orbital view of Europa, its white-blue fractured ice surface filling most of the lower frame. A tiny physically plausible compact unmarked scientific probe approaches from upper right towards a dark fracture region, Jupiter only a distant softly lit partial disk at the extreme background edge. Clean scale relationship, cold reflected light, no fire in vacuum, no impact yet, no cracked opening yet. The first frame of a controlled descent towards the ice.

参数：v8.2，普通，16:9，raw=true，stylize=90，chaos=4，seed=810841 / 810842。

### D06 未知存在冷银侧翼局部（T08）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A close underwater view in dark water. Only one broad curved cold-silver edge of an unidentified enormous submerged object is visible entering at the far right. Its torn surface catches a single restrained narrow highlight; everything beyond that fragment disappears into black water. No complete body, whale head, eye, animal tail or recognizable machine design. Sparse foreground particles, the object has not yet swept across the lens, motion-ready suspense composition.

参数：v8.2，普通，16:9，raw=true，stylize=80，chaos=3，seed=810851 / 810852。

### A01 兰伯特身份候选（T03,T07）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. Identity casting portrait of Lambert, an invented weary ocean-acoustics researcher, proposed appearance rather than a locked identity: a man in his early forties with a lean angular face, short dark brown slightly disordered hair, a faint stubble beard, tired grey eyes, weathered navy canvas work jacket over a simple grey knit shirt. Single waist-up three-quarter portrait, sitting still, hands out of frame, calm intent expression before hearing an unexpected sound. Simple dark blurred cabin background, natural pores, modest cold side light, no glamorous fashion styling.

参数：v8.2，普通，16:9，raw=true，stylize=55，chaos=3，seed=810861 / 810862。

### A02 左小月身份候选（T04）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. Identity casting portrait of Zuo Xiaoyue, an invented planetary-science researcher, proposed appearance rather than a locked identity: a Chinese woman in her early thirties, straight black jaw-length hair tucked behind one ear, oval face, dark eyes, wearing a plain charcoal knit top with a faded slate-blue overshirt. One waist-up three-quarter portrait, hands out of frame, attentive and quietly skeptical expression. Simple dark blurred research room background, cool monitor side light with a faint warm rim, natural skin texture, no glamour posing.

参数：v8.2，普通，16:9，raw=true，stylize=55，chaos=3，seed=810871 / 810872。

### A03 科研档案工作站母板（T04）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A dark compact planetary-research archival room, no person present. A single ageing scientific monitor dominates the left half of an uncluttered desk, showing an unmistakable softly rendered Jupiter disk and swirling ochre cloud bands without text. Nearby modest cables and an old hard drive, concrete-grey and matte steel surfaces, faint glass reflections. Right half left open for a future seated researcher, cold blue room shadows and a very small amber indicator, no institution signage.

参数：v8.2，普通，16:9，raw=true，stylize=70，chaos=3，seed=810881 / 810882。

### A04 监听仪器道具近景（T07）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A tight close-up of a compact worn acoustic receiver on the same modest research-boat desk. Its recessed monitor is dark green-blue glass with a faint empty horizontal center line, deliberately blank for later waveform design. Practical knurled knobs and two subtle indicator lights, fine salt wear on matte charcoal metal, a headphone cable leaving lower left, physically plausible perspective and straight screen edges. No digits, letters, dramatic neon waveform or hands.

参数：v8.2，普通，16:9，raw=true，stylize=55，chaos=2，seed=810891 / 810892。

### A05 船舱内兰伯特中近景候选（T03,T07）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A single man with proposed Lambert casting, early forties, short dark brown slightly disordered hair, faint stubble, weary angular face, navy canvas work jacket and grey knit shirt, sits at the left side of a cramped research cabin. Wired headphones rest over his ears. He is leaning slightly towards a dark acoustic receiver but has not reacted yet, restrained alert posture, hands mostly below desk edge. Circular porthole with dull grey water at right, one small amber task lamp, coherent cabin proportions and an unobstructed profile silhouette.

参数：v8.2，普通，16:9，raw=true，stylize=65，chaos=2，seed=810901 / 810902。

### A06 档案站左小月侧脸候选（T04）

Photorealistic restrained science-fiction suspense film still, physically believable materials, cold steel-blue shadows, sparse silver highlights, deep readable blacks, subtle fine film grain, one continuous cinematic frame, no lettering, no logo, no border, no split screen. A single Chinese woman with proposed Zuo Xiaoyue casting, early thirties, jaw-length straight black hair tucked behind one ear, charcoal knit top and slate-blue overshirt, sits on the right of a dark research desk. Left profile close-up, eyes focused on a monitor positioned to camera left, face not yet turning. Dim cool monitor reflection in her eyes, natural skin, the monitor frame and a soft partial Jupiter disk visible at the extreme left edge. Quiet curiosity rather than overt fear, no text or signage.

参数：v8.2，普通，16:9，raw=true，stylize=65，chaos=2，seed=810911 / 810912。

## 阶段与验收

责任人Codex：DEFINE已由用户给定用途与额度；PLAN产出本镜头表及24项首波；BUILD校验普通模式失败闭锁、生成批次草稿与额度账本；VERIFY免费参数校验、Node/Python定向测试、真实桥归属、生成模式回读；REVIEW目视新候选并关联真实serial、文件完整哈希；SHIP仅交付图片与清单，不自动发布；RETRO按未补镜头排下一轮。以真实回执和原图存在且解码、目视检查为条件，不拿模拟成功替代。

普通模式旧代码失败只告警，本轮改为确切读取选中态，不能确认时MODE_NOT_APPLIED且不点击生成。先冷更新安装中的这一适配器并保存程序备份，不清理用户资料。不改变已运行任务；桌面重试修复由另一已有准备任务完成，本轮不同时修改desktop/Program.cs。

既往工具禁止访问localhost控制页的浏览器政策仍有效，不通过Playwright截图、CDP或其他浏览器规避；实际生产只使用用户授权的软件接口，若执行该路径也被拒绝，就保存批次与额度并说明阻塞，不另换供应商或执行绕过。遇到未登录呼唤用户人工登录，不绕过账户检查；未知提交停止后续派发和重新提交。

批次草稿：projects\whale-pilot\batches\whale30-wave1-20261008.json（6项）；projects\whale-pilot\batches\whale30-wave2-20261008.json（18项）。完整机读提示词：projects/whale-pilot/prompts/whale30-first-wave-20261008.json。下一步在未发现未决运行并确认程序匹配后，先运行第一批；满足质量门槛再运行第二批。最终审美验收由用户决定。


## 实际执行回执与当前影响

24项提示词免费校验通过；软件中已保存wave1（6项）和wave2（18项）两个validated批次，无自动提交。开始前工具审核拒绝了“停止已登录共享窗口并启动首批”的整条命令，仅返回blocked by policy，命令未执行；没有用其他工具重试同一动作或换供应商。首批6次作为手动启动保留额度记账，保留不等于消耗；尚未确认平台提交，本轮通过工具新增生成0次。剩余未保留额度994次，平台余额未知。

本机正式版仍2026.10.08.2，适配器增加本地未发行普通模式保护，原文件已备份且更新时无生成进程。36项Node、31项Python通过，工程verify通过；模式读取仍未经过真实平台生成回执验证，不能把单元测试称为平台可用性。软件健康检查通过，无运行和待核查项，之前共享窗口状态为loggedIn=true（状态快照，不代表生成权限或模式采用）。

请用户在软件中手动开始首批6项；随后只读核对serial、版本/模式真实回读、生成/下载状态和文件，逐张目视质量评估。工具拒绝不通过定时任务/另一对话/脚本代理重试。未解除执行限制时，持续巡检只做只读进度、候选审查和免费批次准备；第二批先保留为草稿，不自动启动。


免费额度边界检查5项通过：1000上限可核验、1001拒绝、计数不符拒绝、重复批次拒绝、真实首批6次预留一致。持续任务已启用每小时只读巡检；不会自动重试被拒生成，未新增真实图片。实际平台模式与回执等待用户手动开始后核验。


## 2026-10-08继续修复：主作业回执与只读对账

已修复普通模式/版本核验结果只写台账、不进入主作业结果的缺口：适配器返回requestedMode/appliedMode/modeVerified、requestedVersion/appliedVersion/versionVerified，runner逐项写入持久化结果；缺字段保留null/false，不从“请求了v8.2”推断实际采用。没有产生平台调用的模拟合同测试验证透传，真实平台回执仍待首次生成。

scripts/whale30_production.py增加只读reconcile入口：核对本项目两个批次、尝试历史和持久化JSON回执；作业号去重，真实重试另计，文件逐一计算哈希，不读取浏览器或日志。预留、已提交、待核查、扣费已知、文件存在分别展示，文件存在不等于图片解码或人工验收通过。拒绝负数/布尔额度、重复批次、超额、异项目批次、越界图片路径。检测到未预留额度的人工启动只告警，不补造授权。它是只读审计，不宣称能拦截所有软件手动入口。

自动start入口在任何HTTP之前检查blocked_by_tool_policy，存在该标记立即停止，避免后续定时任务或脚本误重试被拒操作。此标记不能以普通文件编辑伪造解除。此次没有调用start/resume/browser-stop等执行接口，也没有换供应商。

37 Node + 31 Python + 12额度/回执检查通过，npm run verify通过。两个修复脚本在确认无运行任务及生成进程后备份并复制到本机，相应证据receipt-chain-install-verification.json保存在本次run目录；正式公开发行仍2026.10.08.2，本机包含未发行补丁，不宣称包内字节仍完全相同。

真实只读对账报告：E:/Multica-Control-Console/mj-automation/run/whale30-20261008/production-status.json。首批6项、第二批18项仍pending；已提交0、未知提交0、成品0，6次预留不等于扣费，994次尚未预留。执行限制为未完成事项，生成模式实际采用与真实成图尚未验证。人工开始首批后继续按真实回执与图面检查，不再更改运行中的生成脚本。


## 2026-10-08 生成链路故障修复与免费回归

本次按用户“查问题并解决”的指令修复本地适配器和批次状态汇总，不启动生成。历史9月批次中重新核对5张现存图片哈希与回执一致；10月7日至8日三张测试实际提交3次、平台失败3次、成品0张，不能称完整生成验收通过。本轮电影两批仍为validated，24项pending、提交0。

已定位并修复：

- 等待结果原先发现serial后至少再等60秒，超预算后可能返回“生成完成”。现在使用单一截止时间；仅本次卡片下载信号证明完成，超时保留serial及待核查状态。
- 出现多条新serial原先选数值最大值。现在多条同时出现返回关联不明，不选择最新记录；一旦绑定serial就保持不变，页面丢失也不换任务。
- 图片捕获原先还会接收非outputs图片响应和没有来源标识的全页Blob，预览失败会点击全页第一张图片并抓取全页详情。现在只接受路径中文件名精确匹配目标serial的outputs原图响应，移除这些全页下载兜底；匹配失败明确报错。格式与字节校验继续保留。
- waitForFunction两处将timeout放到第二个参数，实际成了页面函数入参。已按本机Playwright类型声明改为第三个options参数。
- 平台明确失败但费用未知时，队列原先展示笼统待核查。现在保留平台失败理由，状态为failed，费用继续未知，不据退款文字推断扣费数值或自动重试。模式和版本的请求、回读、核验字段从主回执保留到队列摘要。

免费验证：37项Node、34项Python、12项额度/回执检查及npm run verify通过。新增离线回归包含9组适配器场景及2组队列检查，覆盖完成信号、等待截止、多serial歧义、页面消失、历史文案干扰、原图路径精确匹配、禁用全页抓图、失败/费用区分和核验字段保留。测试使用内存DOM及隔离临时目录，无真实浏览器或平台调用。

本机安装的两个程序文件已备份后同步，源码和安装hash一致；两个电影批次及授权账本更新前后hash相同。公开基础发行仍2026.10.08.2，本次是本地未发行补丁，不宣称GitHub包已更新。适配器供下一次runner加载；已运行Python服务尚未重启，队列补丁等待下次服务重启生效。未停止浏览器，不改原图、登录资料或执行拒绝标记。

复核证据：E:/Multica-Control-Console/mj-automation/run/whale30-20261008/adapter-regression-repair/install-verification.json。责任人Codex完成源码BUILD、离线VERIFY和改动REVIEW，本机程序文件交付；运行中的队列加载及真实平台生成验收未完成。平台为什么返回任务提交失败/已失效仍缺上游原因，不能用上述本地修复宣称已解决平台故障。

额外的版本最终回读增强命令曾被工具审核拒绝，仅返回blocked by policy，未执行，也未绕过重试；该增强不计入本次已完成项。先前启动生成被拒的限制仍在，本轮新增生成0次。


## 2026-10-08 第二轮修复：排队终态与参数预检

用户要求继续修到正常产出；责任人Codex将真实平台提交、原图落盘解码和内容核查作为最终进入SHIP的条件。目前执行限制仍存在，不能把离线测试代替产出，也不能通过服务重启或其他工具重试已被拒绝的生成动作。

本轮发现并修复两个独立缺口：

- runner已经结束、回执resultStatus=queued时，批次原先无限保持running并占槽。现在转result_pending、保留serial、释放本地槽并暂停批次；服务重启后仍保持暂停，不自动重新提交。外层本地作业真正running/queued时继续等待，两种情形分别验收。
- params-json原先在生成完成后才JSON.parse，坏输入可能在已经发生生成后产生异常回执。现在在打开浏览器或派生后台作业之前校验对象类型与JSON格式，返回bad_request、submitted=false、billed=false；拒绝数组、null、标量和语法错误。合法参数的原有透传不变。

新增模拟测试覆盖10种非法输入/执行模式组合，并核实从未触发fixture launch或创建后台结果；队列测试覆盖终态排队暂停、重启不重复派发和真实本地作业继续占槽。38项Node、36项Python通过，均无真实浏览器或平台调用。

程序mj_run.js及batch_queue.py已在确认无活动、未决与生成进程后备份同步本机；两批任务及额度账本hash保持不变。证据：E:/Multica-Control-Console/mj-automation/run/whale30-20261008/queue-and-preflight-repair/install-verification.json。runner下次执行加载修复；Python服务尚未重启，不能声称运行队列已加载新代码。

项目README及project_state.yaml原先仍写未确认电影、未授权，与本对话和真实授权账本矛盾。已纠正为确认《鲸歌计划》30秒、普通normal/v8.2、本次最多1000次；仍标blocked及真实提交0成图0。不移除本机blocked_by_tool_policy标记，不以修改元数据伪造解除执行拒绝。

公开平台帮助及更新页面未提供“任务提交失败/任务已失效”的具体上游根因，无法据此修复平台服务或推断会员权限。最后真实验收仍未执行，现阶段尚未达到正常生产目标；本轮新增生成0次。


## 2026-10-08 持续目标核查：完整提示词与单次提交

本轮目标仍是正常产出，尚未达到；上一轮属于实际代码和安装修复进展，本轮再次以当前服务及文件核查，不将历史通过结果当成当前出图证据。当前桥进程257848启动于2026-10-08 13:32:26，早于队列补丁写入，明确仍需服务重载；不通过其他启动通道绕过既有工具启动拒绝。

新增修复两处提交链路缺口：fillPrompt原先只要求回读长度达到20字符，旧内容、截断正文或丢失末尾seed/stylize均可能通过。现在比较完整字符串（仅统一CRLF/LF），最多重填3次，仍不一致返回PROMPT_NOT_APPLIED且确认未提交。clickGenerate原先把点击异常吞掉并继续尝试下一按钮，一次点击若已到达平台但回复丢失会导致重复点击；现在只选择一个可见可用按钮，最多点击一次，异常返回SUBMISSION_UNCERTAIN、submitted未知，不重试其他按钮。确实没有可用按钮时返回GENERATE_UNAVAILABLE、submitted=false及billed=false。

验证：38项Node、36项Python、12项额度/回执检查通过；离线适配器案例由9组扩展到18组，新增截断提示词、同长度错词、重新填写恢复、换行规范化、成功单击、禁用按钮、点击异常不二次提交，以及generate主流程费用/提交证据合同。使用内存DOM、模拟按钮和隔离进度文件，无实际浏览器、提交或付费。

适配器已在本机无活动/待核查/生成进程时备份同步，安装hash与源码一致；两批任务和授权账本hash未变。证据：E:/Multica-Control-Console/mj-automation/run/whale30-20261008/prompt-submit-repair/install-verification.json。适配器供下一runner加载，队列仍等服务重载。执行拒绝标记未改变，真实生成仍0，不能标记完成或声称正常生产。


本轮补充：已点击按钮只表示尝试发出请求，不证明平台受理。原先点击成功即_submissionConfirmed=true；现在仅在waitForResult观察并唯一关联到本次新serial后确认提交并切换platform_generating阶段。点击成功但无serial的超时回执保持submitted未知、billed未知、retry_allowed=false；新增主流程回归覆盖该合同。离线适配器案例最终19组，38项Node、36项Python、12项额度检查通过。安装hash与源码一致，任务及授权账本hash未变。真实产出目标仍未完成，未停止或重启受限服务、未调用生成。


## 2026-10-08 当前服务下线核查

核查时间：2026-10-08T18:02:43+08:00。本机桌面和server.py桥进程未找到，8765无监听，真实GET /health返回WinError 10061。此前health正常的记录已过期；目前不能使用工作台服务，退出原因缺。Windows Application近6小时没有符合Multica/Python条件的错误事件，这不足以证明是人工关闭，也不能排除未登记的崩溃。

安装Python的FastAPI/Uvicorn/Pydantic导入、两份Node脚本语法、server.py及batch_queue.py AST通过。三份生成修复文件与源码hash相同；3项免费回归（19组离线适配器场景）通过。首批6项、第二批18项仍pending，尝试0、作业0；授权账本确认提交0、成品0，原图目录0文件，三个受保护hash未变。

未执行服务启动、停止浏览器或生成；既有工具拒绝仍未解除，未更换执行工具或修改拒绝标记。当前完成的是故障核查和状态纠正，正常生产仍未完成。证据：../../mj-automation/run/authority-20261008/service-offline-verification.json。


## 2026-10-08 交互审批配置排查

按用户“我不知道怎么解除限制，你去解除”指令检查个人Codex权限配置。本机原设置为sandbox_mode=danger-full-access及approval_policy=never，并非工作区只读。个人requirements.toml和本项目.codex/config.toml不存在；这不证明不存在云端或会话策略。此前工具只给出blocked by policy，没有具体审核规则，不能据never推定全部拒绝的根因。

参照OpenAI配置参考，已将个人approval_policy从never改为on-request，恢复受支持的交互审批入口；保留其余所有字段及既有审核，TOML回读和完整对象比较通过。没有新增allow规则、关闭审核、修改授权账本或删除软件内的拒绝记录。证据：../../mj-automation/run/authority-20261008/approval-prompt-config-repair.json，仅记录权限字段，不保存配置全文或凭据。

配置已保存，不代表当前会话已经重载或此前拒绝解除。当前工具没有修改运行中会话权限菜单的接口；需要客户端重新加载设置并在权限菜单选择请求批准后，才可经正式审批继续生成。本轮未启动服务、浏览器或付费生成，实际出图恢复仍未验收。官方参考：https://developers.openai.com/codex/config-reference 与 https://developers.openai.com/codex/security 。


## 本次MJ软件维修与单次试抽准备（2026-10-08）

用户当前指令为“把我的mj抽卡软件修好 抽卡一下”；当前只准备一次试抽，不启动原6项/18项批次，不修改此前授权账本或执行拒绝记录。风险L3（本机程序交付与浏览器停止安全边界），责任人Codex，单人实现与自审。输入为PROJECT_CONTEXT.md、CONSTRAINTS.md、项目状态/README、context-pack、acceptance、ADR 0011及真实本机接口；不读取凭据、浏览器档案或运行日志，不编辑原图。

| 阶段 | 输入 | 产物与进入条件 | 责任人 |
| --- | --- | --- | --- |
| DEFINE | 软件离线、未部署恢复代码、用户单次试抽指令 | 服务可用、旧状态不冒充当前登录，试抽单独记录；已定义 | Codex |
| PLAN | 已安装程序、回归测试、无运行任务的真实状态 | 先备份显式程序文件再补装，保护原批次及账本；已定义 | Codex |
| BUILD | 现有桌面恢复源码、browser状态接口 | 构建现有恢复源码，新增心跳时效及协作停止；已实现 | Codex |
| VERIFY | 隔离测试、本机HTTP和文件哈希 | 38 Node、44 Python、28桌面检查通过；服务及四份页面资源HTTP 200，视觉与真实出图仍未验 | Codex |
| REVIEW | 实际差异、旧PID所属进程、授权边界 | 旧PID不得强杀、过期登录不作当前证据、不新增生成；已自审 | Codex |
| SHIP | 构建EXE和server.py | 本机3份程序文件备份后安装并哈希核对；公开发行不变；仅软件本地交付完成 | Codex |
| RETRO | 当前接口、单次草稿、执行限制 | 本节及运行证据；真实生成未完成，项目继续blocked | Codex |

本机此前没有Multica/桥进程且8765拒绝连接；安装EXE为凌晨构建，桌面源码副本也未包含当前恢复修复。现已用现有通过28项合同检查的源码构建并补装EXE及Program.cs。服务正式启动后发现旧登录误报，随后修复server.py；在确认无运行、未决或可派发批次后通过维护接口退出桥，由桌面恢复并加载补丁。重载后health.runtime.ready=true，browser.running=false、loggedIn=false、loginState=unknown，原两批仍validated、pending，尝试为0。软件显示旧登录的问题已修复；平台此前生成失败的原因仍缺，不宣称正常产出已恢复。

单次草稿：mj-repair-one-20261008，界面名称“MJ修复验收：仅试抽1次”。沿用首波D01-V1的幽暗海水与巨大远影提示词及16:9/v8.2参数，并发1，目标E:/Multica-Control-Console/mj-automation/output/mj-repair-one-20261008。仅通过本地validate/create保存，authorization.paidGeneration=false、attempts=0、无jobId、无成图；未调用start、resume、浏览器登录或平台生成。用户的当前一次试抽指令已收到，但历史自动生成审核拒绝仍未解除，不能以新批次或换工具绕过。用户可在软件中本人登录并选择此单项进行试抽，或待客户端正式审批条件恢复；随后以平台回执和原图解码核查结果。

证据和程序回滚：E:/Multica-Control-Console/mj-automation/run/whale30-20261008/desktop-recovery-install，包含Multica.exe.before、Program.cs.before、server.py.before及installation-verification.json、browser-state-installation.json、runtime-verification.json。回退只恢复这3份程序文件，须先确认没有活动任务；不恢复或删除任务、账本、浏览器资料及原图。安装前后原两批、授权账本和execution-limitation共4份文件哈希相同；未修改拒绝标记。公开基础版本仍2026.10.08.2，未提交、发布或上传。既有MSB3277构建警告保留，构建成功；真实页面视觉和付费出图未验。


## 2026-10-09：最新100次授权与登录门槛

用户明确要求“对的 给你100次额度 去抽吧”。本次以100次为硬上限，旧1000次授权不叠加；普通模式normal/v8.2、现有MJ渠道与鲸歌候选范围不变。先核对一次实际生成，再逐波质量检查，不为耗尽额度盲抽；提交状态不明、扣费不明不自动重试。无需再向用户索取同一额度授权，用户只负责本人登录与最终审美验收。

当前真实接口发现首波已于2026-10-09 01:20:17（北京时间）开始，D01-V1已返回need_login、submitted=false、billed=false，原图为空、批次暂停；这一次启动并非本轮Codex发起。原单次试抽草稿仍validated、尝试0，未重复启动。已通过现有批次item/login正式接口打开实际共享档案登录窗口；未自动填写凭据、未读取浏览器档案。登录状态核对仅使用软件状态接口，starting与旧loginState不作为已登录证据。

新本机授权记录：E:/Multica-Control-Console/mj-automation/run/mj-authorized-100-20261009/authorization.json；总额100，预留首波6项，当前平台受理0（现有唯一尝试回执确认未提交），实际积分扣除缺。原额度账本和execution-limitation保持原状。之前提权请求被Never拒绝只证明不能请求提权，不足以证明普通调用被拒；本轮普通执行读状态及打开登录窗口成功，尚未发起付费resume。登录准备回执保存为同目录login-window-response.json。

阶段：现有修复已交付；本次生产处于VERIFY等待本人登录，SHIP的真实产出条件尚未满足。无需再问费用授权；登录核验后使用正式resume入口且paid_confirmed=true。若执行接口明确拒绝则保留真实回执，不改拒绝记录、不换工具绕过。


登录窗口启动核查补充：控制器PID 373284启动后持续停在starting，未真正取得浏览器锁。读取明确的运行互斥锁（不读取浏览器档案或日志）发现其pid=26348、startedAt=2026-10-03；Windows同PID当前为Autodesk GenuineService且启动于2026-10-06，锁心跳超过120秒，生成队列无active，证实PID复用。实际恢复仅把安装run/mj-browser.lock移动到新授权目录mj-browser.lock.stale-pid-reuse.before，字节SHA-256一致；未杀进程、未删锁备份、未修改政策或费用账本。恢复证据stale-lock-recovery.json。原等待控制器于北京时间2026-10-09 01:26:17取得新锁，状态接口随后running=true、status=unknown、loggedIn=false，心跳每秒更新。已打开真实窗口仍不证明本人完成登录，不自动恢复生成。


本次正式恢复：北京时间2026-10-09 01:27:38，现有登录接口实时返回running=true、loggedIn=true、status=logged_in，无需用户重复回答或追加费用授权。01:28:01在本次100次授权且预留首波6项、无其他active、原批次仅pending/login_required的条件下，以普通执行调用POST /control/batches/whale30-20261008-wave1/resume（paid_confirmed=true）成功。服务自行协作关闭登录控制器释放档案锁；没有自动填写任何凭据。批次进入running，D01-V1获得新作业号并进入preparing，旧need_login尝试保留。这里证明普通自动执行可用，不能再把此前提权申请Never拒绝当作当前自动生成被禁；旧审核文件保持不动。恢复响应与当前状态分别保存在本次授权目录wave1-resume-response.json及wave1-current-status.json。尚无平台受理、费用和原图证据；后续仅据真实结果更新。


## 2026-10-09 正式审批恢复及真实登录阻塞

本轮权限环境已切换为managed/workspace-write，并成功经require_escalated正式审批启动已安装工作台。真实GET /health为200、ok=true，安装根正确；不再把旧Never错误或此前拒绝当作当前执行限制。

在确认首批6项validated、attempts=0、无未决作业、安装源码hash一致之后，经单独正式审批执行approved-wave1-recovery.py。复用原先6次预留，不重复扣减额度；旧拒绝记录保持原样，账本仅记录本次已获审查的恢复执行。批次已running并派发第一项；真实终态为need_login、submitted=false、billed=false，批次自动paused，剩余5项仍pending，原图0。当前卡点为人工登录，不是工具审批。已打开该任务对应登录窗口并呼叫用户，尚未代登录、上传或发布。

真实运行同时暴露弹窗清理重复点击68个控件、三轮共204次计数，不能将此视为204个真实弹窗。原实现全页模糊文本、force点击和点击失败仍计数，容易碰到无关关闭控件并浪费等待。已改为可见对话框/活动窗口内查找、精确关闭文本、登录与费用窗口保留、每个容器最多单击、无效果不报成功、最多8秒/12容器/3轮；取消全页文本和遮罩角落点击。

新增4组免费离线回归覆盖广告关闭、登录保留、常驻按钮不反复点击、点击异常不重复；共23组适配器场景及3项定向Python测试通过。首次沙箱测试因临时目录权限失败，按正式审批在沙箱外重跑通过，没有换工具绕过。待同步安装并完成其余验证；真实出图与原图视觉验收仍未通过。


普通执行首项最终返回mode_not_applied，明确submitted=false、billed=false；这证明真实阻塞是软件模式选择而非当前工具审批。通过现有runner的免费probe增加仅模式相关控件诊断，实际观察到普通/快速按钮为control-item，选中项含control-item-selected及control-item-active。selectMode现在识别control-item并只采信control-item-selected（不单独采信active），仍限“模式选择”所属组、唯一目标、点击后及最终回读一致。补充3项DOM合同测试分别覆盖快速切普通、只有悬浮active拒绝以及双选拒绝。

runner新增只检查模式的mode-check维护入口，内部仅选择版本和normal模式、记录核验结果，明确submitted=false/billed=false、立即返回，不调用generate；新增独立模拟适配器合同检查。最终42 Node、44 Python测试通过，Node语法检查和程序安装哈希一致。实际免费mode-check返回ok=true、normal verified=true、v8.2 verified=true、submitted=false、billed=false，证据本次授权目录mode-check-live.json。只修改mxai_adapter.js、mj_run.js及production_machine.test.mjs；公开发行未更新。备份为mxai_adapter.js.before-mode-fix、mj_run.js.before-mode-fix，安装记录mode-repair-installation.json；readonly诊断此前runner另有before-mode-diagnostic备份。

实际免费验证通过后，只有在旧首项明确failed/mode_not_applied、submitted=false、billed=false且没有活动任务的条件下，按本次100次授权调用既有resubmit（paid_confirmed=true、confirm_repeat_charge=true）及resume。没有改旧状态为pending或删除失败回执，API正常保留attemptHistory。为保守计入一次本地未提交尝试，reservedRequests由6增至7，仍小于100；未知结果不重提的规则不变。响应存于mode-fix-resubmit-response.json、mode-fix-resume-response.json，新首项进入running/preparing，真实平台序列号、扣费及原图仍待回执。


## 2026-10-09 广告与输入修复后的免费验收及恢复

模式修复后首项第三次本地尝试在提示词输入阶段被公众号广告遮挡，回执exception、submitted=false、billed缺，原图0。保留原回执及关联，不把未知扣费写成0，不自动重抽此项。

真实诊断发现精确公众号广告的标准header关闭按钮宽高0，DOM点击无效果；真实可见关闭控件为.csd-dialog-close .mj-close。适配器只在全文精确匹配“关注公众号获取MXAI绘画中文站最新资讯和福利”的窗口内，点击非禁用且可见的明确关闭控件；未知内容、登录、充值窗口不处理。输入focus限时从2秒改10秒，广告晚到时仅在确证关闭后重试focus一次，不重试生成。48 Node、44 Python回归通过。

已备份安装程序并核对源码字节一致。免费实机prompt-mode-check-final-live.json确认ok=true、promptVerified=true、normal/v8.2均verified=true、dialogs为空、submitted=false、billed=false；没有生成调用。首项D01-V1通过正式skip保留原作业，不重提交，随后正式resume执行其余首波5项；没有新建重复批次，无需追加100次费用授权。授权仍预留7/100，旧未知扣费保持缺。生产实际结果须以新平台回执、原图下载解码和目视证据为准。

补丁回滚：先暂停派发并确认无活动作业，只恢复本次授权目录内adapter及runner的before程序备份，不覆盖任务、费用账本、浏览器档案和原图。当前责任人Codex；处于VERIFY，只有真实成图可进入本机交付验收，不代表对外发行。


### 本次真实试抽终态（北京时间2026-10-09）

D01-V2于01:52开始本地作业，提示词全文825字符、normal/v8.2及16:9检查通过后进入单次提交；最长20分钟结果等待结束返回timeout，submitted缺、billed缺、recordId缺、images为空。软件保留result_pending并自动暂停，首波其余4项attempts=0；wave2和单次草稿未启动。本次没有可验收的新原图，不能宣称抽卡恢复。

运行结束且无active后进行了免费probe和控件诊断，最新可见平台卡片仍为00:26:13的历史作业，没有取得本次提示词的作业关联。页面显示3026积分及已签到，缺请求前后对照，不能算实际扣费；历史“提示词过长/积分已退”不冒称本次错误。提示词本身825字符，小于该历史错误中的1024字符，不认定提示词超长为当前原因。公众号广告已关闭、页面无可见dialog，标准生成控件存在；单凭这些不能证明平台受理。

证据位于本次授权目录：wave1-after-platform-wait.json、D01-V2-timeout-receipt-preserved.json、post-timeout-platform-probe.json、post-timeout-controls-diagnostic.json及post-timeout-workspace-evidence.png。此截图仅作现场证据，不是生成候选。授权仍为最多100次、保守预留7；真实受理数与积分扣除缺。当前阶段VERIFY受平台回执缺失阻塞，无需用户追加同一额度审批，未知原作业不重提交、不换渠道、不启动重复批次。


## 2026-10-09 v005英文快速模式：8组完成

用户指定外部v005逐张中英提示词，排除A01 Alice完整舰、A02鲸星守军，其余A03/BG01/BG02/P01/K01/K02/K03/K04各一次。当前任务明确改用fast，继承本次100次上限，累计保守预留15，不叠加旧1000次。无参考图上传，源文件及原图像素未改。K01/K03因平台字符上限压缩重复英文，原始和实际全文保留在本机manifest。

实际发现runner把fast误判为维护命令，首次A03返回bad_request而没有进入generate；保留该回执，修复main入口接受normal/fast，增加独立fast合同测试。49 Node、44 Python测试及npm run verify通过；备份安装runner，字节哈希一致。随后8项各实际提交一次，8个不同平台serial，全部回执modeVerified=true/appliedMode=fast、versionVerified=true/appliedVersion=v8.2。BG02下载返回浏览器关闭错误，但同serial的2912x1632原图已落盘，真实解码和目视检查通过，未重抽或修改失败回执。

结果目录：E:/Multica-Control-Console/mj-automation/output/whale-v005-english-fast-20261009；index.html为原图展示，生成结果索引.md为索引。8组原图均2912x1632、MJ四格共32个候选，SHA256/解码/目视证据保存在本机run/whale-v005-english-fast-20261009/original-image-validation.json及visual-review.json。部分主舰造型、方向、数量和背景有偏差，不标为审美验收通过，不自动补抽。实际积分扣除缺。旧普通模式D01-V2未决记录保留、不恢复、不重提交；它不冒充本次v005失败。当前8项生成目标已完成，最终选图仍由用户。
