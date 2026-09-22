#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

packages=(
  alacritty
  base-devel
  bash-completion
  dmenu
  fd
  fzf
  git
  i3-wm
  i3status
  j4-dmenu-desktop
  kitty
  libnotify
  maim
  neovim
  networkmanager-dmenu
  playerctl
  polybar
  ripgrep
  ttf-jetbrains-mono-nerd
  xclip
  xorg-setxkbmap
  xorg-xinput
  xorg-xrandr
  xorg-xsetroot
)

usage() {
  cat <<'EOF'
Usage: ./install.sh [--no-packages]

Install and link these dotfiles on Arch Linux or an Arch-based distribution.

Options:
  --no-packages  Skip pacman and ble.sh installation; only create links.
  -h, --help     Show this help message.
EOF
}

install_packages=true
case "${1:-}" in
  "") ;;
  --no-packages) install_packages=false ;;
  -h|--help) usage; exit 0 ;;
  *) printf 'Unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
esac

if [[ $EUID -eq 0 ]]; then
  printf 'Run this script as your normal user, not as root. It will use sudo for pacman.\n' >&2
  exit 1
fi

if [[ ! -f "$REPO_ROOT/i3/config" || ! -f "$REPO_ROOT/nvim/init.lua" ]]; then
  printf 'Could not find the dotfiles next to install.sh. Run the script from a complete clone.\n' >&2
  exit 1
fi

if $install_packages; then
  if ! command -v pacman >/dev/null 2>&1; then
    printf 'This installer supports Arch Linux and Arch-based distributions with pacman only.\n' >&2
    exit 1
  fi

  printf 'Installing packages from the official Arch repositories...\n'
  sudo pacman -S --needed "${packages[@]}"

  if [[ ! -r "$HOME/.local/share/blesh/ble.sh" ]]; then
    printf 'Installing ble.sh under ~/.local...\n'
    temp_dir="$(mktemp -d)"
    trap 'rm -rf -- "$temp_dir"' EXIT
    git clone --recursive --depth 1 --shallow-submodules \
      https://github.com/akinomyoga/ble.sh.git "$temp_dir/ble.sh"
    make -C "$temp_dir/ble.sh" install PREFIX="$HOME/.local"
  fi
fi

backup_and_link() {
  local source_path="$1"
  local target_path="$2"
  local relative_target backup_path

  mkdir -p -- "$(dirname -- "$target_path")"

  if [[ -L "$target_path" ]] && \
     [[ "$(readlink -f -- "$target_path" 2>/dev/null || true)" == "$(readlink -f -- "$source_path")" ]]; then
    printf 'Already linked: %s\n' "$target_path"
    return
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    relative_target="${target_path#"$HOME"/}"
    backup_path="$BACKUP_ROOT/$relative_target"
    mkdir -p -- "$(dirname -- "$backup_path")"
    mv -- "$target_path" "$backup_path"
    printf 'Backed up: %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -s -- "$source_path" "$target_path"
  printf 'Linked: %s -> %s\n' "$target_path" "$source_path"
}

backup_and_link "$REPO_ROOT/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
backup_and_link "$REPO_ROOT/bash/bashrc" "$HOME/.bashrc"
backup_and_link "$REPO_ROOT/bash/blerc" "$HOME/.blerc"
backup_and_link "$REPO_ROOT/i3/config" "$HOME/.config/i3/config"
backup_and_link "$REPO_ROOT/i3status/config" "$HOME/.config/i3status/config"
backup_and_link "$REPO_ROOT/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
backup_and_link "$REPO_ROOT/nvim/init.lua" "$HOME/.config/nvim/init.lua"
backup_and_link "$REPO_ROOT/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
backup_and_link "$REPO_ROOT/polybar/config.ini" "$HOME/.config/polybar/config.ini"
backup_and_link "$REPO_ROOT/polybar/launch.sh" "$HOME/.config/polybar/launch.sh"
backup_and_link "$REPO_ROOT/polybar/scripts/eq-bars.sh" "$HOME/.config/polybar/scripts/eq-bars.sh"
backup_and_link "$REPO_ROOT/polybar/scripts/wifi-click-debug.sh" "$HOME/.config/polybar/scripts/wifi-click-debug.sh"

mkdir -p -- "$HOME/Pictures/Screenshots"

printf '\nInstallation complete.\n'
if [[ -d "$BACKUP_ROOT" ]]; then
  printf 'Previous files were backed up under: %s\n' "$BACKUP_ROOT"
fi
printf '%s\n' \
  'Before restarting i3, review the touchpad, monitor, and battery settings listed in README.md.' \
  'The Super+Shift+Space keyboard-layout shortcut also requires the AUR package xkb-switch.'
