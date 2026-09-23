#!/usr/bin/env bash
# Build GG2 with ENIGMA: prebuild rewrite -> GmkSplitter -> emake.
# Usage: build.sh [--codegen-only] [--headless]
# Env:
#   GMKSPLIT     path to gmksplit.jar (https://github.com/Medo42/Gmk-Splitter), required
#   ENIGMA_ROOT  ENIGMA checkout with emake built (default /opt/enigma-dev-git)
#   WORK         build dir (default ./build under this directory)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/../gg2"
WORK="${WORK:-$HERE/build}"
ENIGMA_ROOT="${ENIGMA_ROOT:-/opt/enigma-dev-git}"
: "${GMKSPLIT:?set GMKSPLIT to the path of gmksplit.jar}"

mode=(-j"$(nproc)")
systems=(-p xlib -g OpenGL1 -a OpenAL -w None)
for arg in "$@"; do
  case "$arg" in
    --codegen-only) mode=(--codegen-only) ;;
    --headless) systems=(-p None -g None -a None -w None) ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

mkdir -p "$WORK"
# --stub-extensions until Faucet/GG2DLL are built as native libraries.
python3 "$HERE/prebuild.py" "$SRC" "$WORK/src/gg2" --stub-extensions
rm -f "$WORK/gg2.gmk" # gmksplit won't overwrite
(cd "$WORK/src" && java -jar "$GMKSPLIT" gg2 "$WORK/gg2.gmk" >/dev/null)

cd "$ENIGMA_ROOT"
set +e
./emake "$WORK/gg2.gmk" -o "$WORK/gg2" -d "$WORK/obj/" -k "$WORK/codegen/" \
  "${systems[@]}" -c Precise \
  -e Alarms,Paths,libpng,DataStructures,Timelines,ParticleSystems,IniFilesystem,ExternalFuncs,DateTime \
  "${mode[@]}" >"$WORK/emake.log" 2>&1
status=$?
set -e

# emake exits 0 even when resource transfer fails and drops resources.
if grep -q 'Transfer error' "$WORK/emake.log"; then
  echo "resource transfer failed, see $WORK/emake.log" >&2
  exit 1
fi
errors=$(grep -c ' error: \|Syntax error\|Semantic error' "$WORK/emake.log" || true)
echo "emake exit $status, $errors errors, log: $WORK/emake.log"
exit "$status"
