# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_{6,7} )

URELEASE="vivid"
inherit gnome2 python-any-r1 ubuntu-versionator base

DESCRIPTION="An account manager and channel dispatcher for the Telepathy framework patched for the Unity desktop"
HOMEPAGE="http://cgit.freedesktop.org/telepathy/telepathy-mission-control/"

UURL="mirror://ubuntu/pool/main/t/${PN}-5"

SRC_URI="${UURL}/${PN}-5_${PV}.orig.tar.gz
	${UURL}/${PN}-5_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="connman debug gnome-keyring networkmanager +upower" # test
REQUIRED_USE="?? ( connman networkmanager )"

RDEPEND="
	>=dev-libs/dbus-glib-0.82
	>=dev-libs/glib-2.30:2
	>=sys-apps/dbus-0.95
	>=net-libs/telepathy-glib-0.19
	connman? ( net-misc/connman )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	upower? ( || ( >=sys-power/upower-0.9.11 sys-power/upower-pm-utils >=sys-apps/systemd-183 ) )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-libs/libaccounts-glib
	>=dev-util/gtk-doc-am-1.17
	virtual/pkgconfig
"
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
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	# creds is not available
	gnome2_src_configure \
		--disable-static \
		--enable-libaccounts-sso \
		$(use_enable debug) \
		$(use_with connman connectivity connman) \
		$(use_with networkmanager connectivity nm) \
		$(use_enable upower)
}
