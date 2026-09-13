#!/bin/bash
status=$(playerctl --player=spotify status 2>/dev/null)

if [ "$status" != "Playing" ]; then
  exit 0
fi

frames=(
  "▁▃▅▇"
  "▃▅▇▅"
  "▅▇▅▃"
  "▇▅▃▁"
  "▅▃▁▃"
  "▃▁▃▅"
)
i=$(( ($(date +%s%N) / 200000000) % ${#frames[@]} ))
echo "${frames[$i]}"
