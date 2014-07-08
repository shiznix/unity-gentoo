# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils multilib ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140318"

DESCRIPTION="Chromium extension: Unity Integration"
HOMEPAGE="https://launchpad.net/unity-chromium-extension"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/libunity-webapps:="
DEPEND="${RDEPEND}
	app-editors/vim-core
	www-client/chromium"
# Webapp integration doesn't work for www-client/google-chrome #

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch "${FILESDIR}/strlen_fix.diff"
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #
	cp debian/unity-webapps.pem .
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
}
