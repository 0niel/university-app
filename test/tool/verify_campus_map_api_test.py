import contextlib
import copy
import importlib.util
import io
import json
import tempfile
import unittest
import urllib.error
from pathlib import Path
from unittest import mock


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location('verify_campus_map_api', ROOT / 'tool/verify_campus_map_api.py')
CHECK = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CHECK)
ENVIRONMENT = {'SUPABASE_URL': 'https://project.example',
               'SUPABASE_PUBLISHABLE_KEY': 'sb_publishable_test_sensitive_value'}


class Response(io.BytesIO):
    def __init__(self, payload, status=200, headers=None):
        super().__init__(payload)
        self.status = status
        self.headers = {'Content-Type': 'application/json', **(headers or {})}


class ApiTransportTest(unittest.TestCase):
    def test_post_uses_public_key_and_public_gateway(self):
        calls = []

        def opener(request, timeout):
            calls.append((request, timeout))
            return Response(b'{"campuses":[]}')

        result = CHECK.read_rpc(*CHECK.configuration(ENVIRONMENT), 'get_map_catalog',
                                {'p_organization_id': 'mirea'}, opener=opener)
        request, timeout = calls[0]
        self.assertEqual(result, {'campuses': []})
        self.assertEqual(request.full_url, 'https://project.example/rest/v1/rpc/get_map_catalog')
        self.assertEqual(request.method, 'POST')
        self.assertEqual(json.loads(request.data), {'p_organization_id': 'mirea'})
        self.assertEqual(request.get_header('Apikey'), ENVIRONMENT['SUPABASE_PUBLISHABLE_KEY'])
        self.assertIsNone(request.get_header('Authorization'))
        self.assertEqual(request.get_header('Content-profile'), 'public')
        self.assertEqual(request.get_header('Accept-profile'), 'public')
        self.assertEqual(timeout, CHECK.SOCKET_TIMEOUT)

    def test_mutation_and_redirect_are_never_followed(self):
        opener = mock.Mock()
        with self.assertRaises(CHECK.VerificationError):
            CHECK.read_rpc(*CHECK.configuration(ENVIRONMENT), 'publish_map_campus', {}, opener=opener)
        opener.assert_not_called()
        self.assertIsNone(CHECK.NoRedirect().redirect_request(None, None, 307, '', {}, 'https://elsewhere.example'))

    def test_declared_and_streamed_oversize_responses_are_rejected(self):
        for headers in ({'Content-Length': '20'}, {}):
            with self.subTest(headers=headers), mock.patch.object(CHECK, 'MAX_CATALOG_BYTES', 8):
                with self.assertRaisesRegex(CHECK.VerificationError, 'size limit'):
                    CHECK.read_rpc(*CHECK.configuration(ENVIRONMENT), 'get_map_catalog', {},
                                   opener=lambda *args, **kwargs: Response(b'0123456789', headers=headers))

    def test_response_deadline_and_socket_timeout_are_sanitized(self):
        with self.assertRaisesRegex(CHECK.VerificationError, 'deadline exceeded'):
            CHECK.read_rpc(*CHECK.configuration(ENVIRONMENT), 'get_map_catalog', {},
                           opener=lambda *args, **kwargs: Response(b'{}'),
                           clock=iter([0, CHECK.RESPONSE_TIMEOUT]).__next__)
        with self.assertRaisesRegex(CHECK.VerificationError, '^HTTP request failed or timed out$'):
            CHECK.read_rpc(*CHECK.configuration(ENVIRONMENT), 'get_map_catalog', {},
                           opener=mock.Mock(side_effect=TimeoutError(str(ENVIRONMENT))))

    def test_invalid_json_duplicate_keys_and_nonfinite_numbers_fail(self):
        for payload in (b'not json', b'null', b'{"a":1,"a":2}', b'{"a":NaN}', b'{"a":1e99999999}'):
            with self.subTest(payload=payload), self.assertRaises(CHECK.VerificationError):
                CHECK.decode_document(payload)

    def test_http_error_body_and_configuration_never_reach_logs(self):
        output, errors = io.StringIO(), io.StringIO()
        body = Response(json.dumps(ENVIRONMENT).encode())
        error = urllib.error.HTTPError(ENVIRONMENT['SUPABASE_URL'], 401,
                                       ENVIRONMENT['SUPABASE_PUBLISHABLE_KEY'], {}, body)

        def rpc(*args, **kwargs):
            return CHECK.read_rpc(*args, **kwargs, opener=mock.Mock(side_effect=error))

        with mock.patch.object(CHECK, 'load_bundles', return_value={}), contextlib.redirect_stdout(output):
            status = CHECK.main(environment=ENVIRONMENT, rpc=rpc, output=output, error_output=errors)
        self.assertEqual(status, 1)
        self.assertTrue(body.closed)
        self.assertEqual(output.getvalue(), '')
        self.assertEqual(errors.getvalue(), 'FAIL: HTTP request failed with status 401\n')
        for value in ENVIRONMENT.values():
            self.assertNotIn(value, output.getvalue() + errors.getvalue())

    def test_invalid_or_elevated_credentials_fail_before_http(self):
        import base64

        elevated = 'e30.' + base64.urlsafe_b64encode(b'{"role":"service_role"}').decode().rstrip('=') + '.signature'
        for environment in ({}, {**ENVIRONMENT, 'SUPABASE_URL': 'http://project.example'},
                            {**ENVIRONMENT, 'SUPABASE_URL': 'https://user:secret@project.example'},
                            {**ENVIRONMENT, 'SUPABASE_PUBLISHABLE_KEY': 'sb_secret_test'},
                            {**ENVIRONMENT, 'SUPABASE_PUBLISHABLE_KEY': elevated}):
            with self.subTest(environment=list(environment)):
                rpc, errors = mock.Mock(), io.StringIO()
                self.assertEqual(CHECK.main(environment=environment, rpc=rpc, error_output=errors), 1)
                rpc.assert_not_called()
                for value in environment.values():
                    self.assertNotIn(value, errors.getvalue())


class CampusComparisonTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.documents = {}
        for campus_id in CHECK.CAMPUS_IDS:
            document = {'id': campus_id, 'organization_id': 'mirea', 'schema_version': 1 if campus_id == 'mp-1' else 2,
                        'revision': 2, 'title': 'Кампус', 'short_title': campus_id,
                        'floors': [{'id': 'f1', 'svg': '<svg/>', 'anchors': []}],
                        'rooms': [{'id': 'r1', 'x': 10, 'label': 'Аудитория'}],
                        'graph': {'nodes': [{'id': 'n1'}], 'edges': []}}
            self.documents[campus_id] = document
            (self.directory / f'campus_{campus_id}.json').write_text(json.dumps(document), encoding='utf-8')
        self.actual = copy.deepcopy(self.documents)
        for document in self.actual.values():
            document.update(schema_version=1, revision=7, updated_at='2026-09-07T00:00:00+00:00', can_moderate=False)
        self.catalog = {'schema_version': 1, 'campuses': [
            {'id': campus_id, 'organization_id': 'mirea', 'revision': 7, 'can_moderate': False,
             'floor_count': 1, 'room_count': 1,
             **{key: document.get(key) for key in CHECK.SUMMARY_FIELDS}}
            for campus_id, document in self.actual.items()]}
        self.calls = []

    def rpc(self, url, key, name, parameters):
        self.calls.append((name, parameters))
        document = self.catalog if name == 'get_map_catalog' else self.actual[parameters['p_campus_id']]
        return CHECK.decode_document(json.dumps(document).encode())

    def run_check(self):
        output, errors = io.StringIO(), io.StringIO()
        result = CHECK.main(environment=ENVIRONMENT, directory=self.directory, rpc=self.rpc,
                            output=output, error_output=errors)
        return result, output.getvalue(), errors.getvalue()

    def test_all_four_full_documents_match_and_counts_are_reported(self):
        result, output, errors = self.run_check()
        self.assertEqual(result, 0, errors)
        self.assertEqual(len(self.calls), 5)
        self.assertEqual(output.count('hash match'), 4)
        self.assertIn('PASS: campuses=4 floors=4 rooms=4 nodes=4 edges=0', output)
        self.assertFalse(errors)

    def test_svg_room_graph_and_georeference_changes_fail_exact_comparison(self):
        changes = [('floors', lambda d: d['floors'][0].update(svg='<svg><path/></svg>')),
                   ('rooms', lambda d: d['rooms'][0].update(label='Other')),
                   ('graph', lambda d: d['graph']['nodes'].append({'id': 'n2'})),
                   ('anchors', lambda d: d['floors'][0]['anchors'].append({'x': 0, 'latitude': 55}))]
        original = copy.deepcopy(self.actual['v-78'])
        for name, change in changes:
            with self.subTest(name=name):
                self.actual['v-78'] = copy.deepcopy(original)
                change(self.actual['v-78'])
                result, output, errors = self.run_check()
                self.assertEqual(result, 1)
                self.assertNotIn('PASS:', output)
                self.assertIn('v-78: public document differs', errors)
                self.assertNotIn('Other', errors)

    def test_missing_duplicate_campuses_and_catalog_disagreement_fail(self):
        original = copy.deepcopy(self.catalog)
        for change in (lambda: self.catalog['campuses'].pop(),
                       lambda: self.catalog['campuses'].__setitem__(0, self.catalog['campuses'][1]),
                       lambda: self.catalog['campuses'][0].update(room_count=0),
                       lambda: self.catalog['campuses'][0].update(revision=6)):
            self.catalog = copy.deepcopy(original)
            change()
            self.assertEqual(self.run_check()[0], 1)

    def test_public_permission_and_nested_server_named_fields_are_verified(self):
        self.actual['mp-1']['can_moderate'] = True
        self.assertEqual(self.run_check()[0], 1)
        self.actual['mp-1']['can_moderate'] = False
        self.actual['mp-1']['rooms'][0]['updated_at'] = 'changed'
        self.assertEqual(self.run_check()[0], 1)

    def test_rpc_schema_is_checked_separately_from_source_schema(self):
        self.assertEqual(self.documents['v-78']['schema_version'], 2)
        self.assertEqual(self.actual['v-78']['schema_version'], 1)
        self.assertEqual(self.run_check()[0], 0)
        for schema in (None, 2, True):
            with self.subTest(schema=schema):
                self.actual['v-78']['schema_version'] = schema
                self.assertEqual(self.run_check()[0], 1)
        self.actual['v-78']['schema_version'] = 1
        self.actual['v-78']['graph']['nodes'].append({'id': 'changed-node'})
        self.assertEqual(self.run_check()[0], 1)

    def test_number_formatting_is_equivalent_but_precision_and_types_are_exact(self):
        first = CHECK.decode_document(b'{"x":10,"zero":0,"small":0.00001}')
        second = CHECK.decode_document(b'{"small":1e-5,"zero":-0.0,"x":10.000}')
        self.assertEqual(CHECK.fingerprint(first), CHECK.fingerprint(second))
        for left, right in ((b'{"x":9007199254740992}', b'{"x":9007199254740993}'),
                            (b'{"x":0}', b'{"x":false}'),
                            (b'{"x":0.12345678901234567890123456789}', b'{"x":0.12345678901234567890123456788}')):
            self.assertNotEqual(CHECK.fingerprint(CHECK.decode_document(left)),
                                CHECK.fingerprint(CHECK.decode_document(right)))


