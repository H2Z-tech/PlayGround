#!/usr/bin/env bash
set -euo pipefail
time -p cd "$(dirname "$0")"
if [[ -z "${CAPTURE_URL:-}" ]]; then
  echo 'Set CAPTURE_URL.' >&2
  exit 1
fi
if [[ -z "${CAPTURE_DIR:-}" ]]; then
  echo 'Set CAPTURE_DIR.' >&2
  exit 1
fi
time -p mkdir -p "$CAPTURE_DIR"
RUNTIME_DIR="${RUNTIME_DIR:-/home/runner/work/_temp/omgithub-runtime}"
time -p test -f "$RUNTIME_DIR/scripts/default-capture.mjs"
time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
time -p test -f "$CAPTURE_DIR/final-desktop.png"
time -p test -f "$CAPTURE_DIR/final-mobile.png"
