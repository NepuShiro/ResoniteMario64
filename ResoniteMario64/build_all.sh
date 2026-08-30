#!/usr/bin/env bash

set -e

REPO_DIR="./libsm64"

ARTIFACT_DIR="$REPO_DIR/dist"
DEST_DIR="./libsm64/Plugins"

copy_and_replace() {
    if [ -d "$ARTIFACT_DIR" ]; then
        mkdir -p "$DEST_DIR"
        rsync -a "$ARTIFACT_DIR/" "$DEST_DIR/"
    else
        echo "Artifact directory not found: $ARTIFACT_DIR"
        exit 1
    fi
}

echo "=== Native build ==="
cd "$REPO_DIR"
make clean
make lib

copy_and_replace

echo "=== Windows cross compile ==="
make clean
OS=Windows_NT make lib -j "$(nproc)" CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++

copy_and_replace

echo "=== Done ==="
