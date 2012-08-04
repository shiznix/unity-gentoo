EAPI=4

inherit autotools base eutils gnome2 virtualx

# Prefixing version with 99. so as not to break the overlay with upgrades in the main tree #
MY_PV="${PV/99./}"
MY_P="${PN}_${MY_PV}"

S="${WORKDIR}/${PN}-${MY_PV}"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/n/${PN}"
UVER="0ubuntu4"
URELEASE="precise-updates"
MY_P="${MY_P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="A file manager for the GNOME desktop patched for the Unity desktop"
HOMEPAGE="http://live.gnome.org/Nautilus"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="doc exif gnome +introspection packagekit +previewer sendto tracker xmp"

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND=">=dev-libs/glib-2.31.9:2
	dev-libs/libzeitgeist
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.3.17:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3.0.0:3

	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
	unity-base/launchpad-integration
	unity-base/unity
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	tracker? ( >=app-misc/tracker-0.12 )
	xmp? ( >=media-libs/exempi-2.1.0 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.31.0
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.4 )"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )"
# For eautoreconf
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am"
PDEPEND="gnome? (
		>=x11-themes/gnome-icon-theme-1.1.91
		x11-themes/gnome-icon-theme-symbolic )
	tracker? ( >=gnome-extra/nautilus-tracker-tags-0.12 )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-0.1.2"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		$(use_enable exif libexif)
		$(use_enable introspection)
		$(use_enable packagekit)
		$(use_enable sendto nst-extension)
		$(use_enable tracker)
		$(use_enable xmp)"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS"
}

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf
	gnome2_src_prepare

	# Remove crazy CFLAGS
	sed 's:-DG.*DISABLE_DEPRECATED::g' -i configure.in configure \
		|| die "sed 1 failed"
}

src_test() {
	addpredict "/root/.gnome2_private"
	unset SESSION_MANAGER
	unset ORBIT_SOCKETDIR
	unset DBUS_SESSION_BUS_ADDRESS
	export GSETTINGS_BACKEND="memory"
	Xemake check
	unset GSETTINGS_BACKEND
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use previewer; then
		elog "nautilus uses gnome-extra/sushi to preview media files."
		elog "To activate the previewer, select a file and press space; to"
		elog "close the previewer, press space again."
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}
