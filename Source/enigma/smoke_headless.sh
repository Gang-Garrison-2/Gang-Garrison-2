#!/usr/bin/env bash
# Smoke test for the headless server: start it from a temp copy of the build,
# check it listens and answers the GG2 join handshake like a GM8 server.
# Usage: smoke_headless.sh [build dir]   (default: build-headless)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BUILD="${1:-$HERE/build-headless}"
PORT=8190
RUN="$(mktemp -d)"
trap 'kill "$pid" 2>/dev/null || true; rm -rf "$RUN"' EXIT

# The game writes gg2.ini, Maps/ etc. next to itself: run from a copy.
cp "$BUILD"/gg2 "$BUILD"/*.so "$BUILD"/*.png "$RUN"/
cd "$RUN"
env -u DISPLAY -u WAYLAND_DISPLAY ./gg2 -dedicated >server.log 2>&1 &
pid=$!

for _ in $(seq 50); do
  (echo >"/dev/tcp/127.0.0.1/$PORT") 2>/dev/null && break
  sleep 0.2
done

python3 - "$PORT" <<'PY'
import socket, sys, uuid
PROTOCOL_UUID = "b31c2209-4256-9a19-d0ef-c71c5373bd75"
s = socket.create_connection(("127.0.0.1", int(sys.argv[1])), timeout=5)
s.sendall(b"\x00" + uuid.UUID(PROTOCOL_UUID).bytes)  # HELLO + protocol UUID
buf = b""
def need(n):
    global buf
    while len(buf) < n:
        chunk = s.recv(4096)
        assert chunk, "server closed the connection"
        buf += chunk
need(1); assert buf[0] == 0, f"expected HELLO, got {buf[0]}"
pos = 1
fields = []
for _ in range(3):  # server name, map, map md5
    need(pos + 1); n = buf[pos]; need(pos + 1 + n)
    fields.append(buf[pos + 1:pos + 1 + n].decode()); pos += 1 + n
need(pos + 3)
plugins_required, plugin_list_len = buf[pos], int.from_bytes(buf[pos + 1:pos + 3], "little")
assert fields[1], "no map name"
assert plugins_required == 0 and plugin_list_len == 0, "unexpected plugin list"
print(f"handshake OK: server={fields[0]!r} map={fields[1]!r}")
PY

kill -0 "$pid" 2>/dev/null || { echo "server exited early:"; cat server.log; exit 1; }
echo "server still running after handshake: OK"
