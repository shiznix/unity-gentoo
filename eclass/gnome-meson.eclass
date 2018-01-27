# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome-meson.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @BLURB: Provides phases for Gnome/Gtk+ based packages that use meson.
# @DESCRIPTION:
# Exports portage base functions used by ebuilds written for packages using the
# GNOME framework and meson. For additional functions, see gnome2-utils.eclass.

inherit eutils gnome.org gnome2-utils meson xdg

case "${EAPI:-0}" in
	6)
		EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: GNOME-MESON_ECLASS_GIO_MODULES
# @INTERNAL
# @DESCRIPTION:
# Array containing glib GIO modules

# @FUNCTION: gnome-meson_src_prepare
# @DESCRIPTION:
# Prepare environment for build, fix build of scrollkeeper documentation,
# run elibtoolize.
gnome-meson_src_prepare() {
	# FIXME add gtk-doc stuff if needed
	xdg_src_prepare

	# Prevent assorted access violations and test failures
	gnome2_environment_reset
}

# @FUNCTION: gnome-meson_src_configure
# @DESCRIPTION:
# Gnome specific configure handling
gnome-meson_src_configure() {
	# Avoid sandbox violations caused by gnome-vfs (bug #128289 and #345659)
	addpredict "$(unset	 HOME; echo ~)/.gnome2"
	
	#FIXME are these valid/needed
	#	"-Dgtk-doc=no"
	#	"-Dmaintainer-mode=no"
	#	"-Dschemas-install=no"
	#	"-Dupdate-mimedb=no"
	#	"-Dcompile-warnings=minimum"
	local emesonargs=(
		"$@"
	)
	
	meson_src_configure
}

# @FUNCTION: gnome-meson_src_compile
# @DESCRIPTION:
# Only default src_compile for now
gnome-meson_src_compile() {
	meson_src_compile
}

# @FUNCTION: gnome-meson_src_install
# @DESCRIPTION:
# Gnome specific install. Handles typical GConf and scrollkeeper setup
# in packages and removal of .la files if requested
gnome-meson_src_install() {
	# install docs
	default
	
	# files that are really common in gnome packages (bug #573390)
	local d
	for d in HACKING MAINTAINERS; do
		[[ -s "${d}" ]] && dodoc "${d}"
	done
	
	# Make sure this one doesn't get in the portage db
	rm -fr "${ED}/usr/share/applications/mimeinfo.cache"

	# Delete all .la files
	case "${GNOME2_LA_PUNT}" in
		yes)    prune_libtool_files --modules;;
		no)     ;;
		*)      prune_libtool_files;;
	esac
	
	meson_src_install
}

# @FUNCTION: gnome-meson_pkg_preinst
# @DESCRIPTION:
# Finds Icons, GConf and GSettings schemas for later handling in pkg_postinst
gnome-meson_pkg_preinst() {
	xdg_pkg_preinst
	gnome2_gconf_savelist
	gnome2_icon_savelist
	gnome2_schemas_savelist
	gnome2_scrollkeeper_savelist
	gnome2_gdk_pixbuf_savelist

	local f

	GNOME2_ECLASS_GIO_MODULES=()
	while IFS= read -r -d '' f; do
		GNOME2_ECLASS_GIO_MODULES+=( ${f} )
	done < <(cd "${D}" && find usr/$(get_libdir)/gio/modules -type f -print0 2>/dev/null)

	export GNOME2_ECLASS_GIO_MODULES
}

# @FUNCTION: gnome-meson_pkg_postinst
# @DESCRIPTION:
# Handle scrollkeeper, GConf, GSettings, Icons, desktop and mime
# database updates.
gnome-meson_pkg_postinst() {
	xdg_pkg_postinst
	gnome2_gconf_install
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
	if [[ -n ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		gnome2_schemas_update
	fi
	gnome2_scrollkeeper_update
	gnome2_gdk_pixbuf_update

	if [[ ${#GNOME2_ECLASS_GIO_MODULES[@]} -gt 0 ]]; then
		gnome2_giomodule_cache_update
	fi
}

# # FIXME Handle GConf schemas removal
#gnome2_pkg_prerm() {
#	gnome2_gconf_uninstall
#}

# @FUNCTION: gnome-meson_pkg_postrm
# @DESCRIPTION:
# GSettings, Icons, desktop and mime database updates.
gnome-meson_pkg_postrm() {
	xdg_pkg_postrm
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
	if [[ -n ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		gnome2_schemas_update
	fi

	if [[ ${#GNOME2_ECLASS_GIO_MODULES[@]} -gt 0 ]]; then
		gnome2_giomodule_cache_update
	fi
}

# @FUNTION: gnome-meson_use
# @DESCRIPTION:
# Make setting arguments easier taken from https://github.com/Heather/gentoo-gnome/blob/4f61803890da76026f4fed772c34c4394e1d2959/gnome-base/nautilus/nautilus-3.27.2.ebuild#L83
gnome-meson_use() {
	echo "-Denable-${2:-${1}}=$(usex ${1} 'true' 'false')"
}
