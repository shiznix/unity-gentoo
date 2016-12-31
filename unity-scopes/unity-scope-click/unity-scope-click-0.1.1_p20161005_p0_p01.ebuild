# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Click Packages Scope for Unity"
HOMEPAGE="https://launchpad.net/unity-scope-click"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-admin/packagekit-base
	app-misc/pay-service
	dev-cpp/gmock
	dev-db/sqlite:3
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/jsoncpp
	dev-libs/libaccounts-glib
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	net-libs/ubuntu-download-manager
	net-libs/ubuntuone-credentials
	sys-apps/ubuntu-app-launch
	sys-apps/upstart
	unity-base/signon
	unity-base/unity-scopes-api
	x11-libs/gsettings-qt"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	# Disable '-Werror' #
	sed -e 's/-Werror //g' \
		-i CMakeLists.txt

	# Gentoo does not allow /usr/sbin in user's $PATH #
	sed -e 's:sbin:bin:g' \
		-i tools/init-departments/CMakeLists.txt

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	# due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}
