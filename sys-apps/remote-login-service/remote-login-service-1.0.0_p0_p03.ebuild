# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils ubuntu-versionator

UURL="mirror://unity/pool/main/r/${PN}"
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

RDEPEND="net-misc/networkmanager
	net-libs/libsoup
	unity-extra/thin-client-config-agent"

src_prepare() {
	ubuntu-versionator_src_prepare
	# remove 'dbustest1-dev' dependency
	sed -i -e '/^PKG_CHECK_MODULES(TEST, dbustest-1)/d' configure.ac
	eautoreconf
}
