#!/usr/bin/env bash
#
# Symlink dotfiles into $HOME. Safe to re-run.
# Existing real files (not symlinks) are backed up to *.backup.<timestamp> first.
#
# Run on its own:  ./scripts/link.sh   (also invoked by ../install.sh)

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local src="$1" dest="$2"
  [[ -e "$src" ]] || { echo "  skip (missing): $src"; return; }
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "  backed up existing $dest"
  fi
  ln -sfn "$src" "$dest"
  echo "  $dest -> $src"
}

echo "==> Symlinking dotfiles"
link "$DOTFILES_DIR/zsh/.zshrc"             "$HOME/.zshrc"
link "$DOTFILES_DIR/zsh/.zprofile"          "$HOME/.zprofile"
link "$DOTFILES_DIR/zsh/.aliases"           "$HOME/.aliases"
link "$DOTFILES_DIR/zsh/.p10k.zsh"          "$HOME/.p10k.zsh"
link "$DOTFILES_DIR/git/.gitconfig"         "$HOME/.gitconfig"
link "$DOTFILES_DIR/config/nvim"            "$HOME/.config/nvim"
link "$DOTFILES_DIR/config/wezterm"         "$HOME/.config/wezterm"
link "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Global Claude instructions + skills.
# NOTE: claude/CLAUDE.md here is the GLOBAL file, distinct from the repo-root CLAUDE.md
# (which is project-only and is NOT symlinked anywhere).
# Codex and other agents read ~/AGENTS.md, which points at the same global file.
mkdir -p "$HOME/.claude/skills"
link "$DOTFILES_DIR/claude/CLAUDE.md"       "$HOME/.claude/CLAUDE.md"
link "$HOME/.claude/CLAUDE.md"              "$HOME/AGENTS.md"
for skill in "$DOTFILES_DIR"/claude/skills/*/; do
  [[ -d "$skill" ]] || continue
  link "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
done

echo "==> Symlinks done"
