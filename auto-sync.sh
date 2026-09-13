#!/bin/bash
cd "$HOME/dotfiles" || exit 1
while true; do
  inotifywait -r -e modify,create,delete,move --exclude '\.git' "$HOME/dotfiles" >/dev/null 2>&1
  sleep 5
  if [ -n "$(git status --porcelain)" ]; then
    msg=$(rofi -dmenu -p "Commit message:" -l 0)
    if [ -z "$msg" ]; then
      msg="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    git add -A
    git commit -m "$msg"
    git push
  fi
done
