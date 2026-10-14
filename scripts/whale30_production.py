"""Quota-reserved, single-session batch dispatch; no browser automation in this module."""
from pathlib import Path
import argparse, json, os, urllib.request, urllib.error, hashlib
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parent.parent
INSTALL = Path(r"E:\Multica-Control-Console")
SESSION = "whale30-20261008"
RUN = INSTALL / "mj-automation" / "run" / SESSION
LEDGER = RUN / "authorization.json"
BASE = "http://127.0.0.1:8765"

def request(path, method="GET", payload=None):
    req = urllib.request.Request(BASE + path, data=json.dumps(payload).encode("utf-8") if payload is not None else None,
        method=method, headers={"Content-Type":"application/json"} if payload is not None else {})
    with urllib.request.urlopen(req, timeout=110) as response:
        return json.load(response)

def store(path, data):
    temp = path.with_suffix(".writing")
    with temp.open("w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, indent=2); handle.flush(); os.fsync(handle.fileno())
    os.replace(temp, path)

def reserved_total(ledger):
    records = ledger["reservations"]
    cap, reserved = ledger["max_generation_requests"], ledger["reserved_requests"]
    if type(cap) is not int or cap < 0 or type(reserved) is not int or reserved < 0:
        raise ValueError("Invalid quota counters")
    if any(type(r["requests"]) is not int or r["requests"] < 0 for r in records):
        raise ValueError("Invalid reservation count")
    if len({r["batchId"] for r in records}) != len(records):
        raise ValueError("Duplicate quota reservation")
    total = sum(r["requests"] for r in records)
    if total != reserved or total > cap:
        raise ValueError("Quota accounting mismatch or cap exceeded")
    return total


def reconcile(ledger, batches, jobs, allowed_output):
    """Pure receipt accounting: never dispatch, change quota or infer unknown charges."""
    import math
    import re
    reserved = reserved_total(ledger)
    if ledger.get("project_id") != "whale-pilot-v1" or ledger.get("session_id") != SESSION:
        raise ValueError("Unexpected production session")
    rows, unique_jobs, seen_paths = [], {}, set()
    allowed = Path(allowed_output).resolve()
    alerts = []
    by_batch = {b["batchId"]: b for b in batches}
    for batch in batches:
        if not batch["batchId"].startswith(SESSION + "-wave"):
            raise ValueError("Foreign batch in production accounting")
        for item in batch["items"]:
            history = item.get("attemptHistory") or []
            ids = {h.get("jobId") for h in history if isinstance(h, dict) and h.get("jobId")}
            current = item.get("currentJobId")
            if current: ids.add(current)
            if ids and not any(r["batchId"] == batch["batchId"] for r in ledger["reservations"]):
                alerts.append("存在未预留额度的手动启动批次：" + batch["batchId"])
            row = {"batchId": batch["batchId"], "itemId": item["id"], "status": item["status"], "jobs": sorted(ids)}
            if item["status"] == "running" and not ids:
                row["submission"] = "unknown_no_job_id"
                alerts.append("运行任务缺少作业号：" + item["id"])
            for job_id in ids:
                if not re.fullmatch(r"[\w.-]{1,80}", job_id): raise ValueError("Invalid job id")
                payload = jobs.get(job_id)
                if payload is None:
                    unique_jobs[job_id] = {"jobId":job_id,"submitted":None,"billed":None,"files":[]}
                    continue
                submitted = payload.get("submitted") if type(payload.get("submitted")) is bool else None
                billed = payload.get("billed") if type(payload.get("billed")) is bool else None
                deduction = payload.get("actual_point_deduction")
                deduction = deduction if type(deduction) in (int,float) and math.isfinite(deduction) and deduction >= 0 else None
                entry = {"jobId":job_id,"submitted":submitted,"billed":billed,
                    "actualPointDeduction":deduction,"files":[],"resultStatus":payload.get("status"),
                    "requestedMode":payload.get("requestedMode"),"appliedMode":payload.get("appliedMode"),
                    "modeVerified":payload.get("modeVerified") is True,
                    "appliedVersion":payload.get("appliedVersion"),"versionVerified":payload.get("versionVerified") is True}
                if submitted is not False and not (entry["modeVerified"] and entry["appliedMode"] == "normal"
                    and entry["versionVerified"] and entry["appliedVersion"] == "v8.2"):
                    alerts.append("模式或版本未核验，不继续派发：" + job_id)
                files = payload.get("images") or []
                if not isinstance(files,list):files=[]
                for name in files:
                    if not isinstance(name,str):continue
                    file = Path(name)
                    if not file.is_absolute() or any(part.is_symlink() or getattr(part,"is_junction",lambda:False)()
                        for part in (file,*file.parents)):
                        alerts.append("图片路径无效：" + job_id);continue
                    resolved=file.resolve()
                    if allowed not in resolved.parents or not resolved.is_file():
                        alerts.append("图片未在授权输出目录：" + job_id);continue
                    identity=str(resolved).casefold()
                    if identity in seen_paths:continue
                    seen_paths.add(identity)
                    with resolved.open("rb") as handle:digest=hashlib.file_digest(handle,"sha256").hexdigest()
                    entry["files"].append({"path":str(resolved),"bytes":resolved.stat().st_size,"sha256":digest,
                        "visualAcceptance":"pending","decodeVerified":False})
                unique_jobs[job_id]=entry
            rows.append(row)
    for record in ledger["reservations"]:
        if record["batchId"] not in by_batch:alerts.append("预留批次暂缺状态：" + record["batchId"])
    confirmed=sum(v["submitted"] is True for v in unique_jobs.values())
    ambiguous=sum(v["submitted"] is None for v in unique_jobs.values())
    missing_intents=sum(r.get("submission")=="unknown_no_job_id" for r in rows)
    if confirmed+ambiguous+missing_intents > ledger["max_generation_requests"]:
        alerts.append("实际或未决请求超过授权上限，停止后续提交")
    return {"sessionId":SESSION,"maximumRequests":ledger["max_generation_requests"],
        "reservedRequests":reserved,"unreservedRequests":ledger["max_generation_requests"]-reserved,
        "confirmedSubmittedRequests":confirmed,"ambiguousRequests":ambiguous+missing_intents,
        "confirmedBilledRequests":sum(v["billed"] is True for v in unique_jobs.values()),
        "chargeUnknownRequests":sum(v["submitted"] is not False and v["billed"] is None
            and v.get("actualPointDeduction") is None for v in unique_jobs.values()),
        "filesHashed":len(seen_paths),"visualAcceptance":"pending",
        "items":rows,"jobs":list(unique_jobs.values()),"alerts":list(dict.fromkeys(alerts)),
        "automaticExecutionBlocked":ledger.get("automatic_execution_status")=="blocked_by_tool_policy"}


def read_local_jobs(batches):
    result={}
    import re
    for batch in batches:
        for item in batch["items"]:
            history=item.get("attemptHistory") or []
            ids={h.get("jobId") for h in history if isinstance(h,dict) and h.get("jobId")}
            if item.get("currentJobId"):ids.add(item["currentJobId"])
            for job_id in ids:
                if not re.fullmatch(r"[\w.-]{1,80}",job_id):raise ValueError("Invalid job id")
                file=INSTALL/"mj-automation/run/jobs"/(job_id+".json")
                if not file.is_file() or file.is_symlink():result[job_id]=None;continue
                try:payload=json.loads(file.read_text(encoding="utf-8"))
                except (OSError,json.JSONDecodeError):payload=None
                result[job_id]=payload if isinstance(payload,dict) else None
    return result

def main():
    parser=argparse.ArgumentParser(); parser.add_argument("action", choices=("prepare", "start", "status", "reconcile")); parser.add_argument("--wave",type=int,choices=(1,2),default=1)
    args=parser.parse_args()
    if args.action=="start":
        local_authorization=json.loads(LEDGER.read_text(encoding="utf-8"))
        if local_authorization.get("automatic_execution_status")=="blocked_by_tool_policy":
            raise SystemExit("自动启动已被工具政策拒绝；本脚本不会重试，请使用软件中的人工开始入口。")
    health=request("/health")
    if not health.get("ok") or Path(health.get("installRoot", "")).resolve()!=INSTALL.resolve():
        raise ValueError("Not the authorized installed bridge")
    payload=json.loads((ROOT/"projects/whale-pilot/batches"/f"whale30-wave{args.wave}-20261008.json").read_text(encoding="utf-8"))
    batch=payload["batch_id"]
    if args.action=="reconcile":
        ledger=json.loads(LEDGER.read_text(encoding="utf-8"))
        batches=[request("/control/batches/"+SESSION+"-wave"+str(wave)) for wave in (1,2)]
        report=reconcile(ledger,batches,read_local_jobs(batches),INSTALL/"mj-automation/output"/SESSION)
        store(RUN/"production-status.json",report)
        print(json.dumps(report,ensure_ascii=False));return
    if args.action=="status":
        state=request("/control/batches/"+batch)
        result={"batchId":batch,"status":state["status"],"pauseReason":state.get("pauseReason"),"items":[{k:r.get(k) for k in ("id","status","currentJobId","attempts","failureReason")} for r in state["items"]]}
        store(RUN/(batch+"-last-status.json"), result);print(json.dumps(result,ensure_ascii=False));return
    validation=request("/control/batches/validate","POST",payload)
    if not validation["ok"]:raise ValueError(validation["errors"])
    if args.action=="prepare":
        existing=request("/control/batches")["items"]
        if not any(row["batchId"]==batch for row in existing):
            state=request("/control/batches","POST",validation["normalized"])
        else:state=request("/control/batches/"+batch)
        if state["status"]!="validated":raise ValueError("Not a fresh validated batch; no duplicate dispatch")
        store(RUN/(batch+"-prepared.json"),{"batchId":batch,"status":state["status"],"items":len(state["items"]),"submitted":False})
        print(json.dumps({"batchId":batch,"status":state["status"],"items":len(state["items"]),"paidCalls":0}));return
    lock=RUN/"dispatch.lock"
    fd=os.open(str(lock),os.O_CREAT|os.O_EXCL|os.O_WRONLY,0o600)
    try:
        os.write(fd,str(os.getpid()).encode());os.close(fd)
        ledger=json.loads(LEDGER.read_text(encoding="utf-8"));reserved_total(ledger)
        if ledger.get("granted") is not True or ledger["model"]!="v8.2" or ledger["mode"]!="normal":raise ValueError("Authorization does not match")
        if any(r["batchId"]==batch for r in ledger["reservations"]):raise ValueError("This batch already reserved; inspect existing state, never restart blindly")
        source=ROOT/"mj-automation/scripts/mxai_adapter.js";installed=INSTALL/"mj-automation/scripts/mxai_adapter.js"
        if hashlib.sha256(source.read_bytes()).digest()!=hashlib.sha256(installed.read_bytes()).digest():raise ValueError("Installed normal-mode guard differs from reviewed source")
        state=request("/control/batches/"+batch)
        if state["status"]!="validated" or any(x["status"]!="pending" for x in state["items"]):raise ValueError("Batch has prior state; inspect rather than restart")
        if len(state["items"])!=len(payload["items"]):raise ValueError("Batch count changed")
        expected={r["id"]:r for r in payload["items"]}
        for row in state["items"]:
            original=expected[row["id"]]
            if any(row[k]!=original[k] for k in ("prompt","aspect","version","params")):raise ValueError("Prepared request changed")
        if args.wave==2:
            first=request("/control/batches/"+SESSION+"-wave1")
            quality_path=RUN/"wave1-quality-review.json"
            if first["status"]!="completed" or not quality_path.is_file() or not json.loads(quality_path.read_text())["passedForNextWave"]:
                raise ValueError("First wave completion and actual visual review required")
        scheduler=request("/control/state")["batchScheduler"]
        if scheduler["active"] or scheduler["manualReview"]:raise ValueError("Active or unresolved work; inspect before submitting")
        count=len(state["items"])
        if ledger["reserved_requests"]+count>ledger["max_generation_requests"]:raise ValueError("Would exceed total authorization")
        record={"batchId":batch,"requests":count,"reservedAt":datetime.now(timezone.utc).isoformat(),"status":"intent_reserved","mode":"normal","model":"v8.2"}
        ledger["reservations"].append(record);ledger["reserved_requests"]+=count;store(LEDGER,ledger)
        # Quota is durably reserved before touching the paid start endpoint.
        try:state=request("/control/batches/"+batch+"/start","POST",{"paid_confirmed":True})
        except Exception:
            record["status"]="start_response_unknown_do_not_retry";store(LEDGER,ledger);raise
        record["status"]="started";store(LEDGER,ledger)
        print(json.dumps({"batchId":batch,"status":state["status"],"reservedRequests":ledger["reserved_requests"],"maximum":ledger["max_generation_requests"],"actualPlatformSubmissions":"pending receipts"}))
    finally:
        # Only remove the specific mutex this invocation successfully created.
        if lock.exists():lock.unlink()

if __name__=="__main__":main()
