#!/bin/bash

IFS=$'\n'
adb-root-remount() {
    adb root && adb remount
}

alias keyevent="adb shell input keyevent"
alias inputtext="adb shell input text"


ALIASES_FILE="$HOME/.adbenvaliases"
ALIASES_DELIMITER="="
SEPARATOR="\n"

function ensureAliasFile {
    if [ ! -e $ALIASES_FILE ]; then
        touch $ALIASES_FILE
    fi
}
ensureAliasFile

function get_devices_with_aliases {
    devicelist_with_aliases=""

    device_list=($(adb devices | grep "device$" | cut -f1))

    for device in "${device_list[@]}"; do
        alias=$(grep $device $ALIASES_FILE | cut -d$ALIASES_DELIMITER -f2)
        devicelist_with_aliases=$devicelist_with_aliases$device$ALIASES_DELIMITER$alias$SEPARATOR
    done

    echo -e $devicelist_with_aliases | sed '$ d'
}

function get_devices_with_aliases_user_formatted {
    device_list_with_aliases=$(get_devices_with_aliases)
    device_list_with_aliases=$(sed "s/$ALIASES_DELIMITER*$//g" <<< "$device_list_with_aliases" | column -s $ALIASES_DELIMITER -t)
    echo -e "$device_list_with_aliases"
}

function get_alias_for_device {
    device=$1
    grep "^$device$ALIASES_DELIMITER" $ALIASES_FILE | cut -d$ALIASES_DELIMITER -f2
}

function adb-devices {
    echo -e "List of devices\n"
    get_devices_with_aliases_user_formatted
}

function adb-select {
    if [ -n "$1" ]; then
        echo "ANDROID_SERIAL set to $1 from argument."
        export ANDROID_SERIAL=$1
        export FASTBOOT_SERIAL=$1
        return
    fi

    if [ -n "$ANDROID_SERIAL" ]; then
        echo -e "Currently selected device: \033[0;32m$(adb-which)\033[0m"
    else
        echo -e "\033[0;31mNo device currently selected.\033[0m"
    fi

    echo "Select a device:"

    device_list_with_alias=($(get_devices_with_aliases))
    device_list_with_alias=($(sed 's/=*$//g' <<< "$device_list_with_alias" | sed 's/=/ - /g' && printf "\nUnset"))

    select device in $device_list_with_alias; do
        case $device in
        Unset)
            echo "Unsetting device associations for adb and fastboot."
            unset ANDROID_SERIAL
            unset FASTBOOT_SERIAL
            ;;
        *)
            echo "Setting device associations for adb and fastboot to $device."
        device=$(cut -d' ' -f1 <<< $device)

            export ANDROID_SERIAL=$device
            export FASTBOOT_SERIAL=$device
            ;;
    esac
        break
    done
}

function adb-alias {
    ensureAliasFile

    device_list=($(adb devices | grep "device$" | cut -f1))

    device_for_alias=""

    echo "Which device do you want to set an alias for?"
    select device in "${device_list[@]}"
    do
        device_for_alias=$device
        break
    done

    echo "Enter device alias (empty string to clear an existing one): "
    read alias

    if [ -z "$alias" ]; then
        sed -i "/^$device_for_alias$ALIASES_DELIMITER/d" $ALIASES_FILE
    else 
        #delete any existing alias if it exists
        sed -i "/^$device_for_alias$ALIASES_DELIMITER/d" $ALIASES_FILE
        echo $device_for_alias$ALIASES_DELIMITER$alias >> "$ALIASES_FILE"
    fi
}

function adb-which {
    dsn=$ANDROID_SERIAL
    deviceAlias=$(get_alias_for_device $ANDROID_SERIAL)

    answer=$dsn

    if [ ! -z "$deviceAlias" ]; then
        answer="$answer - $deviceAlias"
    fi

    echo $answer
}

function adb-screenshot {
    adb exec-out screencap -p > "screenshot-$(date +%d.%m.%y-%H:%M:%S).png"
}

function adb-focused-window {
    adb shell dumpsys window | grep -i mFocusedApp | sed 's/.*{[^ ]* [^ ]* \([^}]*\)}.*$/\1/'
}