class VerificationWorkflowTest(unittest.TestCase):
    def test_current_full_bundles_pass_the_http_contract_without_network(self):
        documents = CHECK.load_bundles(CHECK.BUNDLES)
        published = {campus_id: {**document, 'schema_version': 1, 'revision': CHECK.Decimal(9),
                                 'can_moderate': False, 'updated_at': '2026-09-07T00:00:00Z'}
                     for campus_id, document in documents.items()}
        catalog = {'schema_version': 1, 'campuses': [
            {'id': campus_id, 'organization_id': 'mirea', 'revision': 9,
             'can_moderate': False, 'floor_count': len(document['floors']),
             'room_count': len(document['rooms']),
             **{key: document.get(key) for key in CHECK.SUMMARY_FIELDS}}
            for campus_id, document in published.items()]}
        output = io.StringIO()

        def opener(request, timeout):
            parameters = json.loads(request.data)
            document = published[parameters['p_campus_id']] if 'p_campus_id' in parameters else catalog
            return Response(CHECK._canonical(document).encode('utf-8'))

        def rpc(*args, **kwargs):
            return CHECK.read_rpc(*args, **kwargs, opener=opener)

        CHECK.verify(*CHECK.configuration(ENVIRONMENT), rpc=rpc, output=output)
        self.assertEqual(output.getvalue().count('hash match'), 4)
        self.assertIn('PASS: campuses=4', output.getvalue())

    def test_manual_master_verification_uses_pinned_release_configuration(self):
        workflow = (ROOT / '.github/workflows/campus-map-verify.yml').read_text(encoding='utf-8')
        self.assertIn('  workflow_dispatch:', workflow)
        self.assertNotIn('pull_request:', workflow)
        self.assertNotIn('schedule:', workflow)
        self.assertIn("if: github.ref == 'refs/heads/master'", workflow)
        self.assertIn('environment: beta', workflow)
        self.assertIn('ref: ${{ github.sha }}', workflow)
        self.assertIn('persist-credentials: false', workflow)
        self.assertIn('SUPABASE_URL: ${{ vars.SUPABASE_URL }}', workflow)
        self.assertIn('SUPABASE_PUBLISHABLE_KEY: ${{ secrets.SUPABASE_PUBLISHABLE_KEY }}', workflow)
        self.assertIn("python-version: '3.13'", workflow)
        self.assertEqual(workflow.count('        run:'), 1)
        for line in workflow.splitlines():
            if 'uses:' in line:
                self.assertRegex(line, r'uses: actions/(checkout|setup-python)@[0-9a-f]{40}$')


if __name__ == '__main__':
    unittest.main()
