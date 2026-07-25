#!/bin/zsh

# systemd user units. ~/.config/systemd used to be a whole-directory symlink to
# this repo, so anything that writes a unit - systemctl enable, home-manager,
# "elephant service enable" - dropped generated files into the repo. Worse, the
# generated .wants symlinks hold absolute paths, so a machine with a different
# username inherited broken links. Make ~/.config/systemd/user a real local
# directory holding the generated files, with only the repo's own units linked
# in. Numbered to sort ahead of the env scripts that enable services.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

REPO_UNITS="$SRC_ROOT/.config/systemd/user"
USER_UNITS="$HOME/.config/systemd/user"

# Units this repo owns. Everything else under USER_UNITS is machine-local.
OWNED=(elephant.service hyprland-session.target kmonad.service waybar.service)

# One-time migration off the whole-directory symlink.
if [ -L "$HOME/.config/systemd" ]
then
    print_note " -- Migrating ~/.config/systemd off the repo symlink"

    # Build the replacement alongside, then swap, so a failure part-way through
    # leaves the existing symlink intact.
    STAGE=$(mktemp -d "$HOME/.config/systemd.XXXXXX")
    mkdir -p "$STAGE/user"
    chmod 755 "$STAGE" "$STAGE/user"

    for entry in $REPO_UNITS/*(ND)
    do
        name="${entry:t}"
        (( $OWNED[(I)$name] )) && continue
        print_note " -- Moving generated $name out of the repo"
        mv "$entry" "$STAGE/user/$name"
    done

    rm "$HOME/.config/systemd"
    mv "$STAGE" "$HOME/.config/systemd"
fi

mkdir -p "$USER_UNITS"

for unit in $OWNED
do
    if [ ! -e "$USER_UNITS/$unit" ]
    then
        print_note " -- Linking $unit"
        ln -s "$REPO_UNITS/$unit" "$USER_UNITS/$unit"
    fi
done

systemctl --user daemon-reload

# elephant's enable link used to be tracked in git; recreate it locally.
systemctl --user enable elephant.service > /dev/null 2>&1
