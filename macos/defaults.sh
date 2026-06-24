#!/usr/bin/env bash
#
# macOS system defaults. Safe to re-run.
# Run on its own:  ./macos/defaults.sh   (also invoked by ../install.sh)

set -euo pipefail

echo "==> Applying macOS defaults"

# ------------------------------------------------------------
# Finder
# ------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true        # show hidden files
defaults write com.apple.finder AppleShowAllExtensions -bool true   # show all file extensions
defaults write com.apple.finder ShowPathbar -bool true              # path bar
defaults write com.apple.finder ShowStatusBar -bool true           # status bar
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # full path in title

# ------------------------------------------------------------
# Keyboard
# ------------------------------------------------------------
defaults write NSGlobalDomain KeyRepeat -int 2            # fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15    # short delay until repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # repeat, not accents

# ------------------------------------------------------------
# Dock
# ------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false

# ------------------------------------------------------------
# Screenshots
# ------------------------------------------------------------
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

# ------------------------------------------------------------
# Misc
# ------------------------------------------------------------
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write com.apple.LaunchServices LSQuarantine -bool false   # don't nag on opening downloads

echo "==> Restarting affected apps"
killall Finder Dock 2>/dev/null || true

echo "==> macOS defaults applied"
