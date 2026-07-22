{ pkgs, ... }:

{
  # Bump only intentionally; see Home Manager release notes before changing.
  home.stateVersion = "25.05";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Don't print the "unread news items" notice on every switch.
  news.display = "silent";

  home.packages = with pkgs; [
    bat
  ];
}
