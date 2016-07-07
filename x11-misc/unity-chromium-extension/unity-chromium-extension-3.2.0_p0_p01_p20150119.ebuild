# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit eutils qt5-build ubuntu-versionator

UURL="mirror://unity/pool/universe/u/${PN}"
UVER_PREFIX="+15.04.${PVR_MICRO}"

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
QT5_BUILD_DIR="${S}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare
	cp debian/unity-webapps.pem .

	epatch -p1 "${FILESDIR}/fix-building-with-qt5.5.patch"

	qt5-build_src_prepare
}

