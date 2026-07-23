{ config, ... }:

{
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
