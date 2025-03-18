-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- and finally, return the configuration to wezterm
config.color_scheme = "catppuccin-mocha"
config.default_domain = "WSL:Ubuntu-24.04"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font_size = 12
-- config.window_background_image = "C://Users/ChaithanyaKS/Pictures/Wallpapers/solo-leveling-wallpaper.png"
--
-- config.window_background_image_hsb = {
-- 	brightness = 0.2,
-- 	hue = 1.0,
-- 	saturation = 1.0,
-- }

return config
