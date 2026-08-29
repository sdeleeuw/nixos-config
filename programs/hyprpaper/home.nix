{ ... }:

{
  home.file.".wallpapers".source = ../../wallpapers;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/.wallpapers/nordic.jpg"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "~/.wallpapers/nordic.jpg";
        }
      ];
    };
  };
}
