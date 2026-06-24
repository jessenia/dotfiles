# Brewfile — declarative package manifest for a fresh Mac.
# Apply with:  brew bundle --file=Brewfile
# Re-running is safe (idempotent). Prune anything you don't use.

# ============================================================
# Taps
# ============================================================
tap "hashicorp/tap"

# ============================================================
# Browsers  (Chrome + Firefox only — no Brave)
# ============================================================
cask "google-chrome"
cask "firefox"

# ============================================================
# Terminal stack: WezTerm + tmux + Neovim
# ============================================================
cask "wezterm"
brew "tmux"
brew "neovim"

# Nerd Fonts (Meslo is the Powerlevel10k default)
cask "font-meslo-lg-nerd-font"
cask "font-hack-nerd-font"
cask "font-fira-code-nerd-font"

# ============================================================
# Shell: Zsh + oh-my-zsh plugins + Powerlevel10k
# ============================================================
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "powerlevel10k"

# ============================================================
# Modern CLI utilities
# ============================================================
brew "fzf"          # fuzzy finder
brew "ripgrep"      # rg — fast grep
brew "fd"           # fast find
brew "bat"          # cat with syntax highlighting
brew "eza"          # modern ls
brew "zoxide"       # smarter cd
brew "jq"           # JSON processor
brew "yq"           # YAML processor
brew "tree"
brew "wget"
brew "curl"
brew "coreutils"
brew "gnu-sed"
brew "htop"
brew "btop"
brew "direnv"       # per-directory env vars
brew "tldr"         # simplified man pages
brew "watch"
brew "mas"          # Mac App Store CLI

# ============================================================
# Git & friends
# ============================================================
brew "git"
brew "gh"           # GitHub CLI
brew "git-delta"    # nicer git diffs
brew "lazygit"      # git TUI

# ============================================================
# AI coding tools (terminal)
# ============================================================
cask "codex"        # OpenAI Codex CLI coding agent
brew "pieces-cli"   # Pieces CLI
cask "pieces-os"    # PiecesOS — local backend the Pieces CLI talks to

# ============================================================
# Languages & runtimes
# ============================================================
brew "go"
brew "python"
brew "ruby"
brew "node"
brew "fnm"          # fast Node version manager
brew "pyenv"        # Python version manager
brew "pipx"         # install Python CLIs in isolation

# ============================================================
# Cloud / Infra / DevOps
# ============================================================
brew "awscli"
brew "hashicorp/tap/terraform"
brew "tfenv"
brew "terraform-docs"
brew "ansible"
brew "kubernetes-cli"   # kubectl
brew "helm"
brew "k9s"              # kubernetes TUI
brew "bazelisk"
brew "watchman"
cask "docker-desktop"

# ============================================================
# GUI apps
# ============================================================
cask "1password"
cask "1password-cli"
cask "visual-studio-code"
cask "slack"
cask "discord"
cask "notion"
cask "zoom"
cask "postman"
cask "mysqlworkbench"
cask "adobe-acrobat-pro"
cask "mozilla-vpn"      # VPN (Relay is a Firefox extension — not installed via brew)
cask "rectangle"        # window manager
cask "raycast"          # Spotlight replacement

# ============================================================
# Security / YubiKey
# ============================================================
brew "yubikey-agent"
brew "ykman"
