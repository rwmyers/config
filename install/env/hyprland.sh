#!/bin/zsh

# A tool for shell script input and output (https://github.com/charmbracelet/gum)
source $HOME/src/config/install/common.sh

install_linux_package hyprland

if [ ! -d "$HOME/.config/hypr/" ]
then
    print_note " -- Creating hyprland config links"
    mkdir -p ~/.config/hypr
    ln -s $SRC_ROOT/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
fi

if [ ! -d "$HOME/.config/hypr/local" ]
then
    print_note " -- Creating local configs for hyprland"
    mkdir -p ~/.config/hypr/local
    cp $SRC_ROOT/.config/hypr/local/* ~/.config/hypr/local
fi

if [ ! -d "$HOME/.config/hypr/hyprland" ]
then
    print_note " -- Linking root hyprland folder"
    ln -s $SRC_ROOT/.config/hypr/hyprland ~/.config/hypr/hyprland
fi

if [ ! -d "$HOME/.config/hypr/config.d" ]
then
    print_note " -- Creating hypr config.d link"
    ln -s $SRC_ROOT/.config/hypr/config.d ~/.config/hypr/config.d
fi

if [ ! -d "$HOME/.config/hypr/monitors" ]
then
    print_note " -- Seeding hyprland monitors/ from templates"
    mkdir -p ~/.config/hypr/monitors
    cp $SRC_ROOT/.config/hypr/monitors/* ~/.config/hypr/monitors/
fi

if [ ! -e "$HOME/.config/hypr/monitors.conf" ]
then
    print_note " -- Linking monitors.conf -> monitors/default.conf"
    ln -s ~/.config/hypr/monitors/default.conf ~/.config/hypr/monitors.conf
elif [ ! -L "$HOME/.config/hypr/monitors.conf" ]
then
    print_note " -- WARNING: ~/.config/hypr/monitors.conf is a regular file."
    print_note "    Move its contents into ~/.config/hypr/monitors/default.conf,"
    print_note "    then 'rm ~/.config/hypr/monitors.conf' and re-run this script."
fi

LOGIND_DROPIN="/etc/systemd/logind.conf.d/10-no-lid-suspend.conf"
if [ ! -f "$LOGIND_DROPIN" ]
then
    print_note " -- Installing logind drop-in so Hyprland handles lid events"
    sudo mkdir -p /etc/systemd/logind.conf.d
    sudo tee "$LOGIND_DROPIN" > /dev/null <<'EOF'
# Let Hyprland handle lid events (see bindl in hyprland/bindings.conf).
[Login]
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
HandleLidSwitchExternalPower=ignore
EOF
    sudo systemctl restart systemd-logind
fi
