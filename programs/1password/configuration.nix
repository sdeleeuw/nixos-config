{ ... }:

{
  nixpkgs.config.allowUnfreePackages = [
    "1password-cli"
    "1password"
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sander" ];
  };
}
