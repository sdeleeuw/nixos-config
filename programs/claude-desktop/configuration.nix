{ ... }:

{
  # Claude Desktop's embedded "Claude Code" feature downloads a generic
  # dynamically-linked binary to ~/.config/Claude/claude-code/<version>/claude
  # at runtime (not a Nix package, so autoPatchelfHook never touches it).
  # nix-ld provides the /lib64/ld-linux-x86-64.so.2 stub it expects.
  programs.nix-ld.enable = true;
}
