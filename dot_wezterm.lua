local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- lets wezterm report distinct escape codes for modified keys (e.g. Shift+Enter vs Enter)
config.enable_kitty_keyboard = true

--config.color_scheme = 'Gruvbox light, soft (base16)'
config.color_scheme = 'Belafonte Day'

config.default_prog = { 'pwsh', '-NoLogo' }
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 11.0
config.hide_tab_bar_if_only_one_tab = true

-- tmux-style leader (Ctrl+A here; use Ctrl+B if that was your prefix)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 }

config.keys = {
  -- splits
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- pane navigation, vim-style
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  -- tabs (tmux windows)
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  -- close pane, zoom (tmux z)
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  -- copy mode with vim keys
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  -- send literal Ctrl+A when pressed twice
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },
}

config.audible_bell = 'Disabled'

return config
