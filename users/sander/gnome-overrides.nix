{ config, lib, ... }:

{
  # Only applied on a host that imports the GNOME desktop, which is what
  # enables programs.gnome-shell. Mirrors the Noctalia dock pins, swapping
  # the Noctalia-bundled apps (thunar, kitty, mousepad, galculator) for their
  # GNOME counterparts (Files, Console, Text Editor, Calculator).
  #
  # Note: this must be an `mkIf`, not `lib.optionalAttrs config...`, otherwise
  # evaluating the `config` module argument recurses while the home-manager
  # submodule type is being resolved.
  config = lib.mkIf config.programs.gnome-shell.enable {
    dconf.settings."org/gnome/shell".favorite-apps = [
      "org.gnome.Console.desktop"
      "org.gnome.Nautilus.desktop"
      "google-chrome.desktop"
      "helium.desktop"
      "librewolf.desktop"
      "cursor.desktop"
      "codium.desktop"
      "com.anthropic.Claude.desktop"
      "paseo.desktop"
      "com.nousresearch.hermes.desktop"
      "slack.desktop"
      "signal.desktop"
      "com.onepassword.OnePassword.desktop"
      "mullvad-vpn.desktop"
      "vibe_typer.desktop"
      "spotify.desktop"
      "writer.desktop"
      "calc.desktop"
      "org.gnome.TextEditor.desktop"
      "org.gnome.Calculator.desktop"
      "it.mijorus.gearlever.desktop"
    ];
  };
}
