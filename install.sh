#!/usr/bin/env bash
# Symlink dotfiles into $HOME, backing up any existing files first.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# source-in-repo  →  target-in-home
LINKS=(
  "tmux/tmux.conf:.tmux.conf"
  "wezterm/wezterm.lua:.wezterm.lua"
)

c_blue=$'\033[38;2;120;169;255m'
c_pink=$'\033[38;2;255;126;182m'
c_green=$'\033[38;2;37;190;106m'
c_dim=$'\033[38;2;123;124;126m'
c_reset=$'\033[0m'

say() { printf "%s\n" "$1"; }

say "${c_blue}» dotfiles installer${c_reset}"
say "${c_dim}  repo: $DOTFILES_DIR${c_reset}"

mkdir -p "$BACKUP_DIR"
backed_up=0

for pair in "${LINKS[@]}"; do
  src="$DOTFILES_DIR/${pair%%:*}"
  dst="$HOME/${pair##*:}"

  if [[ ! -e "$src" ]]; then
    say "${c_pink}  skip${c_reset} $dst ${c_dim}(missing source: $src)${c_reset}"
    continue
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    say "${c_dim}  ok  ${c_reset} $dst ${c_dim}(already linked)${c_reset}"
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "$BACKUP_DIR/"
    backed_up=1
    say "${c_pink}  back${c_reset} $dst ${c_dim}→ $BACKUP_DIR${c_reset}"
  fi

  ln -s "$src" "$dst"
  say "${c_green}  link${c_reset} $dst ${c_dim}→ $src${c_reset}"
done

if [[ $backed_up -eq 0 ]]; then
  rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

# Reload tmux if a server is running
if command -v tmux >/dev/null 2>&1 && tmux info >/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux.conf" && say "${c_green}  tmux config reloaded${c_reset}"
fi

say "${c_blue}» done${c_reset}"
