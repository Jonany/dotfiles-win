-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
if wezterm.gui then
	if wezterm.gui.get_appearance():find 'Dark' then
		config.color_scheme = 'Tokyo Night Storm'
	else
		config.color_scheme = 'Tokyo Night Day'
  	end
else
	config.color_scheme = 'Tokyo Night Storm'
end

config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe' }

-- and finally, return the configuration to wezterm
return config
