- Lockscreen fails to function when onscreen reader (orca) is activated Super+Alt+S (broken since Trusty, see LP# 1310404)

- OpenGL applications segfault and cause Xsession to be killed in a Mir session as follows:
	* Mir enabled lightdm is unable to start a Gnome session
		- It does successfully launch Gnome session if Seat type is set to 'xlocal' instead of 'unity' in /etc/lightdm/lightdm.conf.d/10-unity-system-compositor.conf

	* Chromium segfaults in a Mir session when it's hardware acceleration is enabled (see LP# 1420959)
		 [ERROR:sync_control_vsync_provider.cc] glXGetSyncValuesOML should not return TRUE with a media stream counter of 0.

	* 'glxgears' kills Mir session and so crashes X

- Webapps plugin is broken for chromium so it will not prompt for webapp installation on sites such as Gmail, Youtube or Facebook
	* Use Firefox if you want webapps to work

- Window control buttons can no longer currently be configured to be on the right using dconf/unity-tweak-tool
	* Possibly due to changes in >=gtk-3.10 GtkHeaderBar client side decorations and ubuntu-themes

- Xrandr does not work in Mir (unable to get a list of valid screen resolutions other than the one being used, screen rotate does nothing)

- Ubuntu's patched Gnome packages become outdated with Gnome versions available in portage tree
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
