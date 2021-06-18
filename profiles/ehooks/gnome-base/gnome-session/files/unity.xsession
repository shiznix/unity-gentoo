#!/bin/sh
# Unity Xsession starter, based on Xsession shipped by x11-apps/xinit-1.0.5-r1

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
userxkbmap=$HOME/.Xkbmap

sysresources=/etc/X11/Xresources
sysmodmap=/etc/X11/Xmodmap
sysxkbmap=/etc/X11/Xkbmap

rh6sysresources=/etc/X11/xinit/Xresources
rh6sysmodmap=/etc/X11/xinit/Xmodmap


# merge in defaults
if [ -f "$rh6sysresources" ]; then
    xrdb -merge "$rh6sysresources"
fi

if [ -f "$sysresources" ]; then
    xrdb -merge "$sysresources"
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# merge in keymaps
if [ -f "$sysxkbmap" ]; then
    setxkbmap `cat "$sysxkbmap"`
    XKB_IN_USE=yes
fi

if [ -f "$userxkbmap" ]; then
    setxkbmap `cat "$userxkbmap"`
    XKB_IN_USE=yes
fi

#
# Eeek, this seems like too much magic here
#
if [ -z "$XKB_IN_USE" -a ! -L /etc/X11/X ]; then
    if grep '^exec.*/Xsun' /etc/X11/X > /dev/null 2>&1 && [ -f /etc/X11/XF86Config ]; then
       xkbsymbols=`sed -n -e 's/^[     ]*XkbSymbols[   ]*"\(.*\)".*$/\1/p' /etc/X11/XF86Config /etc/X11/xorg.conf`
       if [ -n "$xkbsymbols" ]; then
           setxkbmap -symbols "$xkbsymbols"
           XKB_IN_USE=yes
       fi
    fi
fi

# xkb and xmodmap don't play nice together
if [ -z "$XKB_IN_USE" ]; then
    if [ -f "$rh6sysmodmap" ]; then
       xmodmap "$rh6sysmodmap"
    fi

    if [ -f "$sysmodmap" ]; then
       xmodmap "$sysmodmap"
    fi

    if [ -f "$usermodmap" ]; then
       xmodmap "$usermodmap"
    fi
fi

unset XKB_IN_USE

# run all system xinitrc shell scripts.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for i in /etc/X11/xinit/xinitrc.d/* ; do
        if [ -x "$i" ]; then
	    . "$i"
        fi
    done
fi

# Check we have 'video' group permissions as a minimum #
if [[ -z "`groups | grep video`" ]]; then
        echo -e "\nOOps... this user is not part of the 'video' group"
        echo "Unity will not function correctly until this user has been added to the 'video' group"
        echo -e "Exiting...\n"
        exit 1
else
        if [[ -z "`groups | grep plugdev`" ]]; then
                echo "WARNING: User is not part of the 'plugdev' group"
                echo "Some devices and indicators may fail to function"
        fi
        ## All good, we need not execute anything here as upstart will start the session for us ##
fi
