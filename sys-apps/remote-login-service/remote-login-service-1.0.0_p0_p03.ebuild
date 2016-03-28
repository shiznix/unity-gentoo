# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
GNOME2_LA_PUNT="yes"

inherit eutils autotools ubuntu-versionator base

UURL="mirror://ubuntu/pool/main/r/${PN}"
URELEASE="vivid"

DESCRIPTION="A service that lists remote logins."
HOMEPAGE="https://launchpad.net/remote-login-service"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgcrypt"

RDEPEND=">=net-misc/networkmanager-0.9.7
	>=net-libs/libsoup-2.40
	unity-extra/thin-client-config-agent"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	# remove 'dbustest1-dev' dependency
	sed -i -e '/^PKG_CHECK_MODULES(TEST, dbustest-1)/d' configure.ac

	eautoreconf
	base_src_prepare
}
