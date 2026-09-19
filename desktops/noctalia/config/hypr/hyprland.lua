require("hyprland.monitors")
require("hyprland.autostart")
require("hyprland.environment")
require("hyprland.permissions")
require("hyprland.appearance")
require("hyprland.input")
require("hyprland.binds")
require("hyprland.rules")

-- Applies Noctalia's color scheme; must stay literally here, not in a
-- submodule (see AGENTS.md). pcall covers noctalia.lua not existing yet.
pcall(function() require("noctalia").apply_theme() end)
