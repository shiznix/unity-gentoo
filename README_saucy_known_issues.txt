- compile 'app-accessibility/sphinxbase' with WANT_AUTOMAKE="0.12" (see bugs.gentoo.org #469504)
  e.g. 'WANT_AUTOMAKE="0.12" emerge -q1 app-accessibility/sphinxbase'

- launchpad bug #86184
 * not possible to change mouse cursor theme
 (cursor theme packages are missing in overlay too)

- launchpad bug #1059374 
 * Using Adwaita, many widgets are drawn with a solid black background
 * work around:
   -> run 'gsettings set com.canonical.desktop.interface scrollbar-mode normal'
   -> OR use 'unity-tweak-tool' and set scrolling to 'backward compatibility'

- launchpad bug #1210357
	unity-lenses/unity-lens-music fails to compile with the following error due to lagging behind dev-libs/libunity updates...
		simple-scope.vala:134.33-134.59: error: The name `FLOW' does not exist in the context of `Unity.CategoryRenderer'
			Unity.CategoryRenderer.FLOW);

- Application spread view (Compiz scale) doesn't work properly after using "Show Desktop" (see launchpad.net #1104632)

- Nautilus may crash when changing desktop background with the following error... (see launchpad.net #1198658)
	(nautilus:4182): Gdk-ERROR **: The program 'nautilus' received an X Window System error.
	This probably reflects a bug in the program.
	The error was 'BadDrawable (invalid Pixmap or Window parameter)'.
	  (Details: serial 14085 error_code 9 request_code 53 minor_code 0)
