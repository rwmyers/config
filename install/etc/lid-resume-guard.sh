#!/bin/zsh
#
# Record the moment the machine comes back from suspend, so the lid handler
# (bin/hypr-monitor-mode) can tell a real lid close from the spurious one the
# hall sensor emits while a resume is still settling.
#
# Acting on the spurious close re-enters s2idle a second or two after waking.
# On hardware with no `deep` sleep state - the Framework 13 AMD among them -
# that has hung the machine outright: the last thing the kernel logs is
# `PM: suspend entry (s2idle)`, without even the filesystems-sync line that
# follows it on a healthy suspend. The panel and the input deck are already
# powered down by then and no wake source is armed, so the only way out is
# disconnecting the battery.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

# Machines that can reach a real sleep state recover from a double-suspend on
# their own, so leave them alone rather than adding latency to their lid.
[ -e /sys/power/mem_sleep ] || exit 0
grep -q '\[s2idle\]' /sys/power/mem_sleep || exit 0

hook=/etc/systemd/system-sleep/50-dotfiles-resume-stamp

staged=$(mktemp)
cat > $staged <<'EOF'
#!/bin/sh
# Managed by dotfiles (install/etc/lid-resume-guard.sh).
#
# Stamp the resume time for bin/hypr-monitor-mode's lid debounce. systemd-sleep
# runs post hooks before it thaws user.slice, so the stamp is always on disk
# before the compositor can process the lid event that woke us.
case "$1/$2" in
    post/*) date +%s > /run/dotfiles-last-resume 2>/dev/null || true ;;
esac
exit 0
EOF

if ! cmp -s $staged $hook
then
    print_note " -- Installing resume stamp hook for the lid debounce"
    sudo install -Dm755 $staged $hook
fi

rm -f $staged
