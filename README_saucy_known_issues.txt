- compile 'app-accessibility/sphinxbase' with WANT_AUTOMAKE="0.12" (see bugs.gentoo.org #469504)
  e.g. 'WANT_AUTOMAKE="0.12" emerge -q1 app-accessibility/sphinxbase'

- launchpad bug #86184
 * not possible to change mouse cursor theme
 (cursor theme packages are missing in overlay too)

- Time & Date settings in System Settings segfaults gnome-control-center
	(will maybe self fix once Saucy has a proper gnome-3.8 patchset for gnome-control-center)

- launchpad bug #1210357
	unity-lenses/unity-lens-music fails to compile with the following error due to lagging behind dev-libs/libunity updates...
		simple-scope.vala:134.33-134.59: error: The name `FLOW' does not exist in the context of `Unity.CategoryRenderer'
			Unity.CategoryRenderer.FLOW);

- Application spread view (Compiz scale) doesn't work properly after using "Show Desktop" (see launchpad.net #1104632)
