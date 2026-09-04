#!/bin/zsh

# Android SDK command-line tools (https://developer.android.com/studio#command-line-tools-only).
# Optional — toggle the `android-sdk` feature via `dot config`; enabling
# `android-studio` implies it, since an IDE with no SDK is a half-install.
#
# Not from Nix: pkgs.androidenv composes a pinned SDK into the read-only store,
# but $ANDROID_HOME has to be writable — sdkmanager, Studio's SDK manager and
# `flutter doctor --android-licenses` all write into it. The SDK is mutable
# project state, not a package. Nix does supply the JDK sdkmanager runs on
# (nix/home.nix).
#
# Toggling the feature off just skips this script; it never removes ~/Android/Sdk,
# which holds accepted licences and downloaded platforms. Same stance as
# install/etc/steam.sh.
source $HOME/src/config/install/common.sh

feature_enabled android-sdk || feature_enabled android-studio || exit 0

# Google's default location per platform (install/common.sh). Keep it: every
# Android tool, Studio and Flutter probe these paths before consulting
# $ANDROID_HOME.
SDK="$(android_sdk_dir)"

# Host key for Google's download archives. Note the macOS names: the archives are
# mac_arm64 / mac_x86_64. A plain "-mac-" URL 404s — it was renamed.
if [[ "$OSTYPE" == "darwin"* ]]
then
    [ "$(uname -m)" = "arm64" ] && host=mac_arm64 || host=mac_x86_64
else
    host=linux
fi

# Bootstrap only — sdkmanager replaces this copy with the current one via
# "cmdline-tools;latest" below, so this constant matters exactly once per
# machine. Preferred path is to read the current archive out of Google's own
# package manifest (below); this is the offline / manifest-moved fallback.
CMDLINE_FALLBACK_BUILD=16111833
REPO_XML="https://dl.google.com/android/repository/repository2-3.xml"

if [ ! -x "$SDK/cmdline-tools/latest/bin/sdkmanager" ]
then
    print_note " -- Installing Android SDK command-line tools into $SDK"
    install_linux_package unzip

    # Ask Google's package manifest — the same file sdkmanager consumes — for
    # today's cmdline-tools archive, rather than hardcoding a build number.
    # python3 comes from Nix (nix/home.nix:61); there is no jq in this config.
    url=$(curl -fsSL "$REPO_XML" 2>/dev/null | python3 -c '
import sys, re
xml = sys.stdin.read()
m = re.search(r"<remotePackage path=\"cmdline-tools;latest\"(.*?)</remotePackage>", xml, re.S)
want = sys.argv[1]
for a in re.finditer(r"<archive>(.*?)</archive>", m.group(1), re.S):
    b = a.group(1)
    u = re.search(r"<url>([^<]*)</url>", b).group(1)
    if want in u:
        print("https://dl.google.com/android/repository/" + u)
        break
' "$host" 2>/dev/null)

    if [ -z "$url" ]
    then
        print_note "    manifest lookup failed; falling back to the pinned build"
        url="https://dl.google.com/android/repository/commandlinetools-${host}-${CMDLINE_FALLBACK_BUILD}_latest.zip"
    fi

    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/cmdline-tools.zip" "$url"
    unzip -q "$tmp/cmdline-tools.zip" -d "$tmp"
    # The zip unpacks to cmdline-tools/; sdkmanager insists on living at
    # $SDK/cmdline-tools/<channel>/bin, so slot it in as "latest".
    mkdir -p "$SDK/cmdline-tools"
    mv "$tmp/cmdline-tools" "$SDK/cmdline-tools/latest"
    rm -rf "$tmp"
fi

SDKMANAGER="$SDK/cmdline-tools/latest/bin/sdkmanager"

# sdkmanager is a Java program and cmdline-tools 19+ needs JDK 17 or newer; the
# JDK comes from Nix (nix/home.nix, jdk21). Say so rather than failing with a
# stack trace on a machine that hasn't switched yet.
if ! type java > /dev/null 2>&1
then
    print_error " -- No java on PATH; run 'dot update' so Nix installs the JDK, then re-run."
    exit 0
fi

# Licences have to be accepted before anything will install. Idempotent — a
# second run finds them all accepted and returns immediately.
yes | "$SDKMANAGER" --sdk_root="$SDK" --licenses > /dev/null

# The baseline every Android build needs. Pinned on purpose rather than resolved
# to "newest": platforms are additive and multi-hundred-MB, and the compile
# target is a project decision. `sdkmanager --list` shows what is current; bump
# these deliberately. No emulator and no system images by choice.
PACKAGES=(
    "cmdline-tools;latest"
    "platform-tools"
    "build-tools;37.0.0"
    "platforms;android-37.2"
)

for pkg in $PACKAGES
do
    # Cheap presence check so an unchanged re-run does no network I/O.
    "$SDKMANAGER" --sdk_root="$SDK" --list_installed 2>/dev/null | grep -q "^  *${pkg} " && continue
    print_note " -- Installing $pkg"
    "$SDKMANAGER" --sdk_root="$SDK" --install "$pkg"
done
