import json
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs

ROOT = Path(__file__).resolve().parent / 'source'
CAMPUSES = {
    'v-78': '019f9340-d2cc-7c8a-8472-2cbcc2dd3de3',
    'v-86': '01a023a4-e394-7f10-a979-16f396473e1e',
    's-20': '01a038f2-df0e-7324-9c5a-73b1766851af',
}
FORM = '''<!doctype html><html lang="ru"><meta charset="utf-8"><title>Импорт плана кампуса</title>
<h1>Сохранить исходный план кампуса</h1><form method="post" action="/capture">
<label>Кампус<select name="campus"><option>v-86</option><option>v-78</option><option>s-20</option></select></label>
<label>План JSON<textarea name="plan" rows="12" cols="80"></textarea></label>
<button>Сохранить план</button></form></html>'''


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *_):
        pass

    def reply(self, code, body):
        data = body.encode('utf-8')
        self.send_response(code)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Content-Length', str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path != '/':
            return self.reply(404, 'Not found')
        self.reply(200, FORM)

    def do_POST(self):
        if self.path != '/capture' or self.headers.get('Origin') != 'http://127.0.0.1:58423':
            return self.reply(403, 'Invalid capture origin')
        try:
            size = int(self.headers.get('Content-Length', 0))
            if size <= 0 or size > 30000000:
                raise ValueError('Invalid size')
            fields = parse_qs(self.rfile.read(size).decode('utf-8'))
            campus = fields['campus'][0]
            source_id = CAMPUSES[campus]
            plan = json.loads(fields['plan'][0])
            if not isinstance(plan.get('layers'), dict) or not isinstance(plan.get('meta'), dict):
                raise ValueError('Invalid plan')
            capture = {
                'campus': campus,
                'source_campus_id': source_id,
                'source_url': f'https://pulse.mirea.ru/services/maps?campus={source_id}',
                'captured_at': datetime.now(timezone.utc).isoformat(),
                'capture_method': 'authenticated_GetCampus_response',
                'plan': plan,
            }
            path = ROOT / f'{campus}_plan.json'
            path.write_text(json.dumps(capture, ensure_ascii=False, separators=(',', ':')) + '\n', encoding='utf-8')
            self.reply(200, f'<meta charset="utf-8"><h1>Сохранено: {campus}</h1><a href="/">Следующий кампус</a>')
            print(f'Saved {campus}: {len(plan["layers"])} floors, {path.stat().st_size} bytes', flush=True)
        except (KeyError, ValueError, TypeError) as error:
            self.reply(400, f'Invalid capture: {type(error).__name__}')


if __name__ == '__main__':
    print('Capture form: http://127.0.0.1:58423', flush=True)
    ThreadingHTTPServer(('127.0.0.1', 58423), Handler).serve_forever()
