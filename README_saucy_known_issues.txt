- Redhat bug #806491
  * systemd-logind not tracking startx sessions leading to user not having system suspend and drive mounting permissions
  * workaround:
    -> XSESSION=unity startx -- vt$(tty | sed 's:.*[a-z]::g')

- Gentoo bug #469504
  compile 'app-accessibility/sphinxbase' with WANT_AUTOMAKE="0.12"
  e.g. 'WANT_AUTOMAKE="0.12" emerge -q1 app-accessibility/sphinxbase'

- Launchpad bug #86184
 * not possible to change mouse cursor theme
 (cursor theme packages are missing in overlay too)

- Launchpad bug #1059374 
 * Using Adwaita, many widgets are drawn with a solid black background
 * work around:
   -> run 'gsettings set com.canonical.desktop.interface scrollbar-mode normal'
   -> OR use 'unity-tweak-tool' and set scrolling to 'backward compatibility'

- Launchpad bug #1104632
  * Application spread view (Compiz scale) doesn't work properly after using "Show Desktop"

- Launchpad bug #1255711
  * Turning Compiz Window Spread feature on/off and then activating window spread (Super+w) can cause Compiz to segfault

- Launchpad bug #1251915
  * KDE applications do not appear as 'Recently used' in either the 'Home' or 'Applications' Dash lenses

- Some Qt applications do not appear in the unity-panel-service systray (eg. ktorrent, quassel)
    However some QT applications (eg. skype, qbittorrent, vlc) are not affected for some reason
	sni-qt is a package that turns QT systray icons into appindicators on-the-fly,
	but requires a patched dev-qt/qtgui to work
    The same applications that do not appear in the unity-panel-service systray, also do not work with
	sni-qt in Ubuntu
