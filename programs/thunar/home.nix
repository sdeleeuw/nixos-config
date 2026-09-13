{ config, ... }:

{
  xfconf.settings.thunar = {
    "default-view" = "ThunarDetailsView";
    "last-view" = "ThunarDetailsView";
  };

  home.file.".config/gtk-3.0/bookmarks".text = ''
    file://${config.home.homeDirectory}/Downloads Downloads
    file://${config.home.homeDirectory}/Projects Projects
    file://${config.home.homeDirectory}/Documents Documents
    file://${config.home.homeDirectory}/Pictures Pictures
    file://${config.home.homeDirectory}/Music Music
    file://${config.home.homeDirectory}/Videos Videos
  '';
}
