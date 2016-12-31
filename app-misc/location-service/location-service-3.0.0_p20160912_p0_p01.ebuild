# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/l/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Location service aggregating position/velocity/heading"
HOMEPAGE="http://launchpad.net/location-service"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-cpp/gflags
	dev-cpp/glog
	dev-libs/boost:=
	dev-libs/dbus-cpp
	dev-libs/json-c
	dev-libs/net-cpp
	dev-libs/process-cpp
	dev-libs/properties-cpp
	dev-libs/trust-store
	sys-apps/dbus"

S="${WORKDIR}/${PN}"

src_configure() {
	# GPS is for the Android platform, so disable it #
	mycmakeargs+=(-DLOCATION_SERVICE_ENABLE_GPS_PROVIDER=FALSE
			-DUBUNTU_LOCATION_SERVICE_VERSION_MAJOR=3)
	cmake-utils_src_configure

	# Ubuntu's 'pkg-config --cflags ...' outputs Requires: first and Cflags: last #
	# Gentoo's 'pkg-config --cflags ...' outputs Cflags: first and Requires: last #
	#  Re-order to what the source expects #
	sed -e 's:\(.*\)=\(.*dbus-cpp-0;\)\(.*\):\1=\3;\2:g' \
		-e 's:;$::g' \
			-i "${BUILD_DIR}"/CMakeCache.txt
}
