# bat: binary, config, and Catppuccin themes — all declarative.
{ pkgs, ... }:
let
  catppuccinBat = pkgs.fetchgit {
    url = "https://github.com/catppuccin/bat";
    rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };
  mkTheme = flavor: {
    src = catppuccinBat;
    file = "themes/Catppuccin ${flavor}.tmTheme";
  };
in
{
  programs.bat = {
    enable = true;

    config = {
      theme = "Catppuccin Mocha";
      map-syntax = [ "**/.functions/*:Bourne Again Shell (bash)" ];
    };

    themes = {
      "Catppuccin Latte" = mkTheme "Latte";
      "Catppuccin Frappe" = mkTheme "Frappe";
      "Catppuccin Macchiato" = mkTheme "Macchiato";
      "Catppuccin Mocha" = mkTheme "Mocha";
    };
  };
}
