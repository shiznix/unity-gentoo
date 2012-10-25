EAPI="4"
GCONF_DEBUG="no"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit autotools eutils gnome2 python

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}"
UVER="0ubuntu1"
URELEASE="precise"
MY_P="${MY_P/menus-/menus_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="The GNOME menu system patched for the Unity desktop"
HOMEPAGE="http://www.gnome.org"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

# +python for gmenu-simple-editor
IUSE="debug +introspection +python test"

COMMON_DEPEND=">=dev-libs/glib-99.2.29.15:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	python? (
		>=dev-libs/gobject-introspection-0.9.5
		dev-python/pygobject:3
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection] )"
# Older versions of slot 0 install the menu editor and the desktop directories
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-menus-3.0.1-r1:0"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	test? ( dev-libs/gjs )"

pkg_setup() {
	use python && python_pkg_setup
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	if use python || use introspection; then
		use introspection || ewarn "Enabling introspection due to USE=python"
		G2CONF="${G2CONF} --enable-introspection"
	else
		G2CONF="${G2CONF} --disable-introspection"
	fi

	G2CONF="${G2CONF} --disable-static"
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		epatch -p1 "${WORKDIR}/debian/patches/${patch}" || die;
	done
	eautoreconf
	gnome2_src_prepare

	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-3.0.0-ignore_kde_standalone.patch"

	if use python; then
		python_clean_py-compile_files
		python_copy_sources
	else
		sed -e 's/\(SUBDIRS.*\) simple-editor/\1/' \
			-i Makefile.* || die "sed failed"
	fi
}

src_configure() {
	if use python; then
		python_execute_function -s gnome2_src_configure
	else
		gnome2_src_configure
	fi
}

src_compile() {
	if use python; then
		python_execute_function -s gnome2_src_compile
	else
		gnome2_src_compile
	fi
}

src_test() {
	if use python; then
		python_execute_function -s -d
	else
		default
	fi
}

src_install() {
	if use python; then
		python_execute_function -s gnome2_src_install
		python_clean_installation_image
	else
		gnome2_src_install
	fi

#	# Prefix menu, bug #256614
#	mv "${ED}"/etc/xdg/menus/applications.menu \
#		"${ED}"/etc/xdg/menus/gnome-applications.menu || die "menu move failed"

	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/10-xdg-menu-gnome-r1" 10-xdg-menu-gnome
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_mod_optimize GMenuSimpleEditor
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm
	if use python; then
		python_mod_cleanup GMenuSimpleEditor
	fi
}
