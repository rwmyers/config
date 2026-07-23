{ config, lib, pkgs, ... }:

let
  # Apps (by .app bundle name) to add to the Dock, once each per machine.
  # Add more names here to dock more apps.
  dockApps = [ "WezTerm" ];
in
{
  # Copy (not symlink) Nix .app bundles into ~/Applications/Home Manager Apps so
  # Finder / Spotlight index them. linkApps (the default at stateVersion 25.05)
  # symlinks, which macOS won't index. copyApps prompts once for the "App
  # Management" permission on the terminal running home-manager.
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  # For each app: dock it once (per-app marker stops re-adding if you later remove
  # it; the --find check avoids a duplicate if it's already there). Restart the
  # Dock once at the end, only if something actually changed.
  home.activation.dockApps = lib.hm.dag.entryAfter [ "copyApps" ] ''
    dockChanged=0
    ${lib.concatMapStringsSep "\n" (name: ''
      app="$HOME/Applications/Home Manager Apps/${name}.app"
      marker="${config.home.homeDirectory}/.local/state/home-manager/docked-${name}"
      if [ ! -e "$marker" ] && [ -d "$app" ]; then
        if ! ${pkgs.dockutil}/bin/dockutil --find "${name}" > /dev/null 2>&1; then
          run ${pkgs.dockutil}/bin/dockutil --add "$app" --no-restart || true
          dockChanged=1
        fi
        run mkdir -p "$(dirname "$marker")"
        run touch "$marker"
      fi
    '') dockApps}
    if [ "$dockChanged" = 1 ]; then
      run /usr/bin/killall Dock || true
    fi
  '';
}
