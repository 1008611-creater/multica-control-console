"""Receipt/quota contracts; no browser, HTTP, platform request or paid dispatch."""
import copy, importlib.util, json, tempfile, unittest
from pathlib import Path
spec=importlib.util.spec_from_file_location("production",Path(__file__).with_name("whale30_production.py"))
production=importlib.util.module_from_spec(spec);spec.loader.exec_module(production)
SESSION=production.SESSION
class ProductionAccountingTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.output=Path(self.tmp.name)/"output";self.output.mkdir()
        self.ledger={"project_id":"whale-pilot-v1","session_id":SESSION,"max_generation_requests":1000,
            "reserved_requests":6,"reservations":[{"batchId":SESSION+"-wave1","requests":6}],
            "automatic_execution_status":"blocked_by_tool_policy"}
        self.batches=[{"batchId":SESSION+"-wave1","items":[{"id":"a","status":"pending","currentJobId":None,"attemptHistory":[]}]}]
    def tearDown(self):self.tmp.cleanup()
    def report(self,jobs=None):return production.reconcile(self.ledger,self.batches,jobs or {},self.output)
    def job(self,**values):
        self.batches[0]["items"][0].update(status="completed",currentJobId="job-1")
        return {"job-1":{"submitted":True,"billed":None,"images":[],"modeVerified":True,
            "appliedMode":"normal","versionVerified":True,"appliedVersion":"v8.2",**values}}
    def test_manual_reservation_is_not_platform_consumption(self):
        before=copy.deepcopy(self.ledger);r=self.report()
        self.assertEqual(r["reservedRequests"],6);self.assertEqual(r["confirmedSubmittedRequests"],0)
        self.assertEqual(r["ambiguousRequests"],0);self.assertEqual(r["confirmedBilledRequests"],0)
        self.assertTrue(r["automaticExecutionBlocked"]);self.assertEqual(self.ledger,before)
    def test_uncertain_missing_job_is_not_reported_as_zero_or_retried(self):
        self.batches[0]["items"][0].update(status="running",currentJobId="job-1")
        r=self.report();self.assertEqual(r["ambiguousRequests"],1);self.assertEqual(r["chargeUnknownRequests"],1)
    def test_running_without_job_id_is_ambiguous(self):
        self.batches[0]["items"][0]["status"]="running";r=self.report()
        self.assertEqual(r["ambiguousRequests"],1);self.assertTrue(r["alerts"])
    def test_confirmed_unsubmitted_failure_has_no_inferred_charge(self):
        r=self.report(self.job(submitted=False,billed=False,modeVerified=False,appliedMode=None))
        self.assertEqual(r["confirmedSubmittedRequests"],0);self.assertEqual(r["chargeUnknownRequests"],0)
        self.assertEqual(r["alerts"],[])
    def test_completed_download_does_not_prove_charge_or_visual_acceptance(self):
        file=self.output/"explicit-fixture.bin";file.write_bytes(b"fixture, not production image")
        r=self.report(self.job(images=[str(file)]));self.assertEqual(r["confirmedSubmittedRequests"],1)
        self.assertEqual(r["chargeUnknownRequests"],1);self.assertEqual(r["filesHashed"],1)
        self.assertFalse(r["jobs"][0]["files"][0]["decodeVerified"])
        self.assertEqual(r["visualAcceptance"],"pending")
    def test_missing_or_wrong_selection_blocks_next_wave(self):
        for values in [{"modeVerified":False},{"appliedMode":"fast"},{"appliedVersion":"v7"},{"versionVerified":False}]:
            with self.subTest(values=values):self.assertTrue(self.report(self.job(**values))["alerts"])
    def test_history_and_current_job_count_once_but_real_retries_count_twice(self):
        self.batches[0]["items"][0]["attemptHistory"]=[{"jobId":"job-1"},{"jobId":"job-1"},{"jobId":"job-2"}]
        jobs=self.job();jobs["job-2"]={**jobs["job-1"],"submitted":None}
        r=self.report(jobs);self.assertEqual(len(r["jobs"]),2);self.assertEqual(r["confirmedSubmittedRequests"],1)
        self.assertEqual(r["ambiguousRequests"],1)
    def test_output_outside_authorized_directory_is_rejected(self):
        file=self.output.parent/"foreign.bin";file.write_bytes(b"fixture")
        r=self.report(self.job(images=[str(file)]));self.assertEqual(r["filesHashed"],0);self.assertTrue(r["alerts"])
    def test_boolean_nan_and_negative_deduction_never_prove_charge(self):
        for value in [True,float("nan"),-1]:
            r=self.report(self.job(actual_point_deduction=value));self.assertEqual(r["chargeUnknownRequests"],1)
        r=self.report(self.job(actual_point_deduction=0));self.assertEqual(r["chargeUnknownRequests"],0)
        self.assertEqual(r["confirmedBilledRequests"],0)
    def test_unreserved_manual_batch_is_visible_without_changing_authorization(self):
        self.batches[0]["batchId"]=SESSION+"-wave2";r=self.report(self.job())
        self.assertTrue(any("未预留" in a for a in r["alerts"]));self.assertEqual(self.ledger["reserved_requests"],6)
    def test_invalid_quota_and_duplicate_reservations_are_rejected(self):
        changes=[{"max_generation_requests":True},{"reserved_requests":True},
            {"reservations":[{"batchId":"a","requests":-1}],"reserved_requests":-1},
            {"reservations":[{"batchId":"a","requests":True}],"reserved_requests":1},
            {"reservations":[{"batchId":"a","requests":1001}],"reserved_requests":1001},
            {"reservations":[{"batchId":"a","requests":3},{"batchId":"a","requests":3}]},
            {"reserved_requests":5}]
        for values in changes:
            with self.subTest(values=values),self.assertRaises(ValueError):production.reserved_total({**self.ledger,**values})
    def test_foreign_batches_and_unsafe_job_ids_are_rejected(self):
        self.batches[0]["batchId"]="foreign"
        with self.assertRaises(ValueError):self.report()
        self.batches[0]["batchId"]=SESSION+"-wave1"
        self.batches[0]["items"][0]["currentJobId"]="../foreign"
        with self.assertRaises(ValueError):self.report()
if __name__=="__main__":unittest.main()
