#!/usr/bin/env bash
# Smoke test for the headless server: start it from a temp copy of the build,
# check it listens and answers the GG2 join handshake like a GM8 server.
# Usage: smoke_headless.sh [build dir] [map]   (default: build-headless, random map)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BUILD="${1:-$HERE/build-headless}"
PORT=8190
MAP="${2:-}"
RUN="$(mktemp -d)"
cleanup() {
  status=$?
  if ((status != 0)) && [[ -n "${pid:-}" ]]; then
    ps -p "$pid" -o pid,stat,etime,wchan:25,comm || true
  fi
  if [[ -n "${pid:-}" ]]; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  fi
  if ((status != 0)) && [[ -f "$RUN/server.log" ]]; then
    sed '/Failed to load sound/d' "$RUN/server.log" | tail -30
  fi
  rm -rf "$RUN"
}
trap cleanup EXIT

# The game writes gg2.ini, Maps/ etc. next to itself: run from a copy.
cp "$BUILD"/gg2 "$BUILD"/*.so "$BUILD"/*.png "$RUN"/
cd "$RUN"
args=(-dedicated)
[[ -z "$MAP" ]] || args+=(-map "$MAP")
env -u DISPLAY -u WAYLAND_DISPLAY ./gg2 "${args[@]}" >server.log 2>&1 &
pid=$!

python3 - "$PORT" "$MAP" <<'PY'
import socket, sys, time, uuid
PROTOCOL_UUID = "b31c2209-4256-9a19-d0ef-c71c5373bd75"
deadline = time.monotonic() + 10
while True:
    try:
        s = socket.create_connection(("127.0.0.1", int(sys.argv[1])), timeout=5)
        break
    except OSError:
        if time.monotonic() >= deadline:
            raise
        time.sleep(0.2)
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
assert not sys.argv[2] or fields[1] == sys.argv[2], f"wrong map: {fields[1]}"
assert plugins_required == 0 and plugin_list_len == 0, "unexpected plugin list"
print(f"handshake OK: server={fields[0]!r} map={fields[1]!r}")
PY

kill -0 "$pid" 2>/dev/null || { echo "server exited early:"; cat server.log; exit 1; }
echo "server still running after handshake: OK"
