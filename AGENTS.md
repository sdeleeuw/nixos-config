# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, OpenCode, etc.) when working with code in this repository.

## Overview

Personal NixOS flake configuration for a single host (`infinity`), using home-manager as a flake module. There is one user, `sander`.

## Commands

- Check the flake evaluates and all modules parse: `nix flake check`
- Build the system closure without activating it: `nix build .#nixosConfigurations.infinity.config.system.build.toplevel`
- Parse a single module for syntax errors: `nix-instantiate --parse <path/to/file.nix>`
- Evaluate an option to inspect its resolved value: `nix eval .#nixosConfigurations.infinity.config.<option.path>`
- Update flake inputs: `nix flake update` (or `nix flake lock --update-input <name>` for one input)

Do not run `nixos-rebuild switch` — that activates the config on the live system and is left to the user to run manually.

## Architecture

`flake.nix` is the single entry point. It declares inputs (nixpkgs, home-manager, and per-program flake inputs like `noctalia`, `hermes-agent`, `noctalia-greeter`) and wires `nixosConfigurations.infinity` from `hosts/infinity/configuration.nix` plus the home-manager module, pointing `home-manager.users.sander` at `users/sander/home.nix`.

Modules are split by concern and composed via imports:

- `hosts/<name>/configuration.nix` — the system-level entry point for a host (boot, users, hardware, timezone), importing whichever `desktops/` and `programs/` modules that host needs.
- `desktops/<name>/` — a desktop environment as a paired unit: `configuration.nix` (system-level: session packages, `programs.hyprland`, `programs.noctalia`, etc.) and `home.nix` (home-manager: per-user settings for that desktop). The system module's imports list ends with `home-manager.users.sander.imports = [ ./home.nix ]`, tying the two halves together so importing the desktop's system module automatically pulls in the matching home-manager config. This keeps system and home-manager config from drifting out of sync. Config for a program that's tightly coupled to the desktop itself (e.g. Hyprland, kitty, Thunar) lives inline in the desktop's own files rather than as a separate `programs/` module — see `desktops/noctalia/home.nix`. App config files live under `desktops/<name>/config/<app>/` and are linked individually with `home.file.".config/<app>"` (never mount all of `~/.config` at once — other modules also write there).
- `programs/<name>/` — a single program/tool, as `configuration.nix` (system-level) and/or `home.nix` (home-manager), depending on what the program needs. These are imported from a host (for programs any host should have, e.g. `programs/claude-desktop`, `programs/1password`).
- `users/<name>/home.nix` — the base home-manager config for a user, imported once from `flake.nix`. Put things here that should apply regardless of which desktop/host is in use (e.g. `programs.git`, `programs/hermes-agent`, GTK bookmarks). Desktop-specific home-manager config belongs in the relevant `desktops/*/home.nix` instead. When a user preference must override a desktop default *only if that desktop is present* (e.g. Noctalia dock pins), use a gated override module such as `users/<name>/noctalia-overrides.nix` (`lib.optionalAttrs (options.programs ? noctalia) { ... }`) rather than putting user apps into the desktop module.

### Conventions

- **Unfree packages**: never set `nixpkgs.config.allowUnfree = true` or override `allowUnfreePredicate` globally. Each module that needs an unfree package declares it locally with `nixpkgs.config.allowUnfreePackages = [ "pkg-name" ]`, which merges additively across modules (see `programs/1password/configuration.nix`, `programs/claude-desktop/configuration.nix`).
- **Secrets**: never committed to the repo or referenced as Nix store paths (which would copy them into the world-readable store). Reference a plain runtime path instead (e.g. `"${config.home.homeDirectory}/.config/hermes-agent/env"` passed to `environmentFiles`) and document that the user must create the file themselves.
- **Mutable user files**: don't manage user-editable files with `home.file` (that makes a read-only store symlink). Seed defaults once via `home.activation` when the target is missing — see the GTK bookmarks seed in `users/sander/home.nix`.
- **Commit messages**: focus on *why*, not *what* — the diff already shows what changed. Look at `git log` for tone/length before writing one.

### Noctalia gotchas

- **Config vs runtime state**: `programs.noctalia.settings` (Nix) only seeds *defaults* into `~/.config/noctalia/config.toml`. The app's own mutable state at `~/.local/state/noctalia/settings.toml` (written when the user changes things through the settings UI) can shadow those defaults once it exists — so a rebuild doesn't always change what's visibly active until the runtime state is also updated (via the UI, or by clearing it).
- **Dock pins**: the desktop sets a minimal `settings.dock.pinned` with `lib.mkDefault` (apps that ship with the desktop). User-specific pins live in `users/<name>/noctalia-overrides.nix` and replace that list when Noctalia is loaded. Nested TOML lists don't merge additively — keep the full pin list in one place (the override), not split across modules without `mkDefault`/`mkForce`.
- **Discovering valid ids**: dock pins, theme template ids, and greeter color schemes aren't documented in this repo. Find them by inspecting the installed packages directly: theme template ids are the keys under `[templates.*]` in `share/noctalia/assets/templates/builtin.toml` inside the `noctalia` package in the Nix store; dock pin ids match `.desktop` file basenames under `/run/current-system/sw/share/applications`; builtin color scheme names can be found via the `noctalia` package's shell completions (e.g. `share/bash-completion/completions/noctalia`).
- **Hyprland Lua theming**: Noctalia applies its color scheme to Hyprland by appending `require("noctalia").apply_theme()` to `hyprland.lua` at runtime, then greps that exact string to skip re-appending. Since our `hyprland.lua` is a read-only store symlink, that write fails silently every time unless the line is already there — so it must live literally in `desktops/noctalia/config/hypr/hyprland.lua` (top-level, not a submodule), wrapped in `pcall` since `noctalia.lua` doesn't exist until Noctalia's first run.

### Hardware note

`infinity` is a laptop whose built-in panel is `eDP-1`, not a desktop with a fixed external monitor. Don't hardcode external output names (e.g. `DP-1`) into Hyprland monitor/workspace rules unless the rule is meant to apply only while docked — it silently breaks (or leaves things in an unexpected state, e.g. wrong starting workspace) when undocked.
