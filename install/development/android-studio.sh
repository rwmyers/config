#!/bin/zsh

# Android Studio (https://developer.android.com/studio). Optional — toggle the
# `android-studio` feature via `dot config`. Implies the android-sdk feature; see
# install/development/android-sdk.sh.
#
# Not from Nix on Linux, even though nixpkgs has it: nixpkgs trails Google by
# months (this repo's pinned flake is on 2024.3.1.15) and this config wants the
# current stable Studio. Google's own tarball is used instead, in the same shape
# as install/pkg_mgmt/golang.sh — ask upstream what is current, fetch, unpack.
# macOS takes the Homebrew cask, which brew keeps current for free; nixpkgs'
# android-studio is platforms = [ "x86_64-linux" ] and is unavailable on darwin
# at all.
#
# BOOTSTRAP ONLY. Studio updates itself in place from here on, so a re-run finds
# the install and exits without touching it — re-asserting a version would fight
# Studio's own updater and could downgrade it. To reinstall from scratch:
#   rm -rf ~/.local/share/android-studio && dot update
# Toggling the feature off skips this script and uninstalls nothing, same stance
# as install/etc/steam.sh.
source $HOME/src/config/install/common.sh

feature_enabled android-studio || exit 0

if [[ "$OSTYPE" == "darwin"* ]]
then
    # setup.sh:3-13 already guarantees brew. A deliberate exception to "macOS
    # packages come from nix/darwin.nix", for the reason in the header.
    [ -d "/Applications/Android Studio.app" ] && exit 0
    print_note " -- Installing Android Studio"
    brew install --cask android-studio
    exit 0
fi

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

# ~/.local/share, not /usr/local: Studio's in-place updater has to be able to
# write its own install directory, and a root-owned one silently breaks patch
# updates. ~/.local/bin (below) is already on PATH (.zshrc:42, setup_path) and is
# where install/development/antigravity.sh puts its binary.
STUDIO_HOME="$HOME/.local/share/android-studio"
[ -d "$STUDIO_HOME" ] && exit 0

# Google publishes no aarch64 Linux build of Studio — the release feed's only
# Linux artefact is x86_64. Say so rather than unpacking something that can't run.
if [ "$(uname -m)" != "x86_64" ]
then
    print_error " -- Android Studio has no Linux build for $(uname -m); skipping."
    exit 0
fi

print_note " -- Resolving the current stable Android Studio"
# JetBrains publishes Google's release index as JSON — every channel, every
# artefact, with SHA-256s. https://jb.gg/android-studio-releases-list.json is the
# documented short link. It has to come from the feed rather than be built from a
# version number: the filename carries a release codename
# (android-studio-quail4-linux.tar.gz), not just the version.
# python3 comes from Nix (nix/home.nix:61); there is no jq in this config.
release=$(curl -fsSL https://jb.gg/android-studio-releases-list.json 2>/dev/null | python3 -c '
import json, sys
items = json.load(sys.stdin)["content"]["item"]
rel = next(i for i in items if i.get("channel") == "Release")
dl = next(d for d in rel["download"] if d["link"].endswith("-linux.tar.gz"))
print(rel["version"], dl["link"], dl["checksum"])
' 2>/dev/null)

if [ -z "$release" ]
then
    print_error " -- Could not resolve an Android Studio download; skipping. Re-run 'dot update' later."
    exit 0
fi

version=${${(z)release}[1]}
url=${${(z)release}[2]}
checksum=${${(z)release}[3]}

print_note " -- Installing Android Studio $version into $STUDIO_HOME"

# Stage inside ~/.local/share so the final move is a rename, not a 1.5 GB copy
# across filesystems (mktemp -d would land in /tmp, often a separate mount).
mkdir -p "$HOME/.local/share"
tmp=$(mktemp -d "$HOME/.local/share/.android-studio-XXXXXX")
curl -fSL --progress-bar -o "$tmp/studio.tar.gz" "$url"

if ! echo "$checksum  $tmp/studio.tar.gz" | sha256sum -c - > /dev/null
then
    print_error " -- Android Studio download failed its checksum; not installing."
    rm -rf "$tmp"
    exit 1
fi

# The tarball unpacks to a single android-studio/ directory.
tar -C "$tmp" -xzf "$tmp/studio.tar.gz"
mv "$tmp/android-studio" "$STUDIO_HOME"
rm -rf "$tmp"

# The launcher was renamed from bin/studio.sh to bin/studio in the 2024.2 line;
# accept either so this doesn't break on an older or newer layout.
launcher="$STUDIO_HOME/bin/studio"
[ -x "$launcher" ] || launcher="$STUDIO_HOME/bin/studio.sh"

mkdir -p "$HOME/.local/bin"
ln -sf "$launcher" "$HOME/.local/bin/studio"

# Desktop entry — a Nix package would have supplied this and an icon for free; a
# tarball does not. Same directory, same heredoc shape as bin/webapp-install:26-74.
# Written here rather than by calling webapp-install, because that script demands
# a URL it would never use and its bin/webapp-remove counterpart identifies its
# own entries by `Exec=.*webapp-launch`. The icon ships inside the tarball, so
# nothing is downloaded and no icons/ copy is needed.
# StartupWMClass is what lets the compositor match the running window to this
# entry; Studio's JBR sets it to jetbrains-studio.
icon="$STUDIO_HOME/bin/studio.png"
[ -f "$icon" ] || icon="$STUDIO_HOME/bin/studio.svg"

mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/android-studio.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Android Studio
Comment=The Drive to Develop
Exec="$launcher" %f
Icon=$icon
Categories=Development;IDE;
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-studio
DESKTOP
