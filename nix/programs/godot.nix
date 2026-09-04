# Godot game engine + toolchain. Optional; toggle `godot` via `dot config`.
# Standard (GDScript) build only - the C#/.NET build is deliberately not packaged here.
#
# Nix rather than Flathub or the official zip: Godot has none of the sandbox problems
# that pushed steam/discord/spotify out of Nix (see install/etc/*.sh), nothing here
# needs a writable install prefix the way the Android SDK does, nixpkgs tracks Godot
# closely (4.7.1-stable) so the pin is not a liability the way it is for Android
# Studio, it is cached for both x86_64-linux and aarch64-darwin, and the editor and
# its export templates are built from one version attr in nixpkgs so they can never
# drift apart.
{ config, lib, pkgs, nixgl, ... }:

let
  enabled = import ../features.nix { inherit config lib; };
  on = enabled "godot";

  godotPkgs = pkgs.godotPackages_4;   # 4.7.x; see plan §3.3 for pinning an older set
  nixGL = nixgl.packages.${pkgs.stdenv.hostPlatform.system};

  # Like home.nix's wrapGL, with two differences Godot needs:
  #  * Godot 4 renders with Vulkan by default, and nixGLIntel only sets up OpenGL
  #    (nixGL.nix:161-163). Vulkan ICDs come from a *separate* wrapper,
  #    nixVulkanIntel (= nixVulkanMesa, nixGL.nix:165-203), so nest both.
  #  * Godot ships several binary names (godot, godot4, godot4.7 - common.nix:672-677)
  #    and a .desktop file whose Exec points at its own store path
  #    (common.nix:684-690). Wrap every binary, and rewrite the Exec line, or the
  #    app launcher silently starts the unwrapped editor.
  wrapGodot = pkg:
    if pkgs.stdenv.hostPlatform.isLinux then
      pkgs.symlinkJoin {
        name = "${pkg.pname}-nixgl";
        paths = [ pkg ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          for f in ${pkg}/bin/*; do
            name=$(basename "$f")
            rm -f "$out/bin/$name"
            makeWrapper ${nixGL.nixVulkanIntel}/bin/nixVulkanIntel "$out/bin/$name" \
              --add-flags ${nixGL.nixGLIntel}/bin/nixGLIntel \
              --add-flags "$f"
          done
          for d in ${pkg}/share/applications/*.desktop; do
            name=$(basename "$d")
            rm -f "$out/share/applications/$name"
            substitute "$d" "$out/share/applications/$name" \
              --replace-warn "Exec=${pkg}/bin/" "Exec=$out/bin/"
          done
        '';
      }
    else pkg;   # macOS: no nixGL, the .app bundle is used as-is

  editor = wrapGodot godotPkgs.godot;

  # Official Godot_v<ver>_export_templates.tpz, fetched by nixpkgs from the GitHub
  # release and unpacked to $out/share/godot/export_templates/<dotted-version>/
  # (export-templates-bin.nix:39-44). Same `version` attr as the editor by
  # construction (default.nix:21-31,44), so they cannot drift.
  templates = godotPkgs.export-templates-bin;

  # Godot's own per-user template root. Not XDG_DATA_DIRS-searched - a fixed path.
  templateRoot =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "${config.home.homeDirectory}/Library/Application Support/Godot/export_templates"
    else "${config.home.homeDirectory}/.local/share/godot/export_templates";
in
lib.mkIf on {
  home.packages = [ editor pkgs.gdtoolkit_4 ];

  # Link the version directory the template package provides into the place Godot
  # looks. Discovering the directory name at activation time (rather than computing
  # "4.7.1.stable" from the derivation version) keeps this correct whatever the
  # .tpz's version.txt actually says. Mirrors the activation-script style already
  # used in nix/darwin.nix:34.
  home.activation.godotExportTemplates =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      root=${lib.escapeShellArg templateRoot}
      run mkdir -p "$root"
      # Clear only links we own (into the store); leave hand-installed sets alone.
      for e in "$root"/*; do
        [ -L "$e" ] || continue
        case "$(readlink "$e")" in /nix/store/*) run rm "$e" ;; esac
      done
      for t in ${templates}/share/godot/export_templates/*; do
        run ln -sfn "$t" "$root/$(basename "$t")"
      done
    '';

  # Linux only. Overrides the profile's own entry by using the SAME basename, so
  # the launcher gets the nixGL-wrapped Exec. ~/.local/share (XDG_DATA_HOME) is
  # searched before XDG_DATA_DIRS, which is where ~/.nix-profile/share sits
  # (nix/linux.nix:24). The basename tracks major.minor so a later editor bump
  # keeps shadowing the package's own entry instead of adding a second, unwrapped
  # launcher.
  xdg.desktopEntries = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "org.godotengine.Godot${lib.versions.majorMinor godotPkgs.godot.version}" = {
      name = "Godot Engine ${lib.versions.majorMinor godotPkgs.godot.version}";
      exec = "${editor}/bin/godot %f";
      icon = "godot";
      terminal = false;
      type = "Application";
      categories = [ "Development" "IDE" ];
      mimeType = [ "application/x-godot-project" ];
    };
  };
}
