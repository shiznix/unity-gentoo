# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="The Qt toolkit is a comprehensive C++ application development framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	#KEYWORDS="~amd64"
:
fi

IUSE="+glib icu"

DEPEND="
	>=dev-libs/libpcre-8.30[pcre16]
	sys-libs/zlib
	virtual/libiconv
	glib? ( dev-libs/glib:2 )
	icu? ( dev-libs/icu:= )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/corelib
)
QCONFIG_DEFINE=( QT_ZLIB )

pkg_setup() {
	QCONFIG_REMOVE=(
		$(usev !glib)
		$(usev !icu)
	)

	qt5-build_pkg_setup
}

src_configure() {
	local myconf=(
		$(qt_use glib)
		-iconv
		$(qt_use icu)
	)
	qt5-build_src_configure
}
