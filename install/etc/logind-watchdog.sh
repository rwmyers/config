#!/bin/zsh
#
# Raise the systemd watchdog on the daemons that s2idle gets killed. Hardware
# with no `deep` sleep state - the Framework 13 AMD among them - keeps
# advancing CLOCK_MONOTONIC through its s2idle wake windows while userspace
# stays frozen, so a service that cannot ping its watchdog looks hung the
# instant the machine resumes and systemd SIGABRTs it. logind restarting is
# the damaging one: GDM loses track of the session and throws a fresh greeter
# over the still-running compositor, which reads as "the display never came
# back on".
#
# Roughly 38s of monotonic time accrues per hour suspended, so the stock 3min
# limit trips after about five hours - an overnight suspend always, a lunch
# break never. 30min covers ~2 days while still recovering a daemon that has
# genuinely wedged.
source $HOME/src/config/install/common.sh

[[ "$OSTYPE" == "linux-gnu"* ]] || exit 0

# Only machines that can't reach a real sleep state have the problem, so leave
# the stock watchdog alone everywhere else.
[ -e /sys/power/mem_sleep ] || exit 0
grep -q '\[s2idle\]' /sys/power/mem_sleep || exit 0

changed=0
dropin=$(mktemp)
cat > $dropin <<'EOF'
# Managed by dotfiles (install/etc/logind-watchdog.sh).
[Service]
WatchdogSec=30min
EOF

for unit in systemd-logind bolt
do
    # bolt only ships on Thunderbolt machines; don't leave a drop-in for a
    # unit that doesn't exist.
    systemctl cat $unit.service > /dev/null 2>&1 || continue

    conf=/etc/systemd/system/$unit.service.d/99-dotfiles-watchdog.conf
    if ! cmp -s $dropin $conf
    then
        print_note " -- Raising $unit watchdog past the s2idle limit"
        sudo install -Dm644 $dropin $conf
        changed=1
    fi
done

rm -f $dropin

# The running daemons pick the new limit up on their next watchdog ping, so
# there's nothing to restart - which is just as well, since restarting logind
# is the exact event this is here to prevent.
if [ $changed -eq 1 ]
then
    sudo systemctl daemon-reload
fi
