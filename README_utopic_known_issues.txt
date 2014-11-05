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

- Ubuntu's patched Gnome packages become outdated with Gnome versions available in portage tree
  * The striving goal is to have Gnome from the portage tree and Unity desktop from the overlay able to be installed and function together side-by-side
  * Ubuntu heavily patch and fork a number of Gnome packages that are crucial to Unity's and Gnome's desktop function
  * Ubuntu's development of these packages lags greatly behind the changes Gnome upstream make and so also lags behind what
	Gnome versions become available and are subsequently dropped in the portage tree
  * The most important packages affected are as follows:
	gnome-base/gnome-control-center
	gnome-base/gnome-desktop
	gnome-base/gnome-session
	gnome-base/gnome-settings-daemon
	unity-base/displayconfig (Ubuntu fork of x11-wm/mutter code into a daemon that provides the displayconfig dbus interfaces)
	unity-base/unity-settings-daemon (Ubuntu fork of gnome-base/gnome-settings-daemon)
	unity-base/unity-control-center (Ubuntu fork of gnome-base/gnome-control-center)
  * The flow-on effect of this development lag and subsequent version mismatch is that some updated features in Gnome, break in Unity
	An example of this is sys-power/upower support. Gnome >=3.12 needs upower-0.99 but unity-control-center and unity-settings-daemon are not yet compatible with upower-0.99 (LP# 1330037)
		- This has broken laptop power settings in unity-control-center -
	Another example is Gnome >=3.10 moving DisplayConfig settings (xrandr, color, power) from gnome-desktop into x11-wm/mutter as a dbus interface (LP# 1228765)
		- This has broken multi-monitor display setups and laptop brightness settings, changing screen resolution lacks confirmation dialog -

- Xrandr does not work in Mir (unable to get a list of valid screen resolutions other than the one being used, screen rotate does nothing)
