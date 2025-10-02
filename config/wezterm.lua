-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.default_cursor_style = 'SteadyBar'

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
config.color_scheme = 'Tokyo Night Storm'
if wezterm.gui then
  if wezterm.gui.get_appearance():find 'Light' then
    config.color_scheme = 'Tokyo Night Day'

    local bg_color = '#E1E2ED'
    config.colors = {
      tab_bar = {
        background = bg_color,
        new_tab = {
          bg_color = '#007197',
          fg_color = '#E9E9ED',
        },
      },
    }
  end
end

config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe' }
config.default_cwd = "c:/development"
config.font_size = 12.0

local act = wezterm.action

config.keys = {
  { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
  { key = 'PageUp',    mods = 'SHIFT', action = act.ScrollByPage(-0.75) },
  { key = 'PageDown',  mods = 'SHIFT', action = act.ScrollByPage(0.75) },
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

-- and finally, return the configuration to wezterm
return config
