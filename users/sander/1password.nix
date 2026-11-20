# NixOS module (not home-manager), imported by each host next to programs/unstable/1password.
{ ... }:

{
  # The polkit policy allows no one by default, so without this 1Password can't unlock with
  # system authentication (account password or fingerprint), which its `op` CLI integration needs.
  programs._1password-gui.polkitPolicyOwners = [
    "sander"
  ];
}
