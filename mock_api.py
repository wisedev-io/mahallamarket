#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import json, re

MOCK_FEED = [{"id": str(i), "title": f"Sample Post #{i}", "body": "This is a mock post."} for i in range(1,13)]
MOCK_HOME = {"welcome":"Hello from mock API","highlights":[{"id":"h1","text":"Deal of the day"},{"id":"h2","text":"Popular nearby"}]}

class Handler(BaseHTTPRequestHandler):
    def _cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Authorization")

    def do_OPTIONS(self):
        self.send_response(204); self._cors(); self.end_headers()

    def do_GET(self):
        path = self.path or "/"
        self.send_response(200); self._cors(); self.send_header("Content-Type","application/json; charset=utf-8")
        self.end_headers()
        if re.search(r"/feed/?$", path):
            self.wfile.write(json.dumps(MOCK_FEED).encode("utf-8"))
        elif re.search(r"/home/?$", path):
            self.wfile.write(json.dumps(MOCK_HOME).encode("utf-8"))
        else:
            # default: return something sane so callers don't hang
            self.wfile.write(json.dumps({"ok":True,"path":path,"feed":MOCK_FEED[:5]}).encode("utf-8"))

if __name__ == "__main__":
    # use 0.0.0.0 so Codespaces exposes it; default port 9000
    HTTPServer(("0.0.0.0", 9000), Handler).serve_forever()
