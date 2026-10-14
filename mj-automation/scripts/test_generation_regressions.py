"""Offline regressions: fixture DOM and local queue only, no browser launch."""
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from batch_queue import BatchManager

NODE_CASES = r"""
const assert = require('node:assert/strict');
const vm = require('node:vm');
const Adapter = require(process.argv[1]);
const realNow = Date.now;
const serial = 'serial-123';
const cases = [];
async function run(name, body) { await body(); cases.push(name); }
async function main() {
  await run('exact output URL identity', async () => {
    const fn = Adapter.isTargetOutputUrl;
    assert.equal(fn('https://cdn.qihuiai.com/draw/outputs/u/d/123_0.webp',serial),true);
    for (const url of ['https://cdn.qihuiai.com/draw/outputs/u/d/1234_0.webp',
      'https://cdn.qihuiai.com/draw/outputs/u/d/456_0.webp?serial=123',
      'https://cdn.qihuiai.com/draw/thumbnail/u/d/123_0.webp','blob:123']) assert.equal(fn(url,serial),false);
  });
  for (const spec of [
    {name:'no completion at deadline',text:'unknown',status:'receipt_pending'},
    {name:'queue is target-specific',text:'\u6b63\u5728\u751f\u6210',status:'queued'},
    {name:'lost card preserves identity',missing:true,status:'receipt_pending'},
    {name:'multiple cards are ambiguous',ids:[serial,'serial-456'],status:'unassociated_result'},
    {name:'history queue does not apply',ids:[],status:'timeout'},
    {name:'target completed',done:true,success:true},
    {name:'page exception preserves serial',throws:true,status:'receipt_pending'}
  ]) await run(spec.name, async () => {
    let clock=0; Date.now=()=>clock;
    const adapter=Object.create(Adapter.prototype);
    adapter._baselineSerials=new Set(['serial-111']);
    adapter._collectSerialIds=async()=>new Set(spec.ids||[serial]);
    adapter.page={waitForTimeout:async ms=>{clock+=ms;},evaluate:async(fn,id)=>{
      assert.equal(id,serial); if(spec.throws) throw Error('fixture closed');
      const document={body:{innerText:'\u6b63\u5728\u751f\u6210'},getElementById:()=>spec.missing?null:{
        innerText:spec.text||'',querySelectorAll:()=>spec.done?[{textContent:'\u4e0b\u8f7d'}]:[]}};
      return vm.runInNewContext('('+fn.toString()+')(id)',{document,id});
    }};
    const result=await adapter.waitForResult(4000);
    assert.equal(result.success,!!spec.success);
    if(spec.status) assert.equal(result.status,spec.status);
    assert.equal(result.recordId,spec.ids?null:serial);
    assert.ok(clock<=4000);
    if(!spec.success) assert.equal(result.retry_allowed,false);
    Date.now=realNow;
  });
  await run('download never opens a historical first image', async()=>{
    const adapter=Object.create(Adapter.prototype);adapter._submissionStarted=true;
    adapter._dismissPopups=async()=>{};adapter._fetchViaBlobCapture=async()=>({ok:false});
    adapter._fetchFullResByUrl=async()=>({ok:false});adapter._waitSerialRendered=async()=>({ok:false});
    adapter._downloadFromDetailDom=async()=>{throw Error('unbound detail called');};
    let unsafe=false;
    const locator={filter(){return this;},first(){return this;},count:async()=>0,click:async()=>{}};
    adapter.page={keyboard:{press:async()=>{}},waitForTimeout:async()=>{},
      evaluate:async()=>true,waitForSelector:async()=>{throw Error('no preview');},
      locator(selector){if(selector==='.el-image') unsafe=true;return locator;}};
    const result=await adapter.downloadLatestViaButton(process.argv[2],'fixture',1,serial);
    assert.equal(result.ok,false);assert.equal(unsafe,false);
    assert.deepEqual(result.downloaded,[]);
  });

  for (const scenario of ['truncated','same length wrong','recover','CRLF']) await run('full prompt '+scenario, async()=>{
    const prompt='A sufficiently long offline fixture prompt with parameters --seed 123 --stylize 90';
    let value='',fills=0;
    const el={scrollIntoViewIfNeeded:async()=>{},click:async()=>{},fill:async text=>{
      fills++;
      value=scenario==='truncated'?text.slice(0,25):scenario==='same length wrong'?'X'+text.slice(1):
        scenario==='recover'&&fills===1?text.slice(0,30):text.replace(/\r\n/g,'\n');
    }};
    const a=Object.create(Adapter.prototype);
    a.page={evaluateHandle:async()=>({asElement:()=>el}),keyboard:{press:async()=>{}},waitForTimeout:async()=>{},
      evaluate:async fn=>vm.runInNewContext('('+fn.toString()+')()',{
        document:{querySelectorAll:()=>[{placeholder:'\u8f93\u5165\u7ed8\u753b\u63cf\u8ff0\u8bcd',offsetParent:{},value}]}})};
    if(['truncated','same length wrong'].includes(scenario)) {
      await assert.rejects(a.fillPrompt(prompt),e=>e.code==='PROMPT_NOT_APPLIED');
      assert.equal(fills,4);
    } else {
      await a.fillPrompt(scenario==='CRLF'?prompt+'\r\nnext line':prompt);
      assert.equal(fills,scenario==='recover'?2:1);
    }
  });
  for(const scenario of ['uncertain','success','unavailable']) await run('single click '+scenario,async()=>{
    let clicks=0;
    const button={isVisible:async()=>true,isEnabled:async()=>scenario!=='unavailable',
      boundingBox:async()=>({x:20}),click:async()=>{clicks++;if(scenario==='uncertain')throw Error('fixture reply lost');}};
    const a=Object.create(Adapter.prototype);a.page={getByText:()=>({all:async()=>[button,button]})};
    if(scenario==='success'){await a.clickGenerate();assert.equal(clicks,1);}
    else {await assert.rejects(a.clickGenerate(),e=>e.code===(scenario==='uncertain'?'SUBMISSION_UNCERTAIN':'GENERATE_UNAVAILABLE'));
      assert.equal(clicks,scenario==='uncertain'?1:0);}
  });

  for(const available of [false,true]) await run('submission evidence '+available,async()=>{
    const a=Object.create(Adapter.prototype);a.context={};
    for(const name of ['navigate','ensureLoggedIn','_dismissPopups','fillPrompt','selectVersion','selectMode']) a[name]=async()=>{};
    a.selectAspect=async()=>({ok:true,requested:'16:9',applied:'16:9'});
    a._collectImageSrcs=async()=>new Set();a._collectSerialIds=async()=>new Set();
    a._writeReceipt=()=>{};
    a.waitForResult=async()=>{throw Error('unexpected result polling');};
    let clicks=0;
    const button={isVisible:async()=>true,isEnabled:async()=>available,boundingBox:async()=>({x:20}),
      click:async()=>{clicks++;throw Error('reply lost');}};
    a.page={getByText:()=>({all:async()=>[button]})};
    const result=await a.generate('offline fixture',{aspect:'16:9',outputDir:process.argv[2]});
    assert.equal(result.success,false);
    assert.equal(result.status,available?'submission_uncertain':'generate_unavailable');
    assert.equal(result.submitted,available?null:false);
    assert.equal(clicks,available?1:0);
    assert.equal(result.billed,available?undefined:false);
  });

  await run('click without receipt stays ambiguous',async()=>{
    const a=Object.create(Adapter.prototype);a.context={};
    for(const name of ['navigate','ensureLoggedIn','_dismissPopups','fillPrompt','selectVersion','selectMode','clickGenerate']) a[name]=async()=>{};
    a.selectAspect=async()=>({ok:true,requested:'16:9',applied:'16:9'});
    a._collectImageSrcs=async()=>new Set();a._collectSerialIds=async()=>new Set();a._writeReceipt=()=>{};
    a.waitForResult=async()=>({success:false,status:'timeout',recordId:null});
    const result=await a.generate('offline fixture',{aspect:'16:9',outputDir:process.argv[2]});
    assert.equal(result.submitted,null);assert.equal(result.billed,undefined);
    assert.equal(result.retry_allowed,false);assert.equal(a._submissionConfirmed,false);
  });

  for (const scenario of ['advertisement', 'login', 'persistent control', 'click error']) await run('scoped popup '+scenario,async()=>{
    let visible=true,clicks=0,globalQueries=0;
    const handle={evaluate:async(fn,other)=>handle===other,dispose:async()=>{}};
    const button={isVisible:async()=>true,isEnabled:async()=>true,boundingBox:async()=>({width:24,height:24}),
      click:async()=>{clicks++;if(scenario==='click error')throw Error('fixture click unknown');if(scenario==='advertisement')visible=false;}};
    const choices={all:async()=>[button],filter:()=>choices};
    const popup={isVisible:async()=>visible,elementHandle:async()=>handle,
      innerText:async()=>scenario==='login'?'请登录 扫码':'A fixture popup',locator:()=>choices};
    const a=Object.create(Adapter.prototype);
    a.page={evaluate:async()=>false,waitForTimeout:async()=>{},getByText:()=>{globalQueries++;throw Error('global page text must not be clicked');},
      locator:selector=>{assert.ok(selector.includes('[role="dialog"]'));return {all:async()=>[popup,popup]};}};
    const result=await a._dismissPopups();
    assert.equal(globalQueries,0);
    assert.equal(clicks,scenario==='login'?0:1);
    assert.equal(result.dismissed,scenario==='advertisement'?1:0);
    assert.equal(visible,scenario!=='advertisement');
  });
  console.log(JSON.stringify(cases));
}
main().catch(error=>{Date.now=realNow;console.error(error);process.exitCode=1;});
"""

