import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs

ROOT = Path(__file__).resolve().parent / "source"
PAGE = b'''<!doctype html><meta charset="utf-8"><title>Local map capture</title>
<form method="post"><label for="capture">Map capture JSON</label>
<textarea id="capture" name="capture"></textarea><button>Save capture</button></form>'''


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(PAGE)

    def do_POST(self):
        if self.headers.get("Origin") != "http://127.0.0.1:58422":
            self.send_error(403)
            return
        size = int(self.headers.get("Content-Length", "0"))
        if not 0 < size < 16_000_000:
            self.send_error(413)
            return
        try:
            data = json.loads(parse_qs(self.rfile.read(size).decode())["capture"][0])
            campus = data["campus"]
            floor = str(data["floor"])
            if campus not in ("v-78", "v-86", "s-20") or not floor.lstrip("-").isdigit():
                raise ValueError("Unexpected campus or floor")
            if not data["url"].startswith("https://pulse.mirea.ru/services/maps?"):
                raise ValueError("Unexpected source")
            if not isinstance(data.get("svg"), str) or not data["svg"].endswith("</svg>"):
                raise ValueError("Missing complete SVG")
            ROOT.mkdir(parents=True, exist_ok=True)
            (ROOT / f"{campus}_{floor}.json").write_text(
                json.dumps(data, ensure_ascii=False, separators=(",", ":")), encoding="utf-8"
            )
        except (KeyError, ValueError):
            self.send_error(400)
            return
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"<p>Saved capture.</p>" + PAGE)


if __name__ == "__main__":
    ThreadingHTTPServer(("127.0.0.1", 58422), Handler).serve_forever()
