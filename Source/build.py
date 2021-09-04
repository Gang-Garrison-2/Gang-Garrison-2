# PrOF 2021

# Build script for Gang Garrison 2

# Any copyright is dedicated to the Public Domain.
# https://creativecommons.org/publicdomain/zero/1.0/

import os, subprocess, shutil
from datetime import date

def main():

    # Check prerequisites
    if not os.path.exists("gmksplit.exe"):
        print_fail("GmkSplitter is required: https://github.com/Medo42/Gmk-Splitter")
        terminate()
    if not os.path.exists("gm8x_fix.exe"):
        print_fail("gm8x_fix is required: https://github.com/skyfloogle/gm8x_fix")
        terminate()

    # Delete older files
    deletelist = ["gg2.gmk", "Gang Garrison 2.gmk", "gg2.exe", "Gang Garrison 2.exe"]
    for filepath in deletelist:
        if os.path.exists(filepath):
            os.remove(filepath)
            print_info(f"Deleted [{filepath}]")
    if os.path.exists("Source"):
        shutil.rmtree("Source")
        print_info("Deleted [/Source/]")

    # Recreate gmk
    print_info("Generating gmk from git...")
    gittogmk = from_current_dir("GitToGmk.bat")
    subprocess.call(gittogmk, cwd=script_dir)
    print_success("Generated gmk")

    # Open Game Maker, wait for exe creation
    print_warn("Opening Game Maker 8...")
    os.system("start gg2.gmk")
    print_warn("Enter \"continue\" after creating the executable")
    while True:
        command = input()
        if command.casefold() == "continue":
            break

    # Rename source gmk
    os.rename("gg2.gmk", "Gang Garrison 2.gmk")

    # Rename executable and patch it
    os.rename("gg2.exe", "Gang Garrison 2.exe")
    print_info("Patching executable...")
    gm8x_fix = from_current_dir("gm8x_fix.exe")
    subprocess.call([gm8x_fix, "-nb", "-s", "Gang Garrison 2.exe"], cwd=script_dir)
    print_success("Executable patched")

    # Copy files to temp directory to create the correct folder structure for the zip
    os.mkdir("Source")
    copyfiles = ["Gang Garrison 2.gmk", "../UUIDGenerator.html"]
    copyfiles.extend(["../Extensions/" + f for f in os.listdir(os.path.join(script_dir, "../Extensions/")) if os.path.splitext(f)[1] == ".gex"])
    print_info("Grouping Source files:", copyfiles)
    for file in copyfiles:
        shutil.copy2(file, "Source/")

    # Create zip using bundled 7za
    seven_zip = from_current_dir("gg2/Included Files/7za.exe")
    sevenz_args = ["a", "-tzip", f"build-{date.today().strftime('%Y-%m-%d')}.zip",
        "Gang Garrison 2.exe",
        "../7zip.license.txt",
        "../How To Play.txt",
        "../miniupnp.license.txt",
        "../MPL-2.0.txt",
        "../Readme.txt",
        "../sampleMapRotation.txt",
        "../Music",
        "Source",
    ]
    print_info("Creating .zip file...")
    subprocess.call([seven_zip, *sevenz_args], cwd=script_dir)

    # Clean temp Source folder
    print_info("Cleaning...")
    shutil.rmtree("Source")

    # Done
    print_success("Build complete.")


def print_info(output, *args):
    print("[\033[94m*\033[0m] " + output, *args)

def print_success(output, *args):
    print("[\033[92m+\033[0m] " + output, *args)

def print_warn(output, *args):
    print("[\033[93m-\033[0m] " + output, *args)

def print_fail(output, *args):
    print("[\033[91m---\033[0m] " + output, *args)

def from_current_dir(dest):
    return os.path.join(script_dir, dest)

def terminate():
    input()
    exit()


if __name__ == "__main__":
    os.system("color")

    script_dir = os.path.abspath(os.path.dirname(__file__))
    os.chdir(script_dir)

    main()
    terminate()