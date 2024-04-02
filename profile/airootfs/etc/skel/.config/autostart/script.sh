#!/bin/bash

THEMES_DIR="$HOME/.config/xfce-themes"
CURRENT="$THEMES_DIR/.current"

if [ -f "$CURRENT" ]; then
    selected=$(cat "$CURRENT")
    "$HOME"/.config/xfce-themes/apply.sh "$selected"
fi

