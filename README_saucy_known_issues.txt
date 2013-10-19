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

- Launchpad bug #1210357
	unity-lenses/unity-lens-music fails to compile with the following error due to lagging behind dev-libs/libunity updates...
		simple-scope.vala:134.33-134.59: error: The name `FLOW' does not exist in the context of `Unity.CategoryRenderer'
			Unity.CategoryRenderer.FLOW);

- Launchpad bug #1104632
  * Application spread view (Compiz scale) doesn't work properly after using "Show Desktop"

- launchpad bug #1203888
  * Glipper and blueman (and others?) menus are broken by libappindicator
