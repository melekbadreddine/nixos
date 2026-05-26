#!/bin/bash
# layout-switcher.sh - Waybar custom module for mango layout display

set -euo pipefail

# Layout mappings: code -> name
declare -A LAYOUTS=(
    [T]="Tile"
    [S]="Scroller"
    [G]="Grid"
    [M]="Monocle"
    [K]="Deck"
    [CT]="Center Tile"
    [RT]="Right Tile"
    [VS]="Vertical Scroller"
    [VT]="Vertical Tile"
    [VG]="Vertical Grid"
    [VK]="Vertical Deck"
    [TG]="TGMix"
)

# Get all state from mango
state=$(mmsg -g 2>/dev/null || echo "")

if [[ -z "$state" ]]; then
    echo '{"text":"N/A","tooltip":"Mango WM not running"}'
    exit 0
fi

# Find the focused monitor (selmon 1)
focused_mon=$(echo "$state" | grep "selmon 1" | awk '{print $1}')

if [[ -z "$focused_mon" ]]; then
    echo '{"text":"N/A","tooltip":"No focused monitor"}'
    exit 0
fi

# Get layout for the focused monitor
code=$(echo "$state" | grep "^${focused_mon} layout " | awk '{print $NF}')

if [[ -z "$code" ]] || [[ -z "${LAYOUTS[$code]+x}" ]]; then
    echo "{\"text\":\"$code\",\"tooltip\":\"Unknown layout: $code\"}"
    exit 0
fi

name="${LAYOUTS[$code]}"

echo "{\"text\":\"$name\",\"tooltip\":\"Layout: $name ($code)\nClick to change\"}"