class GenerationRegressions(unittest.TestCase):
    def test_offline_adapter(self):
        with tempfile.TemporaryDirectory() as folder:
            env = dict(os.environ, MXAI_TRACE_FILE=str(Path(folder) / 'trace.log'),
                MJ_PROGRESS_FILE=str(Path(folder) / 'phase.json'), MJ_RECEIPTS_DIR=folder)
            result = subprocess.run(['node', '-e', NODE_CASES,
                str(Path(__file__).with_name('mxai_adapter.js')), folder],
                capture_output=True, text=True, encoding='utf-8', env=env, timeout=15)
            self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
            self.assertEqual(len(json.loads(result.stdout.strip().splitlines()[-1])), 23)

    def test_queue_reports_terminal_failure_despite_unknown_charge(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            manager = BatchManager(root/'batches', lambda _: {}, lambda _: {}, root/'output', root/'slots')
            state = manager.create({'batch_id':'regression', 'items':[{'id':'one','prompt':'offline fixture'}]})
            item = state['items'][0]
            manager._finalize_job(state, item, {'status':'done','resultStatus':'page_reported_failed',
                'submitted':True, 'billed':None, 'chargeKnown':False, 'retryAllowed':False,
                'message':'failure from target card'})
            self.assertEqual(item['status'], 'failed')
            self.assertIn('failure from target card', item['failureReason'])
            self.assertIn('\u8d39\u7528\u5c1a\u672a\u786e\u8ba4', state['pauseReason'])
            self.assertIsNone(item['lastResult']['billed'])
            self.assertFalse(item['lastResult']['retryAllowed'])

    def test_queue_keeps_verified_fields_from_result_without_inventing_them(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            manager = BatchManager(root/'batches', lambda _: {}, lambda _: {}, root/'output', root/'slots')
            fields = {'requestedMode':'normal','appliedMode':'normal','modeVerified':True,
                'requestedVersion':'v8.2','appliedVersion':None,'versionVerified':False}
            summary = manager._summary({'result':fields})
            self.assertEqual(summary, fields)
            self.assertNotIn('appliedMode', manager._summary({'result':{}}))

if __name__ == '__main__':
    unittest.main()
