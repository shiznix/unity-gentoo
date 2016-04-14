# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
CMAKE_BUILD_TYPE=none

URELEASE="xenial"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/universe/t/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Ubuntu's thumbnailer service"
HOMEPAGE="https://launchpad.net/thumbnailer"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/leveldb
	dev-libs/libxml2
	dev-libs/persistent-cache-cpp
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/libexif
	net-libs/libsoup:2.4
	unity-base/unity-api
	x11-libs/gdk-pixbuf
	x11-misc/shared-mime-info
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	use doc || \
		sed -e '/add_subdirectory(doc)/d' \
			-i CMakeLists.txt

	# Be friendly to new glibc-2.22 fcntl2.h changes (man open) - requires file mode argument #
	has_version ">=sys-libs/glibc-2.22" && \
		sed -e 's:O_TMPFILE |:O_TMPFILE, S_IRWXU |:g' \
			-i src/service/handler.cpp

	# Tests are totally broken and don't even pass the configure phase #
	#	Incorrect use of CMAKE_LIBRARY_ARCHITECTURE means the variable is never fulfilled
	#		tests/qml/CMakeLists.txt:12 (if):
	#			if given arguments:
	# 				"STREQUAL" "powerpc-linux-gnu" "OR" "STREQUAL" "s390x-linux-gnu"
	#					Unknown arguments specified
	sed -e 's:add_subdirectory(tests):#add_subdirectory(tests):g' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_SYSCONFDIR=/etc)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Delete some files that are only useful on Ubuntu
	rm -rf "${ED}"etc/apport
}
