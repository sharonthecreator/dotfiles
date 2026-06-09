local wezterm = require 'wezterm'

local config = {
  keys = {
    -- Option+Left/Right: word-jump in shell (backward / forward word)
    {key="LeftArrow",  mods="OPT", action=wezterm.action{SendString="\x1bb"}},
    {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},

    -- Option+Up/Down: send proper Alt+Arrow escape so tmux can switch windows
    {key="UpArrow",    mods="OPT", action=wezterm.action{SendString="\x1b[1;3A"}},
    {key="DownArrow",  mods="OPT", action=wezterm.action{SendString="\x1b[1;3B"}},
  }
}

config.color_scheme = 'carbonfox'
config.font = wezterm.font_with_fallback {
    "JetBrains Mono",
    "MesloLGS NF",
    "Symbols Nerd Font Mono",
}

config.bidi_enabled = true

-- config.window_background_image = '/Users/sharon/Documents/maplestory/ellinia_trees.jpg'
-- config.window_background_image_hsb = {
--   brightness = 0.10,
--   hue = 1.0,
--   saturation = 1.0,
-- }

return config
