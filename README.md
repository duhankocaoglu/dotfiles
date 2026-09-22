# Duhan's dotfiles

Personal configuration for a keyboard-focused i3/X11 desktop, Bash, Neovim,
Alacritty, Kitty, i3status, and Polybar.

> [!IMPORTANT]
> The installer is intended **only for Arch Linux and Arch-based systems using
> `pacman`**. These are personal configs, so review the hardware-specific values
> before restarting i3.

## Included configurations

| Directory | Destination | Purpose |
| --- | --- | --- |
| `.xinitrc` | `~/.xinitrc` | Starts i3 when running `startx` |
| `.zshrc` | `~/.zshrc` | Zsh completion, autosuggestions, highlighting, and history |
| `alacritty/` | `~/.config/alacritty/` | Alacritty font settings |
| `bash/` | `~/.bashrc`, `~/.blerc` | Bash, fzf, ble.sh, aliases, and completion |
| `i3/` | `~/.config/i3/` | Minimal, keyboard-focused i3 setup |
| `i3status/` | `~/.config/i3status/` | Battery and clock status line |
| `kitty/` | `~/.config/kitty/` | Tokyo Night-inspired Kitty theme |
| `nvim/` | `~/.config/nvim/` | Neovim setup managed by lazy.nvim |
| `polybar/` | `~/.config/polybar/` | Optional Catppuccin-style Polybar |

`.bashrc` at the repository root is a minimal fallback. The installer deliberately
uses the more complete `bash/bashrc` configuration instead, so the two files do
not compete for `~/.bashrc`.

`auto-sync.sh` is an optional repository-maintenance helper. The installer does
not start or install it because it automatically commits and pushes changes.

## Quick installation

On an Arch-based system:

```bash
git clone https://github.com/duhankocaoglu/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script:

1. Installs the required packages from the official Arch repositories.
2. Installs [ble.sh](https://github.com/akinomyoga/ble.sh) into `~/.local`.
3. Backs up conflicting files to
   `~/.local/state/dotfiles-backups/<timestamp>/`.
4. Creates symlinks from your home directory to this repository.
5. Creates `~/Pictures/Screenshots` for the i3 screenshot shortcuts.

It also installs Zsh, its autosuggestion and syntax-highlighting plugins, and
`xorg-xinit` for the newly included `.zshrc` and `.xinitrc`.

To create only the links without installing packages:

```bash
./install.sh --no-packages
```

Because the files are symlinked, changes made in either the repository or the
normal config paths affect the same files.

## Required customization

Review these values before restarting i3:

### Monitor

`i3/config` forces `DP-2` to `1920x1200` at `165 Hz`. Find your real output and
available modes with:

```bash
xrandr --query
```

Then edit or remove the `xrandr` line near the bottom of `i3/config`.

### Touchpad

The scrolling command targets a specific ELAN touchpad. Find your device name:

```bash
xinput list
```

Update or remove the matching `xinput set-prop` line in `i3/config`.

### Battery and power adapter

The configs currently expect `BAT1` and `ACAD`. Check your system:

```bash
ls /sys/class/power_supply
```

Update both `i3status/config` and `polybar/config.ini` if your names differ. A
desktop without a battery can remove the battery module.

### Keyboard layout switcher

The i3 config starts with US QWERTY and US Colemak layouts. Its layout-switching
shortcut uses `xkb-switch`, which is available from the AUR and is deliberately
not installed automatically. Install it with your preferred AUR workflow, or
change/remove this line in `i3/config`:

```text
bindcode $mod+Shift+65 exec --no-startup-id xkb-switch -n
```

## Main i3 shortcuts

`Super` is the modifier key.

| Shortcut | Action |
| --- | --- |
| `Super + Enter` | Open Alacritty |
| `Super + D` | Open the application launcher |
| `Super + Shift + Q` | Close the focused window |
| `Super + H/J/K/L` | Focus left/down/up/right |
| `Super + Shift + H/J/K/L` | Move the focused window |
| `Super + 1..0` | Switch workspace |
| `Super + Shift + 1..0` | Move a window to a workspace |
| `Super + Tab` | Return to the previous workspace |
| `Super + R` | Enter resize mode |
| `Super + F` | Toggle fullscreen |
| `Print` | Save a full screenshot |
| `Shift + Print` | Select and save a screenshot region |
| `Super + Shift + C` | Reload i3 |
| `Super + Shift + R` | Restart i3 |

## Status bars

i3 uses `i3status` by default. Polybar is included as an alternative and can be
started with:

```bash
~/.config/polybar/launch.sh
```

If you switch permanently, disable the `bar { ... }` block in `i3/config` and
add this to the startup section:

```text
exec_always --no-startup-id ~/.config/polybar/launch.sh
```

The Spotify module only displays information while Spotify is available through
`playerctl`.

## Starting i3 with startx

The included `.xinitrc` contains `exec i3`. From a TTY, start the X11 session
with:

```bash
startx
```

If you use a display manager, it can launch i3 directly and `.xinitrc` may not
be used.

## Shell configurations

Both Bash and Zsh configs are included:

- Bash uses `bash/bashrc` and `bash/blerc`.
- Zsh uses the root `.zshrc`, including completion, persistent history,
  autosuggestions, and syntax highlighting.
- The small root `.bashrc` is retained as a minimal reference but is not linked
  by the installer.

The installer does not change your login shell. To use Zsh by default after
installation:

```bash
chsh -s "$(command -v zsh)"
```

Log out and back in for the login-shell change to take effect.

## Neovim

Open Neovim after installation:

```bash
nvim
```

lazy.nvim will install the configured plugins. Mason then manages the configured
language servers. `base-devel`, `git`, `ripgrep`, `fd`, and `fzf` are installed
because the configuration and native plugin builds may need them.

## Updating

Pulling changes updates the linked configs immediately:

```bash
cd ~/dotfiles
git pull --ff-only
```

Review changes before committing your own machine-specific edits:

```bash
git status
git diff
```

Do not commit passwords, tokens, private keys, Wi-Fi profiles, shell history, or
`.env` files. The repository's `.gitignore` blocks common sensitive filenames,
but it cannot detect every possible secret.

## Optional automatic syncing

`auto-sync.sh` watches `~/dotfiles`, asks for a commit message through Rofi, and
then automatically commits and pushes every detected change. Use it only if you
understand that behavior.

```bash
sudo pacman -S --needed inotify-tools rofi
./auto-sync.sh
```

It assumes the repository is cloned at `~/dotfiles` and that Git authentication
is already configured.
