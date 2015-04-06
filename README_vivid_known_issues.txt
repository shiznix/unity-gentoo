* OpenGL applications segfault and cause Xsession to be killed in a Mir session as follows:
	* Mir enabled lightdm is unable to start a Gnome session
		- It does successfully launch Gnome session if Seat type is set to 'xlocal' instead of 'unity' in /etc/lightdm/lightdm.conf.d/10-unity-system-compositor.conf

	* Chromium segfaults in a Mir session when it's hardware acceleration is enabled
		 [ERROR:sync_control_vsync_provider.cc] glXGetSyncValuesOML should not return TRUE with a media stream counter of 0.

	* 'glxgears' kills Mir session and so crashes X

* Some icons may be broken or missing in gtk+-3.12 applications when using new glib-2.44 and pygobject-3.14 and execute with the following warnings:
	GLib-GObject-WARNING **: The property GtkSettings:gtk-button-images is deprecated and shouldn't be used anymore. It will be removed in a future version.
	GLib-GObject-WARNING **: The property GtkSettings:gtk-menu-images is deprecated and shouldn't be used anymore. It will be removed in a future version.
	GLib-GObject-WARNING **: The property GtkCellRendererPixbuf:stock-id is deprecated and shouldn't be used anymore. It will be removed in a future version.
	GLib-GObject-WARNING **: The property GtkSettings:gtk-toolbar-style is deprecated and shouldn't be used anymore. It will be removed in a future version.
