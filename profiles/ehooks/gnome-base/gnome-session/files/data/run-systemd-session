#!/bin/sh
set -e

# some old Qt programs still check this long-deprecated env var
dbus-update-activation-environment --systemd GNOME_DESKTOP_SESSION_ID=this-is-deprecated

# stop any lingering active units from a previous session
systemctl --user stop graphical-session.target graphical-session-pre.target

# robustness: if the previous graphical session left some failed units,
# reset them so that they don't break this startup
for unit in $(systemctl --user --no-legend --state=failed list-units | cut -f1 -d' '); do
    if [ "$(systemctl --user show -p PartOf --value $unit)" = "graphical-session.target" ]; then
        systemctl --user reset-failed $unit
    fi
done

# FIXME: synthesize After=graphical-session-pre.target dependencies until this
# can be done declaratively (https://github.com/systemd/systemd/issues/3750)
# This could be a generator, but we don't want to penalize non-graphical logins
# with this.
systemctl --user list-unit-files --no-legend | while read unit status _; do
    [ "${unit%.service}" != "$unit" ] || continue
    [ "$status" != "$disabled" ] || continue
    if [ "$(systemctl --user show -p PartOf --value $unit)" = "graphical-session.target" ]; then
        mkdir -p "$XDG_RUNTIME_DIR/systemd/user/${unit}.d"
        printf '[Unit]\nAfter=graphical-session-pre.target\n' > "$XDG_RUNTIME_DIR/systemd/user/${unit}.d/graphical-session-pre.conf"
    fi
done
systemctl --user daemon-reload

systemctl --user start --wait "$1"

dbus-update-activation-environment --systemd GNOME_DESKTOP_SESSION_ID=

# Delay killing the X server until all graphical units stopped
systemctl --user stop graphical-session-pre.target
