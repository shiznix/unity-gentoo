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

- Launchpad bug #1295851
  * Xmir session keyboard input degrades over time from being slow to one character behind
  * workaround:
    -> None at this time, don't use Xmir
