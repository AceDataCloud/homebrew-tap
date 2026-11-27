"""Exercise the installed Homebrew binary against the published API shapes using loopback."""

import json
import os
import subprocess
import sys
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


CASES = [
    (["image", "fox", "--service", "gpt-image", "--model", "gpt-image-2", "--json"],
     "/openai/images/generations", {"model": "gpt-image-2", "prompt": "fox"},
     {"created": 125, "data": [{"url": "https://example.com/image.png"}]}),
    (["image", "edit", "--service", "gpt-image", "--model", "gpt-image-2", "--image-url", "https://example.com/ref.png", "--async", "--json"],
     "/openai/images/edits", {"model": "gpt-image-2", "prompt": "edit", "image": "https://example.com/ref.png", "async": True},
     {"task_id": "image42"}),
    (["task", "image42", "--service", "gpt-image", "--json"], "/openai/tasks", {"action": "retrieve", "id": "image42"},
     {"id": "image42", "response": {"created": 126, "data": [{"b64_json": "YWJjZA=="}]}}),
    (["video", "pan", "--service", "kling", "--model", "kling-v3", "--mode", "pro", "--duration", "5", "--json"],
     "/kling/videos", {"action": "text2video", "prompt": "pan", "model": "kling-v3", "mode": "pro", "duration": 5, "async": True},
     {"task_id": "clip42"}),
    (["video", "pan", "--service", "kling", "--image-url", "https://example.com/frame.jpg", "--json"],
     "/kling/videos", {"action": "image2video", "prompt": "pan", "start_image_url": "https://example.com/frame.jpg", "async": True},
     {"task_id": "clip43"}),
    (["wait", "clip42", "--service", "kling", "--json"], "/kling/tasks", {"action": "retrieve", "id": "clip42"},
     {"id": "clip42", "response": {"success": True, "video_url": "https://example.com/result.mp4"}}),
]


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        _, path, payload, answer = self.server.case
        body = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
        if self.path != path or body != payload or self.headers.get('Authorization') != 'Bearer tap-test':
            self.send_error(400, 'Unexpected fixture request')
            return
        raw = json.dumps(answer).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(raw)))
        self.end_headers()
        self.wfile.write(raw)
        self.server.calls.append(self.path)


if __name__ == '__main__':
    binary = sys.argv[1]
    with ThreadingHTTPServer(('127.0.0.1', 0), Handler) as server:
        env = dict(os.environ, ACEDATACLOUD_API_TOKEN='tap-test', ACEDATACLOUD_API_BASE_URL=f'http://127.0.0.1:{server.server_port}', NO_PROXY='127.0.0.1')
        server.calls = []
        worker = threading.Thread(target=server.serve_forever, daemon=True)
        worker.start()
        try:
            for case in CASES:
                server.case = case
                result = subprocess.run([binary, *case[0]], env=env, text=True, capture_output=True, check=True, timeout=20)
                assert json.loads(result.stdout) == case[3], case[0]
            assert server.calls == [case[1] for case in CASES]
            print(json.dumps({'binary': binary, 'version': subprocess.check_output([binary, '--version'], text=True).strip(),
                              'verified_paths': server.calls, 'paid_calls': 0}))
        finally:
            server.shutdown()
            worker.join()
