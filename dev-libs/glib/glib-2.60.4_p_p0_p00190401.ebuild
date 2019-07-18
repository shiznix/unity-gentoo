# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

URELEASE="disco-updates"
#TODO most of those classes are not used
inherit meson bash-completion-r1 epunt-cxx flag-o-matic gnome2 libtool linux-info \
	multilib multilib-minimal pax-utils python-single-r1 toolchain-funcs ubuntu-versionator versionator virtualx

MY_P="${PN}2.0_${PV}"
MY_PV="${PV}"
#UVER="-${PVR_PL_MINOR}"
#S="${WORKDIR}/${PN}-${PV}"

# Until bug #537330 glib is a reverse dependency of pkgconfig and, then
# adding new dependencies end up making stage3 to grow. Every addition needs
# then to be think very closely.

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="https://www.gtk.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	https://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz" # pkg.m4 for eautoreconf

LICENSE="LGPL-2.1+"
SLOT="2/$(get_version_component_range 2-3)"
IUSE="dbus debug fam gtk-doc kernel_linux +mime selinux static-libs systemtap test xattr"

#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

# Added util-linux multilib dependency to have libmount support (which
# is always turned on on linux systems, unless explicitly disabled, but
# this ebuild does not do that anyway) (bug #599586)

RDEPEND="
	!<dev-util/gdbus-codegen-${PV}
	>=dev-libs/libpcre-8.31:3[${MULTILIB_USEDEP},static-libs?]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	kernel_linux? ( >=sys-apps/util-linux-2.23[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r5[${MULTILIB_USEDEP}] )
	xattr? ( >=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] )
	fam? ( >=virtual/fam-0-r1[${MULTILIB_USEDEP}] )
	>=dev-util/gdbus-codegen-${PV}
	virtual/libelf:0=
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	>=dev-libs/libxslt-1.0
	>=sys-devel/gettext-0.11
	gtk-doc? ( >=dev-util/gtk-doc-1.20 )
	systemtap? ( >=dev-util/systemtap-1.3 )
	${PYTHON_DEPS}
	test? (
		sys-devel/gdb
		>=dev-util/gdbus-codegen-${PV}
		>=sys-apps/dbus-1.2.14 )
"

# Migration of glib-genmarshal, glib-mkenums and gtester-report to a separate
# python depending package, which can be buildtime depended in packages that
# need these tools, without pulling in python at runtime.
RDEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/glib-utils-${PV}"
PDEPEND="
	dbus? ( gnome-base/dconf )
	mime? ( x11-misc/shared-mime-info )
"
# shared-mime-info needed for gio/xdgmime, bug #409481
# dconf is needed to be able to save settings, bug #498436

pkg_setup() {
	ubuntu-versionator_pkg_setup
	if use kernel_linux ; then
		CONFIG_CHECK="~INOTIFY_USER"
		if use test ; then
			CONFIG_CHECK="~IPV6"
			WARNING_IPV6="Your kernel needs IPV6 support for running some tests, skipping them."
		fi
		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}

meson_use_enable() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

multilib_src_configure() {
	if ! multilib_is_native_abi; then
		sed -i "/subdir('tests')/d" "${S}"/gio/meson.build || die "sed failed"
	fi

	#TODO: there are some problems with cheese support
	local emesonargs=(
		-Dman=true
		-Dinternal_pcre=false
		$(meson_use xattr)
		$(meson_use fam)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use kernel_linux libmount)
		$(meson_use_enable selinux selinux)
		$(meson_use systemtap dtrace)
		$(meson_use systemtap)
	)

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	if multilib_is_native_abi; then
		python_fix_shebang gobject/glib-genmarshal
		python_fix_shebang gobject/glib-mkenums
		python_fix_shebang glib/gtester-report
	fi
	meson_src_install
	# These are installed by dev-util/glib-utils
	# TODO: With patching we might be able to get rid of the python-any deps and removals, and test depend on glib-utils instead; revisit with meson
	rm "${ED}usr/bin/glib-genmarshal" || die
	rm "${ED}usr/share/man/man1/glib-genmarshal.1" || die
	rm "${ED}usr/bin/glib-mkenums" || die
	rm "${ED}usr/share/man/man1/glib-mkenums.1" || die
	rm "${ED}usr/bin/gtester-report" || die
	rm "${ED}usr/share/man/man1/gtester-report.1" || die
}

pkg_postinst() {
	# force (re)generation of gschemas.compiled
	GNOME2_ECLASS_GLIB_SCHEMAS="force"

	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	if ! tc-is-cross-compiler ; then
		multilib_foreach_abi multilib_pkg_postinst
	else
		ewarn "Updating of GIO modules cache skipped due to cross-compilation."
		ewarn "You might want to run gio-querymodules manually on the target for"
		ewarn "your final image for performance reasons and re-run it when packages"
		ewarn "installing GIO modules get upgraded or added to the image."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gio/modules/giomodule.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
		rm -f "${EROOT}"usr/share/glib-2.0/schemas/gschemas.compiled
	fi
}
