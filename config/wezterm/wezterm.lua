-- ~/.config/wezterm/wezterm.lua
-- Theme: rose-pine moon (matches Neovim + tmux)

local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

local is_windows = os.getenv("OS") and os.getenv("OS"):lower():find("windows")
local is_macos = wezterm.target_triple:lower():find("darwin") ~= nil

-- ============================================================
-- Font
-- ============================================================
config.font = wezterm.font_with_fallback({
  { family = "Hack Nerd Font", weight = "Regular" },
  "MesloLGS Nerd Font",
  "FiraCode Nerd Font",
})
config.font_size = 14.0
config.line_height = 1.1

-- ============================================================
-- Color scheme
-- ============================================================
config.color_scheme = 'rose-pine-moon'

-- ============================================================
-- Window appearance
-- ============================================================
if is_macos then
    config.window_background_opacity = 0.8
    config.macos_window_background_blur = 50
    config.window_decorations = 'RESIZE'
    config.window_padding = {
          left = 8,
          right = 8,
          top = 8,
          bottom = 8,
    }
end

if is_windows then
    config.win32_system_backdrop = "Acrylic"
    config.window_background_opacity = 0.7
    config.window_frame.font_size = 10.0
end

-- ============================================================
-- Tab bar
-- tmux is the primary multiplexer, so keep WezTerm's UI minimal.
-- ============================================================
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false

-- ============================================================
-- Cursor
-- ============================================================
config.default_cursor_style = 'BlinkingBar'

-- ============================================================
-- Scrollback & bell
-- ============================================================
config.scrollback_lines = 50000
config.audible_bell = 'Disabled'

-- ============================================================
-- macOS Option key behavior
-- Left Option  -> Alt     (enables Alt+b / Alt+f word navigation)
-- Right Option -> compose (lets you type accented / special chars)
-- ============================================================
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- ============================================================
-- Keybindings
-- CMD-based, so they don't collide with the tmux Ctrl-a prefix.
-- ============================================================
config.keys = {
  -- Split panes (iTerm convention)
  { key = 'd', mods = 'CMD',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CMD',       action = act.CloseCurrentPane { confirm = true } },

  -- Move focus between panes (Cmd+Option+arrow avoids clashing with line navigation)
  { key = 'LeftArrow',  mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },

  -- Font size
  { key = '=', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
  { key = '0', mods = 'CMD', action = act.ResetFontSize },

  -- Config reload / command palette
  { key = 'r', mods = 'CMD|SHIFT', action = act.ReloadConfiguration },
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
}

return config
