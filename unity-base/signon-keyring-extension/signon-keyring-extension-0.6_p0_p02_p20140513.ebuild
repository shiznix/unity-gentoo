# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="vivid"
inherit base qt4-r2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
UVER_PREFIX="+14.10.${PVR_MICRO}"

DESCRIPTION="GNOME keyring extension for signond used by the Unity desktop"
HOMEPAGE="https://launchpad.net/signon-keyring-extension"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="gnome-base/libgnome-keyring
	app-crypt/libsecret
	dev-qt/qtcore:4
	unity-base/signon"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"

	# Let portage strip files #
	sed -e 's:CONFIG         +=:CONFIG += nostrip:g' -i "${S}/common-project-config.pri" || die

	# fix 'QA Notice: The following files contain insecure RUNPATHs'
	sed -e 's:QMAKE_RPATHDIR:\#QMAKE_RPATHDIR:g' -i "${S}/tests/tests.pro" || die
}
