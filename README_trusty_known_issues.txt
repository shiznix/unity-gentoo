- Redhat bug #806491
  * systemd-logind not tracking startx sessions leading to user not having system suspend and drive mounting permissions
  * workaround:
    -> XSESSION=unity startx -- vt$(tty | sed 's:.*[a-z]::g')

- Ubuntu for Trusty currently has left-click window spread on a side launcher bar icon that has two or more windows open,
    either currently broken or disabled by design (refer launchpad bugs #1104632 and #1255711)

- Launchpad bug #1251915
  * KDE applications do not appear as 'Recently used' in either the 'Home' or 'Applications' Dash lenses
