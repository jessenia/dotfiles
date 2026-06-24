# dotfiles

Personal macOS setup — reproducible from a fresh machine. Clone, run one script, and
get a working **WezTerm + Neovim + tmux** terminal environment with Zsh, Homebrew apps,
and sensible macOS defaults.

## Contents

- [Stack](#stack)
- [Layout](#layout)
- [Install](#install)
- [Common tasks](#common-tasks)
- [How it fits together](#how-it-fits-together)
- [tmux guide](#tmux-guide)
- [WezTerm guide](#wezterm-guide)
- [Neovim guide](#neovim-guide)
- [AI tools](#ai-tools)
- [Notes](#notes)
- [License](#license)

## Stack

| Layer        | Tool                                            |
|--------------|-------------------------------------------------|
| Terminal     | [WezTerm](https://wezfurlong.org/wezterm/)      |
| Multiplexer  | [tmux](https://github.com/tmux/tmux)            |
| Editor (CLI) | [Neovim](https://neovim.io/) (Lazy.nvim)        |
| Editor (IDE) | VS Code                                         |
| Shell        | Zsh + oh-my-zsh + Powerlevel10k                 |
| Packages     | [Homebrew](https://brew.sh/) (`Brewfile`)       |
| AI CLIs      | Claude Code, Codex, Pieces                       |
| Theme        | rose-pine moon (consistent across all three)    |

## Layout

```
.
├── Brewfile               # Declarative package list (brew bundle)
├── install.sh             # Fresh-Mac bootstrap (orchestrates everything below)
├── Makefile               # Convenience targets: install / brew / symlinks / macos / lint
├── config/                # → ~/.config/*
│   ├── nvim/              #   Neovim (Lazy.nvim)
│   ├── wezterm/           #   WezTerm
│   └── tmux/              #   tmux
├── zsh/                   # Shell config
│   ├── .zshrc            #   → ~/.zshrc
│   ├── .zprofile         #   → ~/.zprofile (login shell / PATH)
│   ├── .aliases          #   → ~/.aliases (sourced by .zshrc)
│   └── .p10k.zsh         #   → ~/.p10k.zsh (Powerlevel10k prompt)
├── git/.gitconfig         # → ~/.gitconfig
├── ssh/config.example     # SSH config template (copy to ~/.ssh/config)
├── macos/defaults.sh      # macOS `defaults write` tweaks
├── claude/                # Global AI-assistant config (NOT the repo-root CLAUDE.md)
│   ├── CLAUDE.md          #   → ~/.claude/CLAUDE.md and ~/AGENTS.md
│   └── skills/            #   → ~/.claude/skills/* (Claude skills)
└── scripts/link.sh        # Symlinker (used by install.sh and `make symlinks`)
```

## Install

On a fresh Mac:

```sh
git clone https://github.com/<you>/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
./install.sh
exec zsh
```

`install.sh` is **idempotent** — safe to re-run. It will:

1. Install Xcode Command Line Tools, Rosetta 2 (Apple Silicon), and Homebrew.
2. Install everything in the [`Brewfile`](./Brewfile) via `brew bundle`.
3. Set up oh-my-zsh, Powerlevel10k, and Zsh plugins.
4. Symlink the dotfiles into `$HOME` (backing up any existing files to `*.backup.<timestamp>`).
5. Start the YubiKey SSH agent and apply [macOS defaults](./macos/defaults.sh).

## Common tasks

```sh
make help        # list all targets
make brew        # install/upgrade Brewfile packages
make symlinks    # (re)link dotfiles into $HOME
make macos       # apply macOS defaults
make dump        # regenerate Brewfile from installed packages
make lint        # shellcheck the scripts
```

### Adding an app
Edit [`Brewfile`](./Brewfile), then `make brew`. The bootstrap script never lists
packages directly.

### SSH
```sh
cp ssh/config.example ~/.ssh/config && chmod 600 ~/.ssh/config
```
Your real `~/.ssh/config` is gitignored — never commit it.

## How it fits together

WezTerm is the window; tmux manages persistent sessions inside it; Neovim edits inside
tmux. The killer feature: **`Ctrl-h/j/k/l` moves seamlessly between Neovim splits and
tmux panes** (via [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
+ an `is_vim` smart-switch in tmux) — same keys, no mode switch. WezTerm uses **Cmd**-based
keys so it never collides with the tmux `Ctrl-a` prefix.

```
WezTerm window
└── tmux session "dotfiles"   (survives closing the terminal)
    └── window (tab)
        ├── pane: nvim
        └── pane: shell        ← Ctrl-l / Ctrl-h hop between nvim & this
```

---

## tmux guide

`C-a` means: press `Ctrl+a`, release, then the next key. Prefix is **`Ctrl-a`**.

**Sessions** (a workspace that keeps running after you close the terminal):

```sh
tmux new -s dotfiles       # create a named session
tmux ls                    # list sessions
tmux a -t dotfiles         # attach   (after a reboot-free detach)
tmux kill-session -t dotfiles
```

| Keys | Action |
|------|--------|
| `C-a d` | **Detach** (session keeps running in background) |
| `C-a s` | Visual session switcher |
| `C-a $` | Rename session |

**Windows** (tabs) and **panes** (splits):

| Keys | Action |
|------|--------|
| `C-a c` | New window (tab) |
| `C-a ,` | Rename window · `C-a 0`–`9` jump to window |
| `C-a n` / `C-a p` | Next / previous window |
| `C-a \|` / `C-a -` | Split pane horizontal / vertical |
| `C-h/j/k/l` | Move between panes (no prefix — flows into nvim) |
| `C-a H/J/K/L` | Resize pane (repeatable) |
| `C-a z` | Zoom pane fullscreen (toggle) |
| `C-a x` | Kill pane |

**Copy mode** (vi-style, copies to the macOS clipboard):

| Keys | Action |
|------|--------|
| `C-a v` | Enter copy mode / scroll back |
| `v` → move → `y` | Select and copy · `/` to search |
| `q` | Exit copy mode |

**Misc:** `C-a r` reload config · `C-a ?` list all bindings · `C-a :` command prompt.
Mouse is enabled, so scroll/drag-select also work.

---

## WezTerm guide

Terminal emulator. tmux handles multiplexing, so WezTerm's keys are kept minimal and
**Cmd**-based. Reload config live with `Cmd-Shift-r`.

| Keys | Action |
|------|--------|
| `Cmd-d` / `Cmd-Shift-d` | Split pane horizontal / vertical |
| `Cmd-Opt-←/↑/↓/→` | Move focus between panes |
| `Cmd-w` | Close pane (with confirm) |
| `Cmd-=` / `Cmd--` / `Cmd-0` | Font size up / down / reset |
| `Cmd-Shift-p` | Command palette |
| `Cmd-Shift-r` | Reload config |

Note: in day-to-day use you'll mostly let **tmux** do the splitting (so layouts persist);
WezTerm's own splits are there for quick, throwaway panes. Left Option = Meta (for
`Alt-b`/`Alt-f` word motions); Right Option = compose (accented characters).

---

## Neovim guide

[Lazy.nvim](https://github.com/folke/lazy.nvim) setup. Leader is **`Space`**. Press
`Space` and pause — **which-key** pops up a menu of what's available. First launch auto-
installs plugins; run `:Lazy` to manage them and `:Mason` for language servers.

**Files & search** (Telescope + nvim-tree):

| Keys | Action |
|------|--------|
| `Space e` | Toggle file tree · `Space ef` reveal current file |
| `Space ff` | Find files (fuzzy) |
| `Space fg` | Live grep (search file contents) |
| `Space fb` | Open buffers · `Space fr` recent files |
| `Space fs` | Search word under cursor |

**Windows, splits & buffers:**

| Keys | Action |
|------|--------|
| `Ctrl-h/j/k/l` | Move between splits (and tmux panes) |
| `Space sv` / `Space sh` | Split vertical / horizontal |
| `Space se` / `Space sx` | Equalize / close split |
| `Space bn` / `Space bp` / `Space bd` | Next / prev / delete buffer |
| `Space w` / `Space q` | Save / quit |

**Code (LSP)** — active in supported files:

| Keys | Action |
|------|--------|
| `gd` / `gr` | Go to definition / references |
| `K` | Hover docs · `Space ca` code action |
| `Space rn` | Rename symbol · `Space f` format buffer |
| `[d` / `]d` | Previous / next diagnostic · `Space dd` show |

**Git (gitsigns)** & **editing:**

| Keys | Action |
|------|--------|
| `Space gb` / `Space gp` / `Space gr` | Blame line / preview hunk / reset hunk |
| `gcc` / `gc` (visual) | Toggle comment |
| `Space y` / `Space p` | Yank / paste via system clipboard |
| `Space tt` | Open terminal |
| `Space tc` / `Space tx` / `Space tp` | AI terminal: Claude / Codex / Pieces |

Useful commands: `:Lazy` (plugins), `:Mason` (LSP servers), `:checkhealth` (diagnose
your setup), `:Telescope keymaps` (search every keybinding).

## AI tools

Three terminal AI CLIs are installed via the `Brewfile` and wired up consistently:

| Tool | Install | Alias prefix | nvim |
|------|---------|--------------|------|
| Claude Code | (npm / installer) | `cl*` (`cla`, `clp`, `clc`…) | `Space tc` |
| Codex | `cask "codex"` | `cx*` (`cx`, `cxe`, `cxl`…) | `Space tx` |
| Pieces | `pieces-cli` + `pieces-os` | `pi*` (`pi`, `pia`, `pis`…) | `Space tp` |

See the alias groups in [`zsh/.aliases`](./zsh/.aliases). Pieces also needs **PiecesOS**
running (`cask "pieces-os"`) before its CLI works.

### Shared global instructions
Global AI-assistant instructions live in [`claude/CLAUDE.md`](./claude/CLAUDE.md) and are
symlinked to `~/.claude/CLAUDE.md` and `~/AGENTS.md`, so Claude and Codex share one set of
rules. Claude-only **skills** (loaded on demand) live in `claude/skills/`. This is
separate from the repo-root `CLAUDE.md`, which only guides work inside this repo.

## Notes

- **Editors:** VS Code is the primary IDE; Neovim is for terminal/quick edits.
- **Browsers:** Chrome + Firefox. **VPN:** Mozilla VPN + Firefox Relay.
- Machine-local secrets go in `~/.local.zsh` and `~/.aws_helpers.zsh` (gitignored,
  sourced by `.zshrc` if present).
- See [CLAUDE.md](./CLAUDE.md) for conventions when modifying **this repo** (distinct
  from the global [`claude/CLAUDE.md`](./claude/CLAUDE.md) described above).

## License

[MIT](./LICENSE)
