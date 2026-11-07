# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, OpenCode, etc.) when working with code in this repository.

## Overview

Personal NixOS flake configuration for two laptops, using home-manager as a flake module. There is one user, `sander`.

- `infinity`: runs the Noctalia desktop, with Hyprland and Niri both installed as compositors (picked per session in the greeter; Niri is being trialled as a replacement).
- `t480`: a ThinkPad T480 that runs GNOME and also has the `games/` modules and TLP.

Each host imports its own list of `programs/` modules. When adding a program, ask which host(s) it's for, or add it to every host's imports if it's meant to be general. Don't assume `infinity` is the only host.

## Commands

- Check the flake evaluates and all modules parse: `nix flake check`
- Build the system closure without activating it: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Parse a single module for syntax errors: `nix-instantiate --parse <path/to/file.nix>`
- Evaluate an option to inspect its resolved value: `nix eval .#nixosConfigurations.<host>.config.<option.path>`
- Update flake inputs: `nix flake update` (or `nix flake lock --update-input <name>` for one input)

`<host>` is `infinity` or `t480`. Run `hostname` to see which machine you're on.

Do not run `nixos-rebuild switch` — that activates the config on the live system and is left to the user to run manually.

## Architecture

`flake.nix` is the single entry point. It declares inputs (nixpkgs, nixpkgs-unstable, home-manager) and wires `nixosConfigurations.infinity` and `nixosConfigurations.t480` from `hosts/<name>/configuration.nix`. Each host also gets the home-manager module, which points `home-manager.users.sander` at the shared `users/sander/home.nix`.

Modules are split by concern and composed via imports:

- `hosts/<name>/configuration.nix` — the system-level entry point for a host (boot, users, hardware, timezone), importing whichever `desktops/`, `programs/` and `games/` modules that host needs.
- `desktops/<name>/` — a desktop environment: `configuration.nix` (system-level: session packages, `programs.hyprland`, greetd, etc.) and, where the desktop ships user-independent defaults, a paired `home.nix` (home-manager: per-user settings for that desktop). The system module's imports list ends with `home-manager.users.sander.imports = [ ./home.nix ]`, tying the two halves together so importing the desktop's system module automatically pulls in the matching home-manager config. This keeps system and home-manager config from drifting out of sync. `desktops/gnome/` is the exception: it is system-only, and all of its per-user settings live in `users/sander/gnome.nix` so other users get plain GNOME. Config for a program that's tightly coupled to the desktop itself (e.g. Hyprland, Ghostty, Thunar) lives inline in the desktop's own files rather than as a separate `programs/` module — see `desktops/noctalia/home.nix`. App config files live under `desktops/<name>/config/<app>/` and are linked individually with `home.file.".config/<app>"` (never mount all of `~/.config` at once — other modules also write there).
- `programs/<name>/` — a single program/tool, as `configuration.nix` (system-level) and/or `home.nix` (home-manager), depending on what the program needs. Hosts import them one by one, so a program meant for every machine (e.g. `programs/1password`, `programs/docker`) has to be added to each host's imports.
- `games/<name>/` — same shape as `programs/`, for games and emulators. Currently only `t480` imports them.
- `users/<name>/home.nix` — the base home-manager config for a user, imported once from `flake.nix`. Put things here that should apply regardless of which desktop/host is in use (e.g. `programs.git`, `programs/uv`, GTK bookmarks). Desktop-specific home-manager config that every user should get belongs in the relevant `desktops/*/home.nix` instead. When a user preference must override a desktop default *only if that desktop is present* (e.g. Noctalia dock pins), use a gated override module such as `users/<name>/noctalia-overrides.nix` (`lib.optionalAttrs (options.programs ? noctalia) { ... }`) rather than putting user apps into the desktop module. For a desktop without a `home.nix` (GNOME), gate the whole user module on the system option instead: `lib.mkIf osConfig.services.desktopManager.gnome.enable` in `users/<name>/gnome.nix`. It must be an `mkIf`, since `lib.optionalAttrs config...` recurses while the home-manager submodule type is resolved.
- `lib/` — shared Nix helpers used by modules. `lib/unstable.nix` builds the configured `nixpkgs-unstable` package set (see the "Unstable packages" convention).

### Conventions

