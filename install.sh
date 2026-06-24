#!/usr/bin/env bash
#
# Fresh-Mac bootstrap. Safe to re-run (idempotent).
#
#   1. Installs Xcode CLT, Homebrew, and everything in ./Brewfile
#   2. Sets up Zsh (oh-my-zsh, Powerlevel10k, plugins)
#   3. Symlinks the dotfiles into place
#   4. Configures Git, the YubiKey SSH agent, and macOS defaults
#
# Usage:  ./brew-install-script.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

log() { printf "\n\033[1;34m==>\033[0m %s\n" "$1"; }

# ============================================================
# Xcode Command Line Tools
# ============================================================
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install || true
  # Wait for the install to finish before continuing.
  until xcode-select -p >/dev/null 2>&1; do sleep 10; done
fi

# ============================================================
# Rosetta 2 (Apple Silicon only)
# ============================================================
if [[ "$(uname -m)" == "arm64" ]]; then
  if ! /usr/bin/pgrep -q oahd; then
    log "Installing Rosetta 2"
    softwareupdate --install-rosetta --agree-to-license
  fi
fi

# ============================================================
# Homebrew
# ============================================================
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Pick the right brew prefix for the architecture.
if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
else
  BREW_SHELLENV='eval "$(/usr/local/bin/brew shellenv)"'
fi
grep -qxF "$BREW_SHELLENV" "$HOME/.zprofile" 2>/dev/null || echo "$BREW_SHELLENV" >> "$HOME/.zprofile"
eval "$BREW_SHELLENV"

# ============================================================
# Packages (see ./Brewfile)
# ============================================================
log "Installing packages from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ============================================================
# oh-my-zsh + Powerlevel10k + plugins
# ============================================================
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh"
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clone_if_missing() {
  local repo="$1" dest="$2"
  [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

log "Installing Powerlevel10k and Zsh plugins"
clone_if_missing https://github.com/romkatv/powerlevel10k.git          "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# fzf key bindings + completion
if command -v fzf >/dev/null 2>&1; then
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# ============================================================
# Symlink dotfiles into place
# ============================================================
"$DOTFILES_DIR/scripts/link.sh"

# Git config is symlinked from git/.gitconfig (handled in the symlink step above).

# ============================================================
# YubiKey SSH agent
# ============================================================
if command -v yubikey-agent >/dev/null 2>&1; then
  log "Starting YubiKey agent"
  brew services start yubikey-agent || true
fi

# ============================================================
# macOS defaults
# ============================================================
if [[ -x "$DOTFILES_DIR/macos/defaults.sh" ]]; then
  "$DOTFILES_DIR/macos/defaults.sh"
fi

log "Done. Restart your shell:  exec zsh"
