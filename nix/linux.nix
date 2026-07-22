{ config, ... }:

{
  # systemd user services (e.g. elephant, walker's app indexer) don't inherit the
  # compositor's environment, so give them the Nix profile paths here.
  systemd.user.sessionVariables = {
    XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:/nix/var/nix/profiles/default/share:\${XDG_DATA_DIRS}";
    PATH = "${config.home.homeDirectory}/.nix-profile/bin:\${PATH}";
  };
}
