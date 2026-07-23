# Optional installs, toggled per-machine in ~/.config/dotfiles.conf (written by
# install/features.sh). Returns an `enabled` predicate; missing file or unset key
# means disabled. Imported by home.nix and the platform decorators so each can
# gate its own optional packages.
{ config, lib }:

let
  conf = "${config.home.homeDirectory}/.config/dotfiles.conf";
  features =
    if builtins.pathExists conf then
      builtins.listToAttrs (
        map (l: let p = lib.splitString "=" l; in lib.nameValuePair (lib.head p) (lib.last p == "true"))
          (lib.filter (l: l != "" && !(lib.hasPrefix "#" l)) (lib.splitString "\n" (builtins.readFile conf)))
      )
    else { };
in
name: features.${name} or false
