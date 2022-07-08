@echo off
rem PrOF 2022

goto postsummary
    SUMMARY:
    - Check prerequisites (gmksplitter and gm8x_fix)
    - Delete and recreate build folder
    - Generate gmk
    - Open GM8 and wait for exe creation
    - Rename source and executable to "Gang Garrison 2"
    - Patch executable
    - Copy necessary files to build folder
    - Create zip
:postsummary

setlocal

rem CHECK PREREQUISITES
if not exist "gmksplit.exe" (
    call :SUB_fail "GmkSplitter is required: https://github.com/Medo42/Gmk-Splitter"
    pause
    exit 1
)
if not exist "gm8x_fix.exe" (
    call :SUB_fail "gm8x_fix is required: https://github.com/skyfloogle/gm8x_fix"
    pause
    exit 1
)

rem RECREATE BUILD FOLDER
rmdir /S /Q build 2> nul
mkdir build

rem GENERATE GMK
call :SUB_info "Generating .gmk from git..."
gmksplit.exe gg2 build\gg2.gmk
call :SUB_assert_exists "build\gg2.gmk"

rem OPEN GM8 AND WAIT FOR EXE CREATION
call :SUB_info "Opening Game Maker 8..."
call :SUB_info "Waiting for gg2.exe creation..."
start /W build\gg2.gmk
call :SUB_assert_exists "build\gg2.exe"

rem RENAME SOURCE AND EXECUTABLE
call :SUB_info "Renaming source and executable..."
ren build\gg2.gmk "Gang Garrison 2.gmk"
ren build\gg2.exe "Gang Garrison 2.exe"

rem PATCH EXECUTABLE
call :SUB_info "Patching executable..."
gm8x_fix.exe -nb -s "build\Gang Garrison 2.exe"
call :SUB_assert_errorlevel_0 "Patching executable failed, aborting"
call :SUB_success "Executable patched"

rem COPYING FILES: Text files
call :SUB_info "Copying text files..."
copy "..\7zip.license.txt" build\
copy "..\How To Play.txt" build\
copy "..\miniupnp.license.txt" build\
copy "..\MPL-2.0.txt" build\
copy "..\Readme.txt" build\
copy "..\sampleMapRotation.txt" build\

rem COPYING FILES: Sources
call :SUB_info "Copying source files..."
mkdir build\Source
copy "..\UUIDGenerator.html" build\Source\
robocopy /njh /njs /ndl /nc /ns "..\Extensions" .\build\Source *.gex
rem ...also move gmk to Source subfolder
move "build\Gang Garrison 2.gmk" build\Source\

rem COPYING FILES: Music
call :SUB_info "Copying music files..."
robocopy /njh /njs /ndl /nc /ns "..\Music" .\build\Music

rem CREATE ZIP
rem use portable 7za in repository
"gg2\Included Files\7za.exe" a -tzip build.zip .\build\*

rem SUCCESS
call :SUB_success "Done"
pause
exit

rem --- SUBROUTINES ---

:SUB_assert_exists
    if not exist "%~1" (
        call :SUB_fail "%~1 not found, aborting"
        pause
        exit 1
    )
    rem else found
    call :SUB_success "%~1 found"
    exit /B

:SUB_assert_errorlevel_0
    if errorlevel 1 (
        call :SUB_fail "%~1"
        pause
        exit 1
    )
    exit /B

:SUB_info
    echo [[94m*[0m] %~1
    exit /B
:SUB_success
    echo [[92m+[0m] %~1
    exit /B
:SUB_warn
    echo [[93m-[0m] %~1
    exit /B
:SUB_fail
    echo [[91m---[0m] %~1
    exit /B
