- Redhat bug #806491
  * systemd-logind not tracking startx sessions leading to user not having system suspend and drive mounting permissions
  * workaround:
    -> XSESSION=unity startx -- vt$(tty | sed 's:.*[a-z]::g')

- Ubuntu for Trusty currently has left-click window spread on a side launcher bar icon that has two or more windows open,
    either currently broken or disabled by design (refer launchpad bugs #1104632 and #1255711)

- Launchpad bug #1251915
  * KDE applications do not appear as 'Recently used' in either the 'Home' or 'Applications' Dash lenses

- Launchpad bug #1255558
  * Can't type password sometimes in lightdm/unity-greeter login screen
  * workaround:
    -> Right click in password entry box to give it focus

- x11-wm/mutter and gnome-base/gnome-shell 3.8 are not compatible with dev-libs/gobject-introspection 1.39
  * >=dev-libs/gobject-introspection-1.39 is masked for now

- media-libs/mesa-10* is known not to work yet on Gentoo
  * media-libs/mesa-10* is masked for now
