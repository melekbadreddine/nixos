#!/bin/bash
# =============================================================
# wall-select.sh - Wallpaper picker (wrapper for GTK version)
# SUPER+SHIFT+W
# =============================================================

set -euo pipefail

MANGO_DIR="$HOME/.config/mango"

# Launch GTK wallpaper picker
python3 "$MANGO_DIR/bin/wall-select.py"
