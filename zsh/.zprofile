# ~/.zprofile — login shell setup (runs before ~/.zshrc)

# Homebrew (Apple Silicon)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# pipx / user-local binaries
export PATH="$PATH:$HOME/.local/bin"
