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

  # GNU userland on macOS (replaces the brew coreutils/findutils/... line and the
  # gnubin PATH hack — Nix's are unprefixed and already on ~/.nix-profile/bin,
  # shadowing the BSD tools). Linux already ships GNU, so this is darwin-only.
  home.packages = with pkgs; [
    coreutils
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    gnutls
    indent
    util-linux
  ];

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

  # Swap Control and Fn/Globe. hidutil remaps don't survive a reboot, so a
  # LaunchAgent re-applies it at every login (RunAtLoad). Note: mapping *to* the
  # Fn/Globe key is version-dependent and may not stick even when Fn->Control does.
  launchd.agents.ctrl-fn-swap = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/hidutil" "property" "--set"
        # Left Control (0x7000000E0) <-> Fn/Globe (0xFF00000003)
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0xFF00000003},{"HIDKeyboardModifierMappingSrc":0xFF00000003,"HIDKeyboardModifierMappingDst":0x7000000E0}]}''
      ];
      RunAtLoad = true;
    };
  };
}
