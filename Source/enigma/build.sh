#!/usr/bin/env bash
# Build GG2 with ENIGMA: prebuild rewrite -> GmkSplitter -> emake.
# Usage: build.sh [--codegen-only] [--headless]
# Env:
#   GMKSPLIT     path to gmksplit.jar (default: downloaded into build-tools/)
#   FAUCET_SRC   Faucet-Networking-Extension checkout, modern-boost branch
#   ENIGMA_ROOT  ENIGMA with emake built, from the jaasonw/enigma-dev gg2-fixes
#                branch (default /opt/enigma-dev-git)
#   WORK         build dir (default ./build under this directory)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/../gg2"
WORK="${WORK:-$HERE/build}"
ENIGMA_ROOT="${ENIGMA_ROOT:-/opt/enigma-dev-git}"
GMKSPLIT="${GMKSPLIT:-$HERE/build-tools/GmkSplitter.v0.18/gmksplit.jar}"
if [[ ! -f "$GMKSPLIT" ]]; then
  mkdir -p "$HERE/build-tools"
  curl -sSL -o "$HERE/build-tools/gmksplit.zip" \
    https://github.com/Medo42/Gmk-Splitter/releases/download/V0.18/GmkSplitter.v0.18.zip
  unzip -qo "$HERE/build-tools/gmksplit.zip" -d "$HERE/build-tools"
fi

mode=(-j"$(nproc)")
FAUCET_SRC="${FAUCET_SRC:-$HOME/github/Faucet-Networking-Extension}" # modern-boost branch
prebuild_flags=(--stub-extensions --faucet-src "$FAUCET_SRC") # stubs: UPnP only
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

REAL_GXX="$(command -v g++)"
TOOLCHAIN_LIB="$WORK/toolchain"
mkdir -p "$TOOLCHAIN_LIB"
# emake writes into the tree it runs from; build from a copy of $ENIGMA_ROOT.
ENGINE="$HERE/build-tools/enigma-engine"
mkdir -p "$ENGINE"
rsync -a --delete --exclude /.git "$ENIGMA_ROOT/" "$ENGINE/"

# Faucet Networking as a shared library next to the game.
[[ -d "$FAUCET_SRC/faucet" ]] || { echo "set FAUCET_SRC to a Faucet-Networking-Extension checkout" >&2; exit 2; }
mkdir -p "$TOOLCHAIN_LIB/faucet"
FAUCET_ACCEPTOR="$TOOLCHAIN_LIB/CombinedTcpAcceptor.cpp"
python3 "$HERE/toolchain/patch_faucet.py" \
  "$FAUCET_SRC/faucet/tcp/CombinedTcpAcceptor.cpp" "$FAUCET_ACCEPTOR"
for f in $(find "$FAUCET_SRC/faucet" -name '*.cpp'); do
  o="$TOOLCHAIN_LIB/faucet/$(echo "${f#"$FAUCET_SRC/"}" | tr / _).o"
  source="$f"
  [[ "$f" != "$FAUCET_SRC/faucet/tcp/CombinedTcpAcceptor.cpp" ]] || source="$FAUCET_ACCEPTOR"
  [[ "$o" -nt "$source" ]] || "$REAL_GXX" -std=c++17 -O2 -fPIC -I"$FAUCET_SRC" -I"$FAUCET_SRC/faucet/tcp" \
    '-D__declspec(x)=__attribute__((visibility("default")))' -c "$source" -o "$o"
done
"$REAL_GXX" -shared -o "$WORK/libfaucetnet.so" "$TOOLCHAIN_LIB"/faucet/*.o -lboost_thread -lpthread

# GG2DLL as a shared library next to the game (loaded with external_define).
GG2DLL_SRC="$HERE/../../Extensions/GG2DLL/GG2DLL"
cc -O2 -fPIC -c "$GG2DLL_SRC/md5.c" -o "$TOOLCHAIN_LIB/md5.o"
"$REAL_GXX" -std=c++17 -O2 -fPIC -shared -o "$WORK/libgg2dll.so" \
  "$GG2DLL_SRC/GG2DLL.cpp" "$TOOLCHAIN_LIB/md5.o" -lpng -lz
(cd "$HERE" && python3 test_prebuild.py >/dev/null && rm -rf __pycache__)
python3 "$HERE/prebuild.py" "$SRC" "$WORK/src/gg2" "${prebuild_flags[@]}"
rm -f "$WORK/gg2.gmk" # gmksplit won't overwrite
(cd "$WORK/src" && java -jar "$GMKSPLIT" gg2 "$WORK/gg2.gmk" >/dev/null)

set +e
(cd "$ENGINE" && ./emake "$WORK/gg2.gmk" -o "$WORK/gg2" -d "$WORK/obj/" -k "$WORK/codegen/" \
  "${systems[@]}" -c Precise \
  -e Alarms,Paths,libpng,DataStructures,Timelines,ParticleSystems,IniFilesystem,ExternalFuncs,DateTime,RegistrySpoof \
  "${mode[@]}") 2>&1 | tee "$WORK/emake.log"
status=${PIPESTATUS[0]}
set -e
# GM8 embeds Included Files; ENIGMA builds ship them next to the binary.
find "$SRC/Included Files" -maxdepth 1 -type f ! -name '*.xml' -exec cp -t "$WORK" {} +
# game_init loads music from disk at startup.
if [[ -z "${headless:-}" ]]; then cp -a "$HERE/../../Music" "$WORK/"; fi

errors=$(grep -c ' error: \|Syntax error\|Semantic error' "$WORK/emake.log" || true)
echo "emake exit $status, $errors errors, log: $WORK/emake.log"
exit "$status"
