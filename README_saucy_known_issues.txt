- lauchpad bug #1189616
  https://bugs.launchpad.net/ubuntu/+source/libunity/+bug/1189616
 * prevends us to build '>=libunity-7.0' to build with vala-0.20
 * workaround -> unblock <=vala-0.20 in 'dev-libs/gobject-introspection-1.37.1'

- unity-greeter-13.10.1
 * not able to compile with vala-0.20

- non-existing 'saucy' packages
  * gnome-base/gnome-control-center-3.8.x
  * gnome-base/gnome-settings-daemon-3.8.x

- compile 'app-accessibility/sphinxbase' with WANT_AUTOMAKE="0.12"
  e.g. 'WANT_AUTOMAKE="0.12" emerge -q1 app-accessibility/sphinxbase'

- >=net-libs/libsoup-2.42 blocks net-libs/libsoup-gnome
	- unity-indicators/indicator-datetime requires libedataserverui-3.0.pc from evolution-data-server-3.6
		- mail-client/evolution-3.6 requires net-libs/libsoup-gnome

- >=gnome-base/gnome-control-center-3.8
	- gnome-control-center-{signon,unity} require libgnome-control-center.pc which doesn't exist in gnome-control-center-3.8

- >=gnome-extra/nautilus-sendto-3.8
	- Empathy requires nautilus-sendto.pc which doesn't exist in nautilus-sendto-3.8

- launchpad bug #86184
 * not possible to change mouse cursor theme
 (cursor theme packages are missing in overlay too)
