{ config, pkgs, ... }:

let
  srcDir = "${config.home.homeDirectory}/src/config";
in
{
  imports = [ ./programs/bat.nix ];

  # Bump only intentionally; see Home Manager release notes before changing.
  home.stateVersion = "25.05";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # Don't print the "unread news items" notice on every switch.
  news.display = "silent";

  # Fontconfig discovers fonts from home.packages (Linux); HM links them into
  # ~/Library/Fonts on macOS.
  fonts.fontconfig.enable = true;

  # Cross-platform tools that need no configuration.
  home.packages = with pkgs; [
    alacritty
    btop
    cloc
    delta
    eza
    fastfetch
    fzf
    fzf-git-sh
    gum
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.meslo-lg
    (python3.withPackages (ps: with ps; [
      jinja2
      jq
    ]))
    ripgrep
    starship
    stylua
    taplo
    tmux
    uv
    zoxide
    zsh-fzf-tab
  ];

  home.file.".config/starship".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/starship";

  home.file.".config/alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/alacritty/alacritty.toml";
}
