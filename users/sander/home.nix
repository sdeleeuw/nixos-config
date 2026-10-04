{
  config,
  lib,
  ...
}:

{
  imports =
    [
      ../../programs/claude-code/home.nix
      ../../programs/claude-desktop/home.nix
      ../../programs/cursor/home.nix
      ../../programs/fnm/home.nix
      ../../programs/github-cli/home.nix
      ../../programs/hermes-agent/home.nix
      ../../programs/pi-coding-agent/home.nix
      ../../programs/poetry/home.nix
      ../../programs/slack/home.nix
      ../../programs/uv/home.nix
      ../../programs/vscodium/home.nix
      ./gnome-overrides.nix
      ./noctalia-overrides.nix
      ./oudommen.nix
    ];

  home.username = "sander";
  home.homeDirectory = "/home/sander";

  home.file.".wallpapers" = {
    source = ../../wallpapers;
    recursive = true;
  };

  # Creates ~/Downloads, ~/Documents, ~/Pictures, ~/Music, ~/Videos and
  # ~/Projects (home-manager's default set, which conveniently already
  # includes Projects) so the gtk bookmarks below resolve to real
  # directories instead of dangling shortcuts.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Seed mutable bookmarks once; edit freely afterwards without HM clobbering.
  home.activation.seedGtkBookmarks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    bookmarks="$HOME/.config/gtk-3.0/bookmarks"
    if [[ ! -e $bookmarks ]]; then
      mkdir -p "$(dirname "$bookmarks")"
      install -m 644 ${./gtk-3.0/bookmarks} "$bookmarks"
    fi
  '';

  programs.git = {
    enable = true;
    settings.user = {
      name = "Sander de Leeuw";
      email = "s.deleeuw@gmail.com";
    };
  };

  programs.vim.enable = true;

  programs.bash = {
    enable = true;
    shellAliases.dc = "docker compose";
  };

  # Fixed-path SSH agent (socket at $XDG_RUNTIME_DIR/ssh-agent) instead of a
  # password manager's agent. IdentityAgent overrides SSH_AUTH_SOCK for ssh
  # and git, so this works even without SSH_AUTH_SOCK exported in the shell.
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    # The upstream default config is deprecated; pin the values we want
    # explicitly instead (same defaults as before, plus IdentityAgent).
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = "\${XDG_RUNTIME_DIR}/ssh-agent";
      ForwardAgent = false;
      AddKeysToAgent = "yes";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };

  # `programs.ssh` links `~/.ssh/config` to a read-only file in the Nix
  # store. OpenSSH rejects that target ("Bad owner or permissions") because
  # the store file isn't owned by the user, which breaks git pushes from
  # agents. Force the generated symlink to be replaceable, then overwrite it
  # with a real user-owned copy after each activation.
  home.file.".ssh/config".force = true;

  home.activation.sshConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    mkdir -p -m 700 "$HOME/.ssh"
    rm -f "$HOME/.ssh/config"
    install -m 600 ${config.home.file.".ssh/config".source} "$HOME/.ssh/config"
  '';

  home.stateVersion = "26.05";
}
