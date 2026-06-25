# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

Jessenia's personal macOS dotfiles. The goal is a **reproducible, fresh-out-of-the-box
Mac setup**: clone this repo, run the bootstrap script, symlink the configs, and have a
working environment.

Primary user: Jessenia. Repo lives at `~/github/dotfiles`.

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
claude/                     # GLOBAL AI-assistant config (NOT this project file — see note)
├── CLAUDE.md               #   Global instructions → ~/.claude/CLAUDE.md (and ~/AGENTS.md)
└── skills/                 #   Claude skills → ~/.claude/skills/* (debugging, infra, …)
.github/workflows/ci.yml    # CI: shellcheck (bash only) + Brewfile + Lua syntax
.gitignore                  # Ignores backups, macOS junk, and secrets (see below)
.editorconfig               # UTF-8 / LF / 2-space defaults
LICENSE                     # MIT
README.md                   # Project overview + usage guides (tmux/WezTerm/Neovim)
CLAUDE.md                   # This file — conventions for working ON the dotfiles repo
```

### Two different CLAUDE.md files — do not confuse them
- **`CLAUDE.md`** (repo root, this file) = **project** guidance, scoped to the dotfiles
  repo. It is NOT symlinked anywhere.
- **`claude/CLAUDE.md`** = the user's **global** instructions for every project/agent.
  It is symlinked to `~/.claude/CLAUDE.md` and `~/AGENTS.md`. Skills live in
  `claude/skills/` (Claude-only; Codex reads the global file but not skills). When the
  user mentions their "global CLAUDE.md", they mean `claude/CLAUDE.md`, never this file.

### Cross-tool keybinding contract
`Ctrl-h/j/k/l` moves between splits/panes seamlessly across nvim + tmux:
- nvim: `vim-tmux-navigator` (`lua/plugins/navigation.lua`) owns these keys.
- tmux: `is_vim` smart-switch in `.tmux.conf` forwards to nvim or switches panes.
- WezTerm: uses **CMD**-based keys instead, to avoid colliding with the tmux
  `Ctrl-a` prefix. Theme across all three is **rose-pine moon**.

### nvim/ internals
Standard Lazy.nvim layout. `init.lua` requires `config.{options,keymaps,autocmds,lazy}`;
`lazy.lua` imports everything under `lua/plugins/`. Plugins are grouped one concern per
file: `colorscheme`, `editor`, `git`, `lsp`, `telescope`, `treesitter`,
`navigation`. Leader is `<Space>`.

**nvim-treesitter is pinned to `branch = "master"`** in `treesitter.lua`. Do NOT remove
that pin: the rewritten `main` branch (now the plugin default) drops the
`require("nvim-treesitter.configs").setup{...}` API this config uses, which breaks
startup with "module nvim-treesitter.configs not found". Migrating to `main` later is a
separate rewrite, not a pin removal.

## Conventions & preferences

- **Browsers:** Chrome and Firefox **only**. Do **not** install Brave.
- **VPN:** Mozilla VPN + Firefox Relay. Do **not** install Pritunl or Viscosity.
- **Editors:** VS Code is the primary IDE for development; Neovim is for terminal/CLI
  text editing and quick edits. `.vimrc` / Vim / Vundle are gone — don't reintroduce them.
- **AI coding CLIs:** Claude Code, Codex (cask `codex`), and Pieces (`pieces-cli` +
  `pieces-os` backend). Each gets the same treatment: Brewfile entry, an alias group in
  `zsh/.aliases` (`cl*` / `cx*` / `pi*`), and an nvim terminal keybind
  (`<leader>tc` Claude, `<leader>tx` Codex, `<leader>tp` Pieces). Add new AI CLIs the
  same way.
- **Shared agent instructions:** agents that use `AGENTS.md` (Codex, etc.) should read
  the same global instructions as Claude. `~/AGENTS.md` is a symlink to
  `~/.claude/CLAUDE.md` (set up by `scripts/link.sh`). **When adding any new agent, make
  sure this symlink exists** so all agents share one instruction file.
- **Terminal:** WezTerm only. iTerm2 is deprecated.
- **Idempotent bootstrap:** the brew script should be safe to re-run. Prefer
  `brew bundle` / `brew install` (already idempotent) and guard one-off steps so a
  second run doesn't error.
- **No project-specific cruft in the bootstrap:** keep `install.sh` to generic Mac
  setup. Per-project clones, repo checkouts, and `pip install -r` for specific work
  repos do not belong here.
- **Package changes go in `Brewfile`, not the script.** The bootstrap just runs
  `brew bundle`. To add/remove an app, edit `Brewfile` (then `make brew`).
- **Use the Makefile for common tasks:** `make brew` (install packages),
  `make symlinks` (re-link), `make macos` (defaults), `make dump` (regen Brewfile from
  what's installed), `make lint` (shellcheck). `make install` runs the full bootstrap.
- **Shell scripting:** new scripts are **bash** — start with `#!/usr/bin/env bash` and
  `set -euo pipefail`, keep them idempotent. ShellCheck (CI + `make lint`) lints **only
  bash** scripts; `zsh/` is excluded because ShellCheck can't parse zsh. Don't try to
  "fix" zsh syntax to satisfy ShellCheck. Suppress intentional false positives with a
  scoped `# shellcheck disable=SCxxxx` + a comment explaining why.
