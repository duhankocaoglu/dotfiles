#!/usr/bin/env bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# --- multi-monitor setup (uncomment to re-enable) ---
# for m in $(polybar --list-monitors | cut -d: -f1); do
#     MONITOR=$m polybar main &
# done

# --- single bar (current) ---
polybar main &
