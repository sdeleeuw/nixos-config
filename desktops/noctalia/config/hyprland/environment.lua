-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Hyprland doesn't load .xprofile and spawns processes before a shell can
-- export vars, so the ssh-agent socket path (fixed by home-manager's
-- services.ssh-agent, see users/sander/home.nix) is set here directly. This
-- covers tools like `ssh-add` that read SSH_AUTH_SOCK itself rather than
-- going through ~/.ssh/config's IdentityAgent.
hl.env("SSH_AUTH_SOCK", "/run/user/1000/ssh-agent")
hl.env("SSH_ASKPASS", "wayprompt-ssh-askpass")
hl.env("SSH_ASKPASS_REQUIRE", "prefer")
