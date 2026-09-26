-- Autostart Noctalia
-- https://docs.noctalia.dev/noctalia/compositor-settings/hyprland/
-- https://wiki.hypr.land/configuring/core/autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)
