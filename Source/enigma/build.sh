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
prebuild_flags=(--stub-extensions) # until Faucet/GG2DLL are built as native libraries
systems=(-p xlib -g OpenGL1 -a OpenAL -w xlib) # dialogs via zenity/kdialog
for arg in "$@"; do
  case "$arg" in
    --codegen-only) mode=(--codegen-only) ;;
    --headless)
      systems=(-p None -g None -a None -w None)
      prebuild_flags+=(--headless)
      headless=1
      ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

mkdir -p "$WORK"

# Compat g++ wrapper (toolchain/g++): libprocps shim for xlib widgets, and
# graphics/audio stubs for headless links.
export REAL_GXX="$(command -v g++)"
export TOOLCHAIN_LIB="$WORK/toolchain"
mkdir -p "$TOOLCHAIN_LIB"
ar rc "$TOOLCHAIN_LIB/libprocps.a" # xlib widgets link -lprocps; the shim is header-only
if [[ -n "${headless:-}" ]]; then
  export HEADLESS_STUBS_O="$TOOLCHAIN_LIB/headless_stubs.o"
  "$REAL_GXX" -std=c++17 -fPIC -I"$ENIGMA_ROOT/ENIGMAsystem/SHELL" \
    -c "$HERE/toolchain/headless_stubs.cpp" -o "$HEADLESS_STUBS_O"
fi
export PATH="$HERE/toolchain:$PATH"

# GG2DLL as a shared library next to the game (loaded with external_define).
GG2DLL_SRC="$HERE/../../Extensions/GG2DLL/GG2DLL"
cc -O2 -fPIC -c "$GG2DLL_SRC/md5.c" -o "$TOOLCHAIN_LIB/md5.o"
"$REAL_GXX" -std=c++17 -O2 -fPIC -shared -o "$WORK/libgg2dll.so" \
  "$GG2DLL_SRC/GG2DLL.cpp" "$TOOLCHAIN_LIB/md5.o" -lpng -lz
python3 "$HERE/prebuild.py" "$SRC" "$WORK/src/gg2" "${prebuild_flags[@]}"
rm -f "$WORK/gg2.gmk" # gmksplit won't overwrite
(cd "$WORK/src" && java -jar "$GMKSPLIT" gg2 "$WORK/gg2.gmk" >/dev/null)

cd "$ENIGMA_ROOT"
set +e
./emake "$WORK/gg2.gmk" -o "$WORK/gg2" -d "$WORK/obj/" -k "$WORK/codegen/" \
  "${systems[@]}" -c Precise \
  -e Alarms,Paths,libpng,DataStructures,Timelines,ParticleSystems,IniFilesystem,ExternalFuncs,DateTime,RegistrySpoof \
  "${mode[@]}" >"$WORK/emake.log" 2>&1
status=$?
set -e

# emake exits 0 even when resource transfer fails and drops resources.
# Same when writing resources into the game module fails.
if grep -qE 'Transfer error|have zero size|vary in dimensions' "$WORK/emake.log"; then
  echo "resource transfer/write failed, see $WORK/emake.log" >&2
  exit 1
fi
# GM8 embeds Included Files; ENIGMA builds ship them next to the binary.
find "$SRC/Included Files" -maxdepth 1 -type f ! -name '*.xml' -exec cp -t "$WORK" {} +

errors=$(grep -c ' error: \|Syntax error\|Semantic error' "$WORK/emake.log" || true)
echo "emake exit $status, $errors errors, log: $WORK/emake.log"
exit "$status"
