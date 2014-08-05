- Redhat bug #806491
  * systemd-logind not tracking startx sessions leading to user not having system suspend and drive mounting permissions
  * workaround:
    -> XSESSION=unity startx -- vt$(tty | sed 's:.*[a-z]::g')

- Some applications duplicate menu entries in the menu bar due to displaying the application menu and appmenu at the same time
  * Known affected applications so far are gnome-terminal and eog
  * Ubuntu currently workaround this by patching these applications to disable the application menu
  * This should auto resolve when packages' upstream port their menus to use GMenuModel (https://developer.gnome.org/gio/stable/GMenuModel.html)

- Launchpad bug #1320763
  * Due to new Unity integrated window decoration code (no longer uses compiz), some Gnome applications appear to have no window decoration and their window cannot be resized
  * These are >=gtk+-3.10 applications that implement the new GtkHeaderBar widget (http://blogs.gnome.org/mclasen/2014/01/13/client-side-decorations-continued/)
  * In later versions of gtk+ this can be overridden via a gsetting (http://worldofgnome.org/how-to-disable-gtk-header-dialogs-from-gnome-3-12/)
	but is not available in Trusty yet
  * Window control buttons can no longer currently be configured to be on the right using dconf/unity-tweak-tool