- **Secrets never get committed.** Machine-local/secret config lives in `~/.local.zsh`
  and `~/.aws_helpers.zsh` (sourced by `.zshrc` if present) and the real `~/.ssh/config`
  — all gitignored. The repo only tracks `ssh/config.example`. Don't put tokens, keys,
  or work-specific identities in tracked files.
- **Comment style:** section headers as banner comments (`# ===…===`) matching the
  existing `.aliases` / `.zshrc` style.
- **Helper functions** in `zsh/.aliases` follow two rules from the tool-design
  principles below: print a **definitive empty state** (say "no matches" / "none"
  instead of silent output) and return a **non-zero exit code** on no-result/failure.
  Guard commands that break on empty input (e.g. `docker stop $(docker ps -q)`).

## Tool-design principles (for any future data-returning CLI)

This repo currently has no agent-facing CLI that emits structured data, so most of these
do not yet apply. If one is ever added here, design it for agent consumption:

1. Token-efficient output (e.g. TOON over JSON, roughly 40% fewer tokens).
2. Minimal default schemas: 3-4 fields per list item, not 10+.
3. Truncate large text fields with size hints and an escape hatch to fetch full content.
4. Pre-compute aggregates (counts, statuses) to avoid follow-up round trips.
5. Definitive empty states: say "0 results", never ambiguous empty output.
6. Structured errors and exit codes; idempotent mutations; no interactive prompts.
7. Ambient context first (opt-in session integration), then an on-demand skill.
8. Content first: show actual data, not a wall of help text.
9. Contextual disclosure: append relevant next-step commands after output.
10. Consistent, concise per-subcommand help for when agents need it.

Already reflected where applicable: definitive empty states + non-interactive exit codes
in `zsh/.aliases` (#5, #6); ambient global `CLAUDE.md` + on-demand `claude/skills/` (#7);
`make help` and `install.sh`'s closing next-step hint (#9, #10).

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

1. Keep `README.md` in sync with the actual files, install steps, and keybindings.
   The README has per-tool usage guides (tmux / WezTerm / Neovim) — update the relevant
   guide whenever a keybinding or config changes.
2. Keep `Brewfile` current: remove deprecated apps, add new tools. Never list packages
   directly in `install.sh`.
3. Keep keybindings **coherent across tmux + nvim + WezTerm** (the `Ctrl-h/j/k/l`
   navigation contract above). If you change one tool's nav/split keys, check the others.
4. **Whenever the user adds a new tool, alias, app, or workflow, record it here** so this
   file stays the source of truth for the setup.

## Known follow-ups / cleanup

- tmux is in the `Brewfile` but not yet installed on the user's current machine
  (`brew install tmux` / `make brew`). Until then, WezTerm's own panes are the fallback.

## Deprecated — do not reintroduce

- Brave browser
- iTerm2
- Vim / `.vimrc` / Vundle
- JetBrains IDEs (GoLand, PyCharm) — using VS Code / Neovim instead
- Pritunl / Viscosity VPN clients — using Mozilla VPN + Relay instead
