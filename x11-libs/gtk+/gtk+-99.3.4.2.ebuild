EAPI=4

inherit base eutils flag-o-matic gnome.org gnome2-utils libtool virtualx

# Naming gtk+-3.4.2 to gtk+-99.3.4.2 so as not to break the overlay with x11-libs/gtk+ upgrades in the main tree #
MY_PN="gtk+3.0"
MY_PV="${PV/99./}"
MY_P="${MY_PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${MY_PN}"
UVER="0ubuntu2"
URELEASE="quantal"

DESCRIPTION="Gimp ToolKit patched for the Unity desktop"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-2"
SLOT="3"
IUSE="aqua colord cups debug doc examples +introspection packagekit test vim-syntax wayland X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="X? (
		x11-libs/libXrender
		x11-libs/libX11
		>=x11-libs/libXi-1.3
		x11-libs/libXt
		x11-libs/libXext
		>=x11-libs/libXrandr-1.3
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXcomposite
		x11-libs/libXdamage
		xinerama? ( x11-libs/libXinerama )
	)
	wayland? (
		dev-libs/wayland
		media-libs/mesa[egl,wayland]
		x11-libs/cairo[opengl]
		x11-libs/libxkbcommon
	)
	>=dev-libs/glib-2.32
	>=x11-libs/pango-1.30[introspection?]
	>=dev-libs/atk-2.2[introspection?]
	>=x11-libs/cairo-1.10.0[aqua?,glib,svg,X?]
	>=x11-libs/gdk-pixbuf-2.26:2[introspection?,X?]
	>=x11-libs/gtk+-2.24:2
	media-libs/fontconfig
	x11-misc/shared-mime-info
	colord? ( >=x11-misc/colord-0.1.9 )
	cups? ( >=net-print/cups-1.2 )
	introspection? ( >=dev-libs/gobject-introspection-1.32 )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	X? (
		x11-proto/xextproto
		x11-proto/xproto
		x11-proto/inputproto
		x11-proto/damageproto
		xinerama? ( x11-proto/xineramaproto )
	)
	>=dev-util/gtk-doc-am-1.11
	doc? (
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"

RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gail-1000
	!<x11-libs/vte-0.31.0:2.90
	packagekit? ( app-admin/packagekit-base )
	X? ( !<x11-base/xorg-server-1.11.4 )"

PDEPEND="vim-syntax? ( app-vim/gtk-syntax )"

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
		|| die "Could not strip director ${directory} from build."
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	# https://bugzilla.gnome.org/show_bug.cgi?id=65410
	epatch "${FILESDIR}/${PN}-3.3.18-fallback-theme.patch"

	# Apparently needed for new libxkbcommon headers; bug #408131
	epatch "${FILESDIR}/${PN}-3.3.20-wayland-xkbcommon-headers.patch"

	# Non-working test in gentoo's env
	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"
	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"

	# FIXME: multiple reftests fail when run from portage (but succeed when
	# run from a manual compile in a temp directory)
	sed -e 's:\(SUBDIRS.*\)reftests:\1:' \
		-i tests/Makefile.* || die "sed 3 failed"

	# Test results depend on the list of mounted filesystems!
	rm -v tests/a11y/pickers.{ui,txt} || die "rm failed"

	if ! use test; then
		# don't waste time building tests
		strip_builddir SRC_SUBDIRS tests Makefile.am
	fi

	if ! use examples; then
		# don't waste time building demos
		strip_builddir SRC_SUBDIRS demos Makefile.am
	fi
}

src_configure() {
	local myconf="$(use_enable aqua quartz-backend)
		$(use_enable colord)
		$(use_enable cups cups auto)
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_enable packagekit)
		$(use_enable wayland wayland-backend)
		$(use_enable X x11-backend)
		$(use_enable X xcomposite)
		$(use_enable X xdamage)
		$(use_enable X xfixes)
		$(use_enable X xkb)
		$(use_enable X xrandr)
		$(use_enable xinerama)
		--disable-papi
		--enable-gtk2-dependency"

	# Passing --disable-debug is not recommended for production use
	use debug && myconf="${myconf} --enable-debug=yes"

	# need libdir here to avoid a double slash in a path that libtool doesn't
	# grok so well during install (// between $EPREFIX and usr ...)
	econf --libdir="${EPREFIX}/usr/$(get_libdir)" ${myconf}
}

src_test() {
	# Tests require a new gnome-themes-standard, but adding it to DEPEND
	# would result in circular dependencies.
	# https://bugzilla.gnome.org/show_bug.cgi?id=669562
	if ! has_version '>=x11-themes/gnome-themes-standard-3.3.91'; then
		ewarn "Tests will be skipped beecause >=gnome-themes-standard-3.3.90"
		ewarn "is not installed. Please re-run tests after installing the"
		ewarn "required version of gnome-themes-standard."
		return 0
	fi
	unset DBUS_SESSION_BUS_ADDRESS
	# Exporting HOME fixes tests using XDG directories spec since all defaults
	# are based on $HOME. It is also backward compatible with functions not
	# yet ported to this spec.
	XDG_DATA_HOME="${T}" HOME="${T}" Xemake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/gtk-3.0
	doins "${FILESDIR}"/settings.ini

	dodoc AUTHORS ChangeLog* HACKING NEWS* README*

	# Remove unneeded *.la files
	find "${D}" -name '*.la' -exec rm -f {} +

	# add -framework Carbon to the .pc files
	use aqua && for i in gtk+-3.0.pc gtk+-quartz-3.0.pc gtk+-unix-print-3.0.pc; do
		sed -i -e "s:Libs\: :Libs\: -framework Carbon :" "${ED}"usr/$(get_libdir)/pkgconfig/$i || die "sed failed"
	done
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update

	local GTK3_MODDIR="${EROOT}usr/$(get_libdir)/gtk-3.0/3.0.0"
	gtk-query-immodules-3.0  > "${GTK3_MODDIR}/immodules.cache" \
		|| ewarn "Failed to run gtk-query-immodules-3.0"

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."
	fi
}

pkg_postrm() {
	gnome2_schemas_update
}
