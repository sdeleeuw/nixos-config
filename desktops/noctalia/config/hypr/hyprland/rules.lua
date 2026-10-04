-- See https://wiki.hypr.land/configuring/core/rules/window-rules/
-- and https://wiki.hypr.land/configuring/core/rules/layer-rules/

-- Noctalia Settings
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

-- Galculator doesn't tile well, always open it floating
hl.window_rule({
    match = { class = "^galculator$" },
    float = true,
})

-- Vibe Typer's recording indicator is a transparent, always-on-top Electron
-- window. The app tries to register these rules itself through its wlroots
-- workaround, but it uses `hyprctl keyword`, which Hyprland 0.55's non-legacy
-- parser rejects ("keyword can't work with non-legacy parsers"). The rules
-- therefore never land and the indicator gets tiled with a border instead of
-- floating at the bottom. Apply the equivalent rules here.
--
-- The move expression must be written without spaces around the operators
-- (Hyprland splits the value on whitespace); window_w/window_h resolve to the
-- indicator's own size, and the 40px matches the app's bottom padding.
hl.window_rule({
    name  = "vibe-typer-indicator",
    match = { class = "^vibe-typer$", title = "^Recording Indicator$" },

    float       = true,
    pin         = true,
    border_size = 0,
    no_blur     = true,
    no_shadow   = true,
    no_anim     = true,
    no_focus    = true,
    move        = "monitor_w/2-window_w/2 monitor_h-window_h-40",
})

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Blur
-- https://docs.noctalia.dev/noctalia/compositor-settings/hyprland/

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})
