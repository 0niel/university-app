import hashlib
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from decimal import Decimal
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BUNDLES = ROOT / 'packages/app_ui/assets/maps/pulse'
CAMPUS_IDS = ('mp-1', 's-20', 'v-78', 'v-86')
SERVER_FIELDS = frozenset(('schema_version', 'revision', 'updated_at', 'can_moderate'))
SUMMARY_FIELDS = ('title', 'short_title', 'address', 'latitude', 'longitude',
                  'source_url', 'source_label')
MAX_DOCUMENT_BYTES = 32 * 1024 * 1024
MAX_CATALOG_BYTES = 1024 * 1024
SOCKET_TIMEOUT = 15
RESPONSE_TIMEOUT = 45


class VerificationError(Exception):
    pass


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def _number(value):
    number = Decimal(value)
    if not number.is_finite() or (number and abs(number.adjusted()) > 308):
        raise VerificationError('Invalid JSON number')
    return number


def _object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise VerificationError('Duplicate JSON field')
        result[key] = value
    return result


def decode_document(payload):
    try:
        document = json.loads(payload, parse_int=_number, parse_float=_number,
                              parse_constant=_number, object_pairs_hook=_object)
    except (ValueError, UnicodeError, ArithmeticError, RecursionError):
        raise VerificationError('Invalid JSON response') from None
    if not isinstance(document, dict):
        raise VerificationError('Expected a JSON document')
    return document


def _canonical(value):
    if isinstance(value, dict):
        return '{' + ','.join(json.dumps(key, ensure_ascii=False) + ':' +
                              _canonical(value[key]) for key in sorted(value)) + '}'
    if isinstance(value, list):
        return '[' + ','.join(_canonical(item) for item in value) + ']'
    if isinstance(value, Decimal):
        if not value:
            return '0'
        text = format(value, 'f')
        return text.rstrip('0').rstrip('.') if '.' in text else text
    return json.dumps(value, ensure_ascii=False, allow_nan=False,
                      separators=(',', ':'))


def fingerprint(document):
    public = {key: value for key, value in document.items() if key not in SERVER_FIELDS}
    return hashlib.sha256(_canonical(public).encode('utf-8')).hexdigest()


def configuration(environment):
    url = environment.get('SUPABASE_URL', '').strip()
    key = environment.get('SUPABASE_PUBLISHABLE_KEY', '').strip()
    try:
        parsed = urllib.parse.urlsplit(url)
        valid_url = (parsed.scheme == 'https' and parsed.hostname and
                     not parsed.username and not parsed.password and
                     parsed.path in ('', '/') and not parsed.query and
                     not parsed.fragment and parsed.port in (None, 443))
    except ValueError:
        valid_url = False
    if not valid_url or not key or any(ord(char) < 33 for char in url + key):
        raise VerificationError('Missing or invalid public API configuration')
    if not key.startswith('sb_publishable_'):
        import base64

        try:
            parts = key.split('.')
            claims = json.loads(base64.urlsafe_b64decode(
                parts[1] + '=' * (-len(parts[1]) % 4))) if len(parts) == 3 else {}
            if not isinstance(claims, dict) or claims.get('role') != 'anon':
                raise ValueError()
        except (ValueError, UnicodeError, IndexError):
            raise VerificationError('A public anonymous API key is required') from None
    return url.rstrip('/'), key


def _read_response(response, limit, deadline, clock):
    if response.status != 200:
        raise VerificationError('Unexpected HTTP status')
    content_type = response.headers.get('Content-Type', '').split(';')[0].strip().lower()
    if content_type != 'application/json':
        raise VerificationError('Unexpected HTTP content type')
    if response.headers.get('Content-Encoding', 'identity').lower() != 'identity':
        raise VerificationError('Unexpected HTTP content encoding')
    declared = response.headers.get('Content-Length')
    if declared is not None:
        try:
            size = int(declared)
        except ValueError:
            raise VerificationError('Invalid HTTP content length') from None
        if size < 0 or size > limit:
            raise VerificationError('HTTP response exceeds size limit')
    chunks = []
    size = 0
    while True:
        if clock() >= deadline:
            raise VerificationError('HTTP response deadline exceeded')
        chunk = response.read1(min(65536, limit - size + 1))
        if not chunk:
            break
        size += len(chunk)
        if size > limit:
            raise VerificationError('HTTP response exceeds size limit')
        chunks.append(chunk)
    return b''.join(chunks)


