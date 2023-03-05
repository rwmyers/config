#!/bin/zsh
if ! type "stack" > /dev/null;
then
    # https://docs.haskellstack.org/en/stable/
    curl -sSL https://get.haskellstack.org/ | sh
fi


if [ ! -d "$HOME/src/kmonad" ]
then
    pushd ~/src/
    git clone https://github.com/kmonad/kmonad.git
    popd
fi

if ! type "kmonad" > /dev/null;
then
    pushd ~/src/kmonad
    stack install
    popd
fi

# https://github.com/kmonad/kmonad/blob/master/doc/faq.md
sudo modprobe uinput
if [ $(groups | grep uinput | wc -c) -eq 0 ]
then
    sudo groupadd uinput > /dev/null
    sudo usermod -aG input $USER
    sudo usermod -aG uinput $USER
    echo "Restart or relog to get group access to uinput..."
fi
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/70-kmonad.rules > /dev/null

# Run kmonad as a user service. This already exists in src/config, which is symlinked
if [ $(systemctl --user --type=service | grep kmonad | wc -c) -eq 0 ]
then
    systemctl --user start kmonad.service
    systemctl --user enable kmonad.service
fi