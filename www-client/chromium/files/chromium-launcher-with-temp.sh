#!/bin/bash

# Allow the user to override command-line flags, bug #357629.
# This is based on Debian's chromium-browser package, and is intended
# to be consistent with Debian.
for f in /etc/chromium/*; do
    [[ -f ${f} ]] && source "${f}"
done

# Prefer user defined CHROMIUM_USER_FLAGS (from env) over system
# default CHROMIUM_FLAGS (from /etc/chromium/default).
CHROMIUM_FLAGS=${CHROMIUM_USER_FLAGS:-"$CHROMIUM_FLAGS"}

# Let the wrapped binary know that it has been run through the wrapper
export CHROME_WRAPPER=$(readlink -f "$0")

PROGDIR=${CHROME_WRAPPER%/*}

case ":$PATH:" in
  *:$PROGDIR:*)
    # $PATH already contains $PROGDIR
    ;;
  *)
    # Append $PROGDIR to $PATH
    export PATH="$PATH:$PROGDIR"
    ;;
esac

# Set the .desktop file name
export CHROME_DESKTOP="chromium-browser-chromium.desktop"

CHROMIUM_FLAGS="--extra-plugin-dir=/usr/lib/nsbrowser/plugins ${CHROMIUM_FLAGS}"

if [ "$1" = "--temp-profile" ]; then
    TEMP_PROFILE=`mktemp -d`

    # Suppress first run bubble
    touch "${TEMP_PROFILE}/First Run"

    # Suppress default browser check
    mkdir ${TEMP_PROFILE}/Default
    echo '{"browser":{"check_default_browser":false}}' > ${TEMP_PROFILE}/Default/Preferences

    CHROMIUM_FLAGS="${CHROMIUM_FLAGS} --start-maximized"
    # Disable running background apps when Chromium is closed
    CHROMIUM_FLAGS="${CHROMIUM_FLAGS} --disable-background-mode"
    CHROMIUM_FLAGS="${CHROMIUM_FLAGS} --user-data-dir=${TEMP_PROFILE}"

    # We can't exec here as we need to clean-up the temporary profile
    "${PROGDIR}/chrome" ${CHROMIUM_FLAGS} "$@"
    rm -rf ${TEMP_PROFILE}
else
    if [[ ${EUID} == 0 && -O ${XDG_CONFIG_HOME:-${HOME}} ]]; then
        # Running as root with HOME owned by root.
        # Pass --user-data-dir to work around upstream failsafe.
        CHROMIUM_FLAGS="--user-data-dir=${XDG_CONFIG_HOME:-${HOME}/.config}/chromium
            ${CHROMIUM_FLAGS}"
    fi

    exec -a "chromium-browser" "$PROGDIR/chrome" ${CHROMIUM_FLAGS} "$@"
fi
