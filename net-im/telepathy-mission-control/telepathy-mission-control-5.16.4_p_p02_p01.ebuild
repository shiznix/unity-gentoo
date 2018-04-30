# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="artful"
inherit autotools gnome2-utils python-any-r1 ubuntu-versionator

DESCRIPTION="An account manager and channel dispatcher for the Telepathy framework patched for the Unity desktop"
HOMEPAGE="http://cgit.freedesktop.org/telepathy/telepathy-mission-control/"

UURL="mirror://unity/pool/universe/t/${PN}-5"

SRC_URI="${UURL}/${PN}-5_${PV}.orig.tar.gz
	${UURL}/${PN}-5_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug networkmanager systemd upower" # test

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	>=sys-apps/dbus-0.95
	net-libs/telepathy-glib
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	!systemd? ( upower? ( >=sys-power/upower-pm-utils-0.9.23 ) )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-libs/libaccounts-glib
	>=dev-util/gtk-doc-am-1.17
	virtual/pkgconfig"
#	test? ( ${PYTHON_DEPS}
#		dev-python/twisted-words )"

# Tests are broken, see upstream bug #29334 and #64212
# upstream doesn't want it enabled everywhere (#29334#c12)
RESTRICT="mirror test"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	# creds is not available
	econf \
		--disable-static \
		--enable-libaccounts-sso \
		$(use_enable debug) \
		$(use_with networkmanager connectivity nm) \
		$(use_enable upower) \
		$(use systemd && echo "--disable-upower")
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}
