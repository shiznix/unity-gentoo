- Multilib issues arising from mir-base/mir support
	* mir-base/mir needs mir patched media-libs/mesa
		Because media-libs/mesa is multilib, mir-base/mir also needs to be multilib to build for all multilib ABIs
	* x11-libs/gtk+[mir] needs x11-libs/content-hub
		Because x11-libs/gtk+ is multlib, x11-libs/content-hub also needs to be multilib to build for all multilib ABIs
		x11-libs/content-hub multilib then opens up many more multilib dependencies that need to be created:
		 sys-apps/ubuntu-app-launch
		  \_dev-libs/gobject-introspection
		    \_dev-libs/json-glib
		    \_gnome-extra/zeitgeist
		      \_dev-libs/dee
		....and many more, it is for this reason mir-base/mir and unity-base/unity8 are currently broken in Zesty
	* Some questions in resolving:
		- Can mir-base/mir be installed without triggering multilib dependencies from media-libs/mesa and x11-libs/gtk+?
		- Is mir-base/mir or it's unity-base/unity8 dependency ripe for dropping anyway as unmaintained by upstream?

- dev-qt/qtwayland:5 fails to build if dev-libs/libhybris is installed (required by oxide-qt,mir and unity8)
	hardwareintegration/compositor/libhybris-egl-server/libhybriseglserverbufferintegration.cpp
		error: ‘class QWaylandCompositor’ has no member named ‘waylandDisplay’

- Unity via unity-base/unity-settings-daemon strips the 'grp' option for XKB keyboard layouts (see LP# 1315867 and overlay issue #133)
	* This can lead to problems trying to use group keyboard layout(s)/variant(s) customised key+combo switching
		Based on bug, requires upstream to patch support into unity-settings-daemon,unity,compiz and unity-control-center

- Lockscreen fails to function when onscreen reader (orca) is activated Super+Alt+S (broken since Trusty, see LP# 1310404)

- Webapps plugin is broken for chromium since Vivid release, browser will not prompt for webapp installation on sites such as Gmail, Youtube or Facebook
	* Use Firefox if you want webapps to work
- Webapps plugins for >=www-client/firefox-43 stops working as Firefox now require addon signing and so disable the webapps plugins as their signature cannot be verified
	* In Firefox's addressbar type 'about:config' and set 'xpinstall.signatures.required' from 'true' to 'false'. Plugins should now be enabled in 'Tools > Addons' after restarting Firefox

- Window control buttons can no longer currently be configured to be on the right using dconf/unity-tweak-tool
	* Possibly due to changes in >=gtk-3.10 GtkHeaderBar client side decorations and ubuntu-themes

- Xrandr does not work in Mir (unable to get a list of valid screen resolutions other than the one being used, screen rotate does nothing)

- Ubuntu's patched Gnome packages can become outdated with Gnome versions available in portage tree
  * The striving goal is to have Gnome from the portage tree and Unity desktop from the overlay able to be installed and function together side-by-side
  * Ubuntu heavily patch and fork a number of Gnome packages that are crucial to Unity's and Gnome's desktop function
  * Ubuntu's development of these packages lags greatly behind the changes Gnome upstream make, and so also lags behind what
        Gnome versions become available and are subsequently dropped in the portage tree
  * The most important packages affected are as follows:
        gnome-base/gnome-desktop
        gnome-base/gnome-session
        gnome-base/gnome-settings-daemon
        unity-base/unity-settings-daemon (Ubuntu fork of gnome-base/gnome-settings-daemon)
        unity-base/unity-control-center (Ubuntu fork of gnome-base/gnome-control-center)
  * The flow-on effect of this development lag and subsequent version mismatch is that some updated features in Gnome can break in Unity
