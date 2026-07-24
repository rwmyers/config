{ config, lib, pkgs, ... }:

let
  # Same per-machine feature toggles home.nix uses, for Linux-only optionals.
  enabled = import ./features.nix { inherit config lib; };
in
{
  # Linux-only packages (merged with home.nix's list by Home Manager). Always-on
  # tools in the list; feature-toggled optionals appended below.
  home.packages = with pkgs; [
    bluetui # bluetooth TUI; drives BlueZ
    wifitui # NetworkManager Wi-Fi TUI (nicer nmtui); Waybar network right-click
  ]
  # steam is an FHS wrapper; no nixGL wrap.
  ++ lib.optional (enabled "steam") steam
  # kmonad needs uinput; see install/env/kmonad.sh for the system setup.
  ++ lib.optional (enabled "kmonad") kmonad;

  # systemd user services (e.g. elephant, walker's app indexer) don't inherit the
  # compositor's environment, so give them the Nix profile paths here.
  systemd.user.sessionVariables = {
    # NOTE: ${XDG_DATA_DIRS} expands to EMPTY in the systemd user manager (unlike
    # PATH), so the system dirs must be spelled out or they get dropped — losing
    # /usr/share breaks the whole graphical session.
    XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:/nix/var/nix/profiles/default/share:/usr/local/share:/usr/share:/var/lib/snapd/desktop";
    PATH = "${config.home.homeDirectory}/.nix-profile/bin:\${PATH}";
  };
}
