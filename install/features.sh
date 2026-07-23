#!/bin/zsh

# Optional-install toggles. When ~/.config/dotfiles.conf is missing or a known
# feature isn't recorded yet, prompt via gum and write the choices. nix/home.nix
# reads this file to decide which optional packages to install / remove.
source $HOME/src/config/install/common.sh

CONF="$HOME/.config/dotfiles.conf"

# Available optional features (each is also gated in nix/home.nix).
FEATURES=(spotify discord steam)

# --force always prompts (used by `dot config`); otherwise only prompt when the
# conf is missing or a feature isn't recorded yet.
force=0
[ "$1" = "--force" ] && force=1

# The prompt needs gum; skip silently if it isn't on PATH yet (fresh machine,
# before Nix installs gum). A later run will prompt once gum exists.
if ! type gum > /dev/null 2>&1
then
    exit 0
fi

# Load current values.
typeset -A current
if [ -f "$CONF" ]
then
    while IFS='=' read -r k v
    do
        [ -n "$k" ] && current[$k]="$v"
    done < "$CONF"
fi

# Prompt only if the file is missing or a known feature isn't recorded.
need_prompt=$force
[ -f "$CONF" ] || need_prompt=1
for f in $FEATURES
do
    [ -n "${current[$f]}" ] || need_prompt=1
done
[ $need_prompt -eq 0 ] && exit 0

print_note "Choose optional installs (space toggles, enter confirms)"

preselected=()
for f in $FEATURES
do
    [ "${current[$f]}" = "true" ] && preselected+="$f"
done

gum_args=(choose --no-limit --header="Optional installs")
[ ${#preselected} -gt 0 ] && gum_args+=(--selected="${(j:,:)preselected}")

chosen=$(printf '%s\n' $FEATURES | gum "${gum_args[@]}") \
    || { print_note " -- Cancelled; leaving $CONF unchanged"; exit 0; }

# Write the conf: chosen -> true, others -> false.
: > "$CONF"
for f in $FEATURES
do
    if echo "$chosen" | grep -qx -- "$f"
    then
        echo "$f=true" >> "$CONF"
    else
        echo "$f=false" >> "$CONF"
    fi
done
print_note " -- Wrote $CONF"
