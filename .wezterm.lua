-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.use_fancy_tab_bar = false

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
if wezterm.gui then
	if wezterm.gui.get_appearance():find 'Dark' then
		config.color_scheme = 'Tokyo Night Storm'
	else
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
else
	config.color_scheme = 'Tokyo Night Storm'
end

config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe' }

-- and finally, return the configuration to wezterm
return config
