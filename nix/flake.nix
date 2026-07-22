{
  description = "Cross-platform (Debian/Ubuntu + macOS) Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Portable across machines and usernames: the invoking user's identity is
      # read from the environment rather than hardcoded, so the same config works
      # for a personal login or a corporate alias. This makes evaluation impure,
      # so activate with `--impure` (see install/nix.sh). If the environment is
      # not readable we fail loudly rather than assuming a home directory.
      env = builtins.getEnv;
      username =
        let u = env "USER"; in
        if u != "" then u
        else throw "USER is not set; activate with --impure (see install/nix.sh).";
      homeDirectory =
        let h = env "HOME"; in
        if h != "" then h
        else throw "HOME is not set; activate with --impure (see install/nix.sh).";
      # currentSystem auto-detects x86_64-linux / aarch64-darwin / etc.
      system = builtins.currentSystem;

      # Platform-specific decorator layered on top of the shared home.nix.
      # Guarded by pathExists so it is a no-op until the file is created.
      platformModule =
        if nixpkgs.lib.hasSuffix "darwin" system then ./darwin.nix else ./linux.nix;
      platformModules =
        nixpkgs.lib.optional (builtins.pathExists platformModule) platformModule;
    in
    {
      # Activate with: home-manager switch --impure --flake <this-dir>#default
      homeConfigurations."default" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
          }
        ] ++ platformModules;
      };
    };
}
