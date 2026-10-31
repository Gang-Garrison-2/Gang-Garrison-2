#!/bin/bash
# Linux counterpart of build.bat, using Wine to run Game Maker 8 and gm8x_fix.
#
# SUMMARY:
# - Check prerequisites (gmksplit.jar, gm8x_fix.exe, Game Maker 8 in the Wine prefix)
# - Delete and recreate build folder
# - Generate gmk
# - Open GM8 and wait for it to close (create build/gg2.exe from it first)
# - Rename source and executable to "Gang Garrison 2"
# - Patch executable
# - Copy necessary files to build folder
# - Create zip (if 7z is installed)
#
# Environment:
#   GM8_EXE     Path to Game_Maker.exe
#               (default: "$WINEPREFIX/drive_c/Program Files (x86)/Game_Maker8/Game_Maker.exe")
#   WINEPREFIX  Wine prefix to use (default: ~/.wine)

set -e

info()    { printf '[\e[94m*\e[0m] %s\n' "$1"; }
success() { printf '[\e[92m+\e[0m] %s\n' "$1"; }
warn()    { printf '[\e[93m-\e[0m] %s\n' "$1"; }
fail()    { printf '[\e[91m---\e[0m] %s\n' "$1"; exit 1; }

assert_exists() {
    [ -e "$1" ] || fail "$1 not found, aborting"
    success "$1 found"
}

cd "$(dirname "$(readlink -f "$0")")"

WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
export WINEPREFIX
GM8_EXE="${GM8_EXE:-$WINEPREFIX/drive_c/Program Files (x86)/Game_Maker8/Game_Maker.exe}"
export WINEDEBUG="${WINEDEBUG:--all}"

# CHECK PREREQUISITES
command -v wine > /dev/null || fail "Wine is required"
command -v java > /dev/null || fail "Java is required to run gmksplit.jar"
[ -f "gmksplit.jar" ] || fail "GmkSplitter is required: https://github.com/Medo42/Gmk-Splitter"
[ -f "gm8x_fix.exe" ] || fail "gm8x_fix is required: https://github.com/skyfloogle/gm8x_fix"
[ -f "$GM8_EXE" ] || fail "Game Maker 8 not found at $GM8_EXE (set GM8_EXE)"

# RECREATE BUILD FOLDER
rm -rf build
mkdir build

# GENERATE GMK
info "Generating .gmk from git..."
java -jar gmksplit.jar --charset windows-1252 gg2 build/gg2.gmk
assert_exists "build/gg2.gmk"

# OPEN GM8 AND WAIT FOR IT TO CLOSE
info "Opening Game Maker 8..."
warn "Use File -> Create Executable, save as $(winepath -w build/gg2.exe), then close Game Maker"
gmk_winpath="$(winepath -w build/gg2.gmk)"
(cd "$(dirname "$GM8_EXE")" && wine "$(basename "$GM8_EXE")" "$gmk_winpath")
assert_exists "build/gg2.exe"
# GM8 leaves a backup (gg2.gb1, ...) next to the gmk if the project was saved
rm -f build/gg2.gb[0-9]

# RENAME SOURCE AND EXECUTABLE
info "Renaming source and executable..."
mv build/gg2.gmk "build/Gang Garrison 2.gmk"
mv build/gg2.exe "build/Gang Garrison 2.exe"

# PATCH EXECUTABLE
info "Patching executable..."
if wine gm8x_fix.exe -nb -s "build/Gang Garrison 2.exe" < /dev/null; then
    success "Executable patched"
else
    warn "gm8x_fix exited with an error (it also does this when there is nothing left to patch)"
fi

# COPYING FILES: Text files
info "Copying text files..."
cp "../7zip.license.txt" "../How To Play.txt" "../miniupnp.license.txt" \
   "../MPL-2.0.txt" "../Readme.txt" "../sampleMapRotation.txt" build/

# COPYING FILES: Sources
info "Copying source files..."
mkdir build/Source
cp "../UUIDGenerator.html" ../Extensions/*.gex build/Source/
# ...also move gmk to Source subfolder
mv "build/Gang Garrison 2.gmk" build/Source/

# COPYING FILES: Music
info "Copying music files..."
cp -r ../Music build/Music

# CREATE ZIP
if command -v 7z > /dev/null; then
    rm -f build.zip
    (cd build && 7z a -tzip ../build.zip . > /dev/null)
    success "Created build.zip"
else
    warn "7z not found, skipping build.zip"
fi

success "Done"
