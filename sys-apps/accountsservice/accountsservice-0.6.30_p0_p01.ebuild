# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit autotools base eutils gnome2 systemd ubuntu-versionator vala

URELEASE=
UVER_PREFIX="+logind~raring2"

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="http://www.fedoraproject.org/wiki/Features/UserAccountDialog"
SRC_URI="https://launchpad.net/~gnome3-team/+archive/gnome3-staging/+files/${MY_P}.orig.tar.gz
	https://launchpad.net/~gnome3-team/+archive/gnome3-staging/+files/${MY_P}-${UVER}${UVER_PREFIX}.debian.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc +introspection systemd vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="mirror"

# Want glib-2.34 for g_clear_pointer, bug #462938
RDEPEND=">=dev-libs/glib-2.34.0:2
	sys-auth/polkit
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	systemd? ( >=sys-apps/systemd-186 )
	!systemd? ( sys-auth/consolekit )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-1.18
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

	# Ubuntu patchset #
	sed -i '/0002-create-and-manage-groups-like-on-a-ubuntu-system.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/0006-adduser_instead_of_useradd.patch/d' "${WORKDIR}/debian/patches/series" || die
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
	eautoreconf

	# Patches from 0.6.31
	epatch "${FILESDIR}/${MY_P}-login-history-variant.patch"
	epatch "${FILESDIR}/${MY_P}-xsession-typo.patch"

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-more-warnings \
		--localstatedir="${EPREFIX}"/var \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable doc docbook-docs) \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_enable systemd) \
		$(systemd_with_unitdir)
}
