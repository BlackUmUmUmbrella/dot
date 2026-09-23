local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Catppuccin Mocha"
config.colors = {
  background = "#11111b",
  tab_bar = {
    background = "#11111b",
    active_tab = {
      bg_color = "#11111b",
      fg_color = "#cdd6f4",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#11111b",
      fg_color = "#585b70",
    },
    inactive_tab_hover = {
      bg_color = "#181825",
      fg_color = "#a6adc8",
    },
    new_tab = {
      bg_color = "#11111b",
      fg_color = "#585b70",
    },
    new_tab_hover = {
      bg_color = "#18111b",
      fg_color = "#a6adc8",
    },
  },
}

if wezterm.target_triple:find("apple") then
  config.font_size = 13.0
  config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "JetBrainsMono Nerd Font",
    "PingFang TC",
    "Sarasa Gothic TC"
  })
  config.freetype_load_target = "Normal"
  config.allow_square_glyphs_to_overflow_width = "Never"
elseif wezterm.target_triple:find("windows") then
  config.font_size = 11.0
  config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "JetBrainsMono Nerd Font",
    "Sarasa Gothic TC",
    "Microsoft JhengHei",
    "Noto Sans Mono",
  })
  config.allow_square_glyphs_to_overflow_width = "Never"
elseif wezterm.target_triple:find("bsd") then
  config.font_size = 10.0
  config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "JetBrainsMono Nerd Font",
    "Sarasa Gothic TC",
    "Noto Sans Mono",
  })
else
  config.font_size = 9.0
  config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "JetBrainsMono Nerd Font",
    "Sarasa Gothic TC",
    "Noto Sans Mono",
  })
  config.freetype_load_target = "Normal"
  config.freetype_render_target = "Normal"
  config.freetype_load_flags = "DEFAULT"
end
config.window_padding = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 12,
}
config.window_close_confirmation = "NeverPrompt"

return config