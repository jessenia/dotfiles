# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

Jessenia's personal macOS dotfiles. The goal is a **reproducible, fresh-out-of-the-box
Mac setup**: clone this repo, run the bootstrap script, symlink the configs, and have a
working environment.

Primary user: Jessenia (`1072588+jessenia@users.noreply.github.com`). Repo lives at `~/github/dotfiles`.

## Target stack

The terminal environment is being standardized on:

- **WezTerm** — terminal emulator (replaces iTerm2)
- **Neovim** — terminal text editing & quick edits (replaces Vim/`.vimrc`)
- **VS Code** — primary IDE for coding/development
- **tmux** — multiplexer
- **Zsh** + oh-my-zsh + Powerlevel10k — shell
- **Homebrew** — package manager (Apple Silicon / `/opt/homebrew`)

When adding tooling or docs, assume this stack. Do **not** reintroduce iTerm2, Vim, or
the deprecated tools listed below.

## Repository layout

```
Brewfile                    # Declarative package manifest (brew bundle). Edit to add/remove apps.
install.sh                  # Fresh-Mac bootstrap: Xcode CLT, Homebrew, brew bundle, shell, symlinks
Makefile                    # Targets: install / brew / symlinks / macos / dump / lint
scripts/link.sh             # Symlinker (used by install.sh and `make symlinks`)
config/                     # Everything that maps to ~/.config/*
├── nvim/                   #   Neovim config (Lazy.nvim) → ~/.config/nvim
├── wezterm/wezterm.lua     #   WezTerm config           → ~/.config/wezterm
└── tmux/.tmux.conf         #   tmux config              → ~/.tmux.conf
zsh/
├── .zshrc                  # Zsh main config → ~/.zshrc
├── .zprofile               # Login shell / PATH (brew shellenv, pipx) → ~/.zprofile
├── .aliases                # Alias library: git, docker, k8s, terraform, aws, claude → ~/.aliases
└── .p10k.zsh               # Powerlevel10k prompt config → ~/.p10k.zsh
git/.gitconfig              # Git identity, delta pager, aliases → ~/.gitconfig
ssh/config.example          # SSH config template (copy to ~/.ssh/config; real one is gitignored)
macos/defaults.sh           # macOS `defaults write` tweaks (run by install.sh)
.github/workflows/ci.yml    # CI: shellcheck + Brewfile + Lua syntax
README.md                   # Project overview + install instructions
```

### Cross-tool keybinding contract
`Ctrl-h/j/k/l` moves between splits/panes seamlessly across nvim + tmux:
- nvim: `vim-tmux-navigator` (`lua/plugins/navigation.lua`) owns these keys.
- tmux: `is_vim` smart-switch in `.tmux.conf` forwards to nvim or switches panes.
- WezTerm: uses **CMD**-based keys instead, to avoid colliding with the tmux
  `Ctrl-a` prefix. Theme across all three is **rose-pine moon**.

### nvim/ internals
Standard Lazy.nvim layout. `init.lua` requires `config.{options,keymaps,autocmds,lazy}`;
`lazy.lua` imports everything under `lua/plugins/`. Plugins are grouped one concern per
file: `colorscheme`, `editor`, `git`, `lsp`, `telescope`, `treesitter`. Leader is `<Space>`.

## Conventions & preferences

- **Browsers:** Chrome and Firefox **only**. Do **not** install Brave.
- **VPN:** Mozilla VPN + Firefox Relay. Do **not** install Pritunl or Viscosity.
- **Editors:** VS Code is the primary IDE for development; Neovim is for terminal/CLI
  text editing and quick edits. `.vimrc` / Vim / Vundle are deprecated and being removed.
- **Terminal:** WezTerm only. iTerm2 is deprecated.
- **Idempotent bootstrap:** the brew script should be safe to re-run. Prefer
  `brew bundle` / `brew install` (already idempotent) and guard one-off steps so a
  second run doesn't error.
- **No project-specific cruft in the bootstrap:** keep `install.sh` to generic Mac
  setup. Per-project clones, repo checkouts, and `pip install -r` for specific work
  repos do not belong here.
- **Package changes go in `Brewfile`, not the script.** The bootstrap just runs
  `brew bundle`. To add/remove an app, edit `Brewfile`.
- **Comment style:** section headers as banner comments (`# ===…===`) matching the
  existing `.aliases` / `.zshrc` style.

## How configs map to $HOME

`install.sh` symlinks these into place (backing up any existing real file to
`*.backup.<timestamp>` first). Keep paths consistent:

| Repo path                  | Installed location |
|----------------------------|--------------------|
| `zsh/.zshrc`               | `~/.zshrc`         |
| `zsh/.zprofile`            | `~/.zprofile`      |
| `zsh/.aliases`             | `~/.aliases` (sourced by `.zshrc`) |
| `zsh/.p10k.zsh`            | `~/.p10k.zsh`      |
| `git/.gitconfig`           | `~/.gitconfig`     |
| `config/nvim/`             | `~/.config/nvim/`  |
| `config/wezterm/`          | `~/.config/wezterm/` |
| `config/tmux/.tmux.conf`   | `~/.tmux.conf`     |

NOTE: `.zshrc` sources `~/.aliases` — keep the sourced path and the symlink target in
agreement when editing either.

## Standing tasks

When asked to update this repo, keep these in mind:

1. Keep `README.md` in sync with the actual files and install steps.
2. Keep `brew-install-script.sh` current: remove deprecated apps, add new tools.
3. Build out `wezterm/` and `tmux/` configs to match the nvim setup (rose-pine theme,
   `<C-h/j/k/l>` navigation already used in nvim — keep keybindings coherent across
   tmux + nvim + wezterm).
4. **Whenever the user adds a new tool, alias, app, or workflow, record it here** so this
   file stays the source of truth for the setup.

## Deprecated — do not reintroduce

- Brave browser
- iTerm2
- Vim / `.vimrc` / Vundle
- JetBrains IDEs (GoLand, PyCharm) — using VS Code / Neovim instead
- Pritunl / Viscosity VPN clients — using Mozilla VPN + Relay instead
