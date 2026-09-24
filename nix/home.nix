{ config, lib, pkgs, nixgl, nixpkgs-herdr, ... }:

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

  # herdr comes from its own pinned input (see flake.nix) rather than the shared
  # nixpkgs, so it can be bumped on its own without moving everything else. This
  # binding deliberately shadows pkgs.herdr in the `with pkgs` list below.
  herdr = nixpkgs-herdr.legacyPackages.${pkgs.stdenv.hostPlatform.system}.herdr;

  # nixpkgs' bazelisk ships upstream's release-tooling `sha256sum` helper in
  # bin/ next to the real binary. On PATH it shadows coreutils' sha256sum and
  # breaks `sha256sum -c` (install/development/android-studio.sh, among anything
  # else that verifies checksums). Link only the bazelisk binary itself. This
  # binding deliberately shadows pkgs.bazelisk in the `with pkgs` list below.
  bazelisk = pkgs.runCommand "bazelisk-${pkgs.bazelisk.version}" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.bazelisk}/bin/bazelisk $out/bin/bazelisk
  '';

  # Optional installs, toggled per-machine in ~/.config/dotfiles.conf. Linux-only
  # optionals live in linux.nix; cross-platform ones stay here.
  enabled = import ./features.nix { inherit config lib; };
in
{
  imports = [ ./programs/bat.nix ./programs/godot.nix ];

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
    herdr
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    nodejs
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
  ]
  # Cross-platform optionals; Linux-only ones are in linux.nix.
  ++ lib.optional (enabled "bazelisk") bazelisk
  # sdkmanager (cmdline-tools 19+) needs JDK 17 or newer; Gradle 8.5+ and
  # AGP 8.9+ run on 21. Studio bundles its own JetBrains Runtime and does not
  # use this one — it is for sdkmanager and command-line Gradle. Gated on either
  # Android feature, since install/development/android-sdk.sh needs it too.
  ++ lib.optional (enabled "android-sdk" || enabled "android-studio") jdk21
  ++ lib.optional (enabled "claude-code") claude-code
  # GitHub CLI, install only; auth and git integration are left to the user.
  ++ lib.optional (enabled "gh") gh;

  home.file.".config/starship".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/starship";

  home.file.".config/alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/alacritty/alacritty.toml";

  home.file.".config/wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/wezterm/wezterm.lua";

  # Only config.toml: herdr keeps its sockets, logs and session state beside it.
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${srcDir}/.config/herdr/config.toml";
}
