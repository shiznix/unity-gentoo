# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="disco"
inherit cmake-utils ubuntu-versionator

UVER_PREFIX="+14.04.${PVR_MICRO}"

DESCRIPTION="Unity Scope that provides online music to the Dash"
HOMEPAGE="https://launchpad.net/unity-scope-onlinemusic"
SRC_URI="${UURL}/${PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-libs/dee:=
	dev-libs/glib:2
	dev-libs/libunity:=
	dev-util/intltool
	sys-apps/util-linux
	sys-devel/gettext
	virtual/pkgconfig

	test? ( dev-qt/qttest:5 )"

S+=${UVER_PREFIX}

src_prepare() {
	ubuntu-versionator_src_prepare

	# Drop circular dependency
	sed -i \
		-e "/DEPENDS onlinemusic.scope.in/d" \
		data/CMakeLists.txt

	# Disable tests #
	use test || sed -i \
		-e "/Qt5Test/d" \
		-e "/ENABLE_TESTING/d" \
		-e "/ADD_SUBDIRECTORY(tests)/d" \
		CMakeLists.txt

	cmake-utils_src_prepare
}
