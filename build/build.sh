#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if command -v darklua >/dev/null 2>&1; then
    DARKLUA=(darklua)
elif command -v rokit >/dev/null 2>&1; then
    DARKLUA=(rokit run darklua)
else
    echo "[ERROR] Darklua is not installed or not on PATH." >&2
    echo "Install: https://darklua.com/docs/getting-started/" >&2
    exit 1
fi

mkdir -p dist
echo "[FlurioreLib] Bundling source with Darklua..."
"${DARKLUA[@]}" process "FlurioreLib/init.lua" "dist/FlurioreLib.lua" --config "build/darklua.config.json"
echo "[OK] Generated dist/FlurioreLib.lua"
