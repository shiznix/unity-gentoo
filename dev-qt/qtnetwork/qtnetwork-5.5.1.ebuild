# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT5_MODULE="qtbase"

inherit qt5-build

DESCRIPTION="Network abstraction library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	#KEYWORDS=""
#else
	#KEYWORDS="~amd64 ~x86"
:
fi

IUSE="connman networkmanager +ssl"

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	sys-libs/zlib
	connman? ( ~dev-qt/qtdbus-${PV} )
	networkmanager? ( ~dev-qt/qtdbus-${PV} )
	ssl? ( dev-libs/openssl:0[-bindist] )
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

QT5_TARGET_SUBDIRS=(
	src/network
	src/plugins/bearer/generic
)

QT5_GENTOO_CONFIG=(
	ssl::SSL
	ssl::OPENSSL
	ssl:openssl-linked:LINKED_OPENSSL
)

pkg_setup() {
	use connman && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/connman)
	use networkmanager && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/networkmanager)
}

src_configure() {
	local myconf=(
		$(use connman || use networkmanager && echo -dbus-linked)
		$(use ssl && echo -openssl-linked)
	)
	qt5-build_src_configure
}
