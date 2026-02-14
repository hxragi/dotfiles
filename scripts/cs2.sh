#!/bin/bash

STATE_FILE="$HOME/.resolution_state"
OUTPUT="HDMI-A-2"

if [ -f "$STATE_FILE" ]; then
    # Возвращаем 1920x1080 @ 180Hz
    echo "Возвращаем 1920x1080@180 на $OUTPUT"
    niri msg output "$OUTPUT" mode 1920x1080@180
    rm "$STATE_FILE"
else
    # Переключаемся на 1440x1080 @ 180Hz
    echo "Переключаемся на 1440x1080@180 на $OUTPUT"
    niri msg output "$OUTPUT" mode 1440x1080@180
    touch "$STATE_FILE"
fi
