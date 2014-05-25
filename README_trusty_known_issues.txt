- Redhat bug #806491
  * systemd-logind not tracking startx sessions leading to user not having system suspend and drive mounting permissions
  * workaround:
    -> XSESSION=unity startx -- vt$(tty | sed 's:.*[a-z]::g')

- Launchpad bug #1251915
  * KDE applications do not appear as 'Recently used' in either the 'Home' or 'Applications' Dash lenses

- Launchpad bug #1255558
  * Can't type password sometimes in lightdm/unity-greeter login screen
  * workaround:
    -> Right click in password entry box to give it focus

- Launchpad bug #1295851
  * Xmir session keyboard input degrades over time from being slow to one character behind
  * workaround:
    -> None at this time, don't use Xmir

- Some applications duplicate menu entries in the menu bar due to displaying the application menu and appmenu at the same time
  * Known affected applications so far are gnome-terminal and eog
  * Ubuntu currently workaround this by patching these applications to disable the application menu
  * This should auto resolve when packages' upstream port their menus to use GMenuModel (refer https://developer.gnome.org/gio/stable/GMenuModel.html)