def read_rpc(url, key, name, parameters, *, opener=None, clock=time.monotonic):
    if name not in ('get_map_catalog', 'get_map_campus'):
        raise VerificationError('Unsupported read operation')
    request = urllib.request.Request(
        f'{url}/rest/v1/rpc/{name}', method='POST',
        data=json.dumps(parameters, separators=(',', ':')).encode('utf-8'),
        headers={'apikey': key, 'Content-Type': 'application/json',
                 'Accept': 'application/json', 'Accept-Encoding': 'identity',
                 'Content-Profile': 'public', 'Accept-Profile': 'public'},
    )
    open_request = opener or urllib.request.build_opener(NoRedirect()).open
    deadline = clock() + RESPONSE_TIMEOUT
    limit = MAX_CATALOG_BYTES if name == 'get_map_catalog' else MAX_DOCUMENT_BYTES
    try:
        with open_request(request, timeout=SOCKET_TIMEOUT) as response:
            payload = _read_response(response, limit, deadline, clock)
    except urllib.error.HTTPError as error:
        error.close()
        raise VerificationError(f'HTTP request failed with status {error.code}') from None
    except (OSError, urllib.error.URLError, TimeoutError):
        raise VerificationError('HTTP request failed or timed out') from None
    return decode_document(payload)


def load_bundles(directory):
    result = {}
    for campus_id in CAMPUS_IDS:
        path = directory / f'campus_{campus_id}.json'
        with path.open('rb') as source:
            payload = source.read(MAX_DOCUMENT_BYTES + 1)
        if len(payload) > MAX_DOCUMENT_BYTES:
            raise VerificationError('Bundled document exceeds size limit')
        document = decode_document(payload)
        if document.get('id') != campus_id or document.get('organization_id') != 'mirea':
            raise VerificationError('Invalid bundled campus identity')
        if ('schema_version' in document and (isinstance(document['schema_version'], bool)
                                              or document['schema_version'] not in (1, 2))):
            raise VerificationError('Unsupported bundled source schema')
        result[campus_id] = document
    return result


def _counts(document):
    floors, rooms, graph = document.get('floors'), document.get('rooms'), document.get('graph')
    if not isinstance(floors, list) or not isinstance(rooms, list) or not isinstance(graph, dict):
        raise VerificationError('Invalid campus collections')
    nodes, edges = graph.get('nodes'), graph.get('edges')
    if not isinstance(nodes, list) or not isinstance(edges, list):
        raise VerificationError('Invalid navigation graph')
    return len(floors), len(rooms), len(nodes), len(edges)


def verify(url, key, *, directory=BUNDLES, rpc=read_rpc, output=None):
    output = output or sys.stdout
    bundles = load_bundles(directory)
    catalog = rpc(url, key, 'get_map_catalog', {'p_organization_id': 'mirea'})
    entries = catalog.get('campuses')
    if (isinstance(catalog.get('schema_version'), bool) or catalog.get('schema_version') != 1
            or not isinstance(entries, list)):
        raise VerificationError('Invalid map catalog')
    if (len(entries) != len(CAMPUS_IDS) or
            any(not isinstance(item, dict) for item in entries) or
            {item.get('id') for item in entries} != set(CAMPUS_IDS)):
        raise VerificationError('Published campus set does not match the release')
    entries = {entry['id']: entry for entry in entries}
    total = [0, 0, 0, 0]
    for campus_id in CAMPUS_IDS:
        expected = bundles[campus_id]
        actual = rpc(url, key, 'get_map_campus', {'p_campus_id': campus_id})
        revision = actual.get('revision')
        if (isinstance(actual.get('schema_version'), bool) or actual.get('schema_version') != 1 or
                isinstance(revision, bool) or not isinstance(revision, (int, Decimal)) or
                revision <= 0 or revision != int(revision) or actual.get('can_moderate') is not False):
            raise VerificationError('Invalid anonymous campus metadata')
        digest = fingerprint(actual)
        if digest != fingerprint(expected):
            raise VerificationError(f'{campus_id}: public document differs from the release')
        counts = _counts(actual)
        entry = entries[campus_id]
        if (entry.get('revision') != revision or entry.get('can_moderate') is not False or
                entry.get('organization_id') != 'mirea' or
                entry.get('floor_count') != counts[0] or entry.get('room_count') != counts[1] or
                any(entry.get(field) != actual.get(field) for field in SUMMARY_FIELDS)):
            raise VerificationError(f'{campus_id}: catalog and campus disagree')
        total = [left + right for left, right in zip(total, counts)]
        print(f'{campus_id}: hash match {digest}; floors={counts[0]} rooms={counts[1]} '
              f'nodes={counts[2]} edges={counts[3]}', file=output)
    print(f'PASS: campuses={len(CAMPUS_IDS)} floors={total[0]} rooms={total[1]} '
          f'nodes={total[2]} edges={total[3]}', file=output)


def main(*, environment=None, output=None, error_output=None, directory=BUNDLES, rpc=read_rpc):
    output = output or sys.stdout
    error_output = error_output or sys.stderr
    try:
        url, key = configuration(os.environ if environment is None else environment)
        verify(url, key, directory=directory, rpc=rpc, output=output)
        return 0
    except VerificationError as error:
        print(f'FAIL: {error}', file=error_output)
    except Exception:
        print('FAIL: Verification could not complete', file=error_output)
    return 1


if __name__ == '__main__':
    sys.exit(main())
