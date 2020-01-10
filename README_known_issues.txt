- Unity via unity-base/unity-settings-daemon strips the 'grp' option for XKB keyboard layouts (see LP# 1315867 and overlay issue #133)
	* This can lead to problems trying to use group keyboard layout(s)/variant(s) customised key+combo switching
		Based on bug, requires upstream to patch support into unity-settings-daemon,unity,compiz and unity-control-center

- Lockscreen fails to function when onscreen reader (orca) is activated Super+Alt+S (broken since Trusty, see LP# 1310404)

- Window control buttons can no longer currently be configured to be on the right using dconf/unity-tweak-tool
	* Possibly due to changes in >=gtk-3.10 GtkHeaderBar client side decorations and ubuntu-themes

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