- **Unstable packages**: the base system tracks `nixpkgs` (`nixos-26.05`); individual apps may instead take a single package from `nixpkgs-unstable` when stable lags. Do this by importing `lib/unstable.nix` and pointing the module's `package` option at it (e.g. `programs.vscodium.package = unstable.vscodium`), **not** by adding a `nixpkgs.overlays` entry. `lib/unstable.nix` reuses `pkgs.config`, so a module's local `allowUnfreePackages` declaration still applies to the unstable package. Only fall back to an overlay when a package is pulled in indirectly and has no `package` option to override.
- **Unfree packages**: never set `nixpkgs.config.allowUnfree = true` or override `allowUnfreePredicate` globally. Each module that needs an unfree package declares it locally with `nixpkgs.config.allowUnfreePackages = [ "pkg-name" ]`, which merges additively across modules (see `programs/1password/configuration.nix`).
- **Secrets**: never committed to the repo or referenced as Nix store paths (which would copy them into the world-readable store). Reference a plain runtime path instead (e.g. `"${config.home.homeDirectory}/.config/<app>/env"` passed to a module's `environmentFiles`) and document that the user must create the file themselves.
- **Mutable user files**: don't manage user-editable files with `home.file` (that makes a read-only store symlink). Seed defaults once via `home.activation` when the target is missing — see the GTK bookmarks seed in `users/sander/home.nix`.
- **Commit messages**: focus on *why*, not *what* — the diff already shows what changed. Look at `git log` for tone/length before writing one.

### Noctalia gotchas

- **Stable packages, local wiring**: `noctalia` and `noctalia-greeter` come from stable `nixpkgs` so they're served from the binary cache instead of being compiled locally. NixOS 26.05 and home-manager 26.05 have no modules for them, so `desktops/noctalia/configuration.nix` wires up the services and greeter by hand, and `desktops/noctalia/settings-module.nix` provides `programs.noctalia.settings`. Nixpkgs' unstable modules can't be imported instead: the greeter module needs `security.polkit.enablePkexecWrapper`, which 26.05 doesn't have. Replace the local wiring with the built-in modules when moving to a release that has them, and keep `XDG_DATA_DIRS` in the greeter command if the module doesn't set it.
- **Downgrades**: Noctalia refuses a `settings.toml` whose `config_version` is newer than it supports (`version N is newer than supported version M`). When moving to an older release, lower that value in `~/.local/state/noctalia/settings.toml`.
- **Config vs runtime state**: `programs.noctalia.settings` (Nix) only seeds *defaults* into `~/.config/noctalia/config.toml`. The app's own mutable state at `~/.local/state/noctalia/settings.toml` (written when the user changes things through the settings UI) can shadow those defaults once it exists — so a rebuild doesn't always change what's visibly active until the runtime state is also updated (via the UI, or by clearing it).
- **Dock pins**: the desktop sets a minimal `settings.dock.pinned` with `lib.mkDefault` (apps that ship with the desktop). User-specific pins live in `users/<name>/noctalia-overrides.nix` and replace that list when Noctalia is loaded. Nested TOML lists don't merge additively — keep the full pin list in one place (the override), not split across modules without `mkDefault`/`mkForce`.
- **Discovering valid ids**: dock pins, theme template ids, and greeter color schemes aren't documented in this repo. Find them by inspecting the installed packages directly: theme template ids are the keys under `[templates.*]` in `share/noctalia/assets/templates/builtin.toml` inside the `noctalia` package in the Nix store; dock pin ids match `.desktop` file basenames under `/run/current-system/sw/share/applications`; builtin color scheme names can be found via the `noctalia` package's shell completions (e.g. `share/bash-completion/completions/noctalia`).
- **Hyprland Lua theming**: Noctalia applies its color scheme to Hyprland by appending `require("noctalia").apply_theme()` to `hyprland.lua` at runtime, then greps that exact string to skip re-appending. Since our `hyprland.lua` is a read-only store symlink, that write fails silently every time unless the line is already there — so it must live literally in `desktops/noctalia/config/hypr/hyprland.lua` (top-level, not a submodule), wrapped in `pcall` since `noctalia.lua` doesn't exist until Noctalia's first run.
- **Niri theming**: same problem for Niri. Noctalia's niri template writes `~/.config/niri/noctalia.kdl` and appends `include "noctalia.kdl"` to `config.kdl`, which is a read-only store symlink. The include therefore lives literally at the end of `desktops/noctalia/config/niri/config.kdl` as `include optional=true "noctalia.kdl"`. The `optional=true` matters: a plain include makes niri reject the whole config until Noctalia has run once. Only `config.kdl` is linked (not the whole `~/.config/niri` directory), so Noctalia can still write `noctalia.kdl` next to it.
- **Niri without X**: the Niri session deliberately has no `xwayland-satellite`; apps that need X won't start under Niri. Prefer native Wayland flags over adding it back.

### Hardware note

`infinity` is a laptop whose built-in panel is `eDP-1`, not a desktop with a fixed external monitor. Don't hardcode external output names (e.g. `DP-1`) into Hyprland monitor/workspace rules unless the rule is meant to apply only while docked — it silently breaks (or leaves things in an unexpected state, e.g. wrong starting workspace) when undocked.
