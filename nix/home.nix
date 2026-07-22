{ pkgs, ... }:

{
  imports = [ ./programs/bat.nix ];

  # Bump only intentionally; see Home Manager release notes before changing.
  home.stateVersion = "25.05";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Don't print the "unread news items" notice on every switch.
  news.display = "silent";

  # Cross-platform tools that need no configuration.
  home.packages = with pkgs; [
    btop
    cloc
    delta
    eza
    fastfetch
    fzf
    fzf-git-sh
    gum
    ripgrep
    starship
    stylua
    taplo
    tmux
    uv
    zoxide
    zsh-fzf-tab
  ];
}
