{ config, pkgs, nixgl, ... }:

let
  srcDir = "${config.home.homeDirectory}/src/config";

  # Wrap a GUI package so it runs under nixGL (system Mesa GL) on Linux, where
  # Nix apps can't otherwise find the system's libGL/libEGL. No-op on macOS.
  wrapGL = pkg: exe:
    if pkgs.stdenv.hostPlatform.isLinux then
      pkgs.symlinkJoin {
        name = "${exe}-nixgl";
        paths = [ pkg ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm $out/bin/${exe}
          makeWrapper ${nixgl.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel}/bin/nixGLIntel \
            $out/bin/${exe} --add-flags ${pkg}/bin/${exe}
        '';
      }
    else
      pkg;
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
    (wrapGL alacritty "alacritty")
    btop
    cloc
    delta
    eza
    fastfetch
    fd
    fzf
    fzf-git-sh
    gum
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.hack
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
    (wrapGL wezterm "wezterm")
    zoxide
    zsh-autosuggestions
    zsh-fzf-tab
    zsh-syntax-highlighting
  ];

  home.file.".config/starship".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/starship";

  home.file.".config/alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/alacritty/alacritty.toml";

  home.file.".config/wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/wezterm/wezterm.lua";
}
