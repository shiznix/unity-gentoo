EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 systemd vala ubuntu-versionator

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="http://www.fedoraproject.org/wiki/Features/UserAccountDialog"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/a/${PN}"
URELEASE="raring"

SRC_URI="${UURL}/${MY_P}.orig.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc +introspection systemd vala"
REQUIRED_USE="vala? ( introspection )"

# Want glib-2.30 for gdbus
RDEPEND=">=dev-libs/glib-2.30:2
	sys-auth/polkit
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	systemd? ( >=sys-apps/systemd-186 )
	!systemd? ( sys-auth/consolekit )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto )
	vala? (
		>=dev-lang/vala-0.16.1-r1
		$(vala_depend) )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.6.21-gentoo-system-users.patch"
	epatch "${FILESDIR}/${PN}-0.6.29-32bit-crash.patch" # bug #445894, fixed in 0.6.30
	epatch "${FILESDIR}/0001-formats-locale-property.patch"
	epatch "${FILESDIR}/0007-add-lightdm-support.patch"
	epatch "${FILESDIR}/0008-nopasswdlogin-group.patch"
	epatch "${FILESDIR}/0009-language-tools.patch"
	epatch "${FILESDIR}/0010-set-language.patch"
	epatch "${FILESDIR}/0011-add-background-file-support.patch"
	epatch "${FILESDIR}/0012-add-keyboard-layout-support.patch"
	epatch "${FILESDIR}/0013-add-has-message-support.patch"
	epatch "${FILESDIR}/1001-buildsystem.patch"
	epatch "${FILESDIR}/2001-filtering_out_users.patch"
	epatch "${FILESDIR}/2002-disable_systemd.patch"

	./autogen.sh

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		--disable-more-warnings
		--localstatedir="${EPREFIX}"/var
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable doc docbook-docs)
		$(use_enable introspection)
		$(use_enable vala)
		$(use_enable systemd)
		$(systemd_with_unitdir)"
	gnome2_src_configure
}
