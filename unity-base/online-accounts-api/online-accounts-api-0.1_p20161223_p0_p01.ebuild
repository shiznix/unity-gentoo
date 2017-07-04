# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/o/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Online Accounts simplified API (D-Bus service)"
HOMEPAGE="https://launchpad.net/online-accounts-api"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/libqtdbusmock
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	unity-base/signon
	unity-base/ubuntu-system-settings-online-accounts
	x11-libs/libaccounts-qt"

S="${WORKDIR}"
export QT_SELECT=5

src_install() {
	cmake-utils_src_install

	# Remove as is provided by unity-base/ubuntu-system-settings-online-accounts #
	rm "${ED}usr/share/dbus-1/services/com.ubuntu.OnlineAccounts.Manager.service"
}
