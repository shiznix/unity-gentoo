# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/liba/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140819.1"

DESCRIPTION="QT library for Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0/1.1.4"
#KEYWORDS="~amd64 ~x86"
IUSE="doc qt5"
RESTRICT="mirror"

RDEPEND="dev-libs/libaccounts-glib:=
	dev-qt/qtcore:4
	dev-qt/qtxmlpatterns:4
	doc? ( app-doc/doxygen )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qttest:5
		dev-qt/qtxml:5 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	use doc || \
		for file in $(grep -r doc/doc.pri * | grep .pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
}

src_configure() {
	# Build QT5 support #
	if use qt5; then
		cd "${WORKDIR}"
		cp -rf "${S}" "${S}"-build_qt5
		pushd "${S}"-build_qt5
			/usr/$(get_libdir)/qt5/bin/qmake PREFIX=/usr
		popd
	fi

	# Build QT4 support #
	cd "${WORKDIR}"
	cp -rf "${S}" "${S}"-build_qt4
	pushd "${S}"-build_qt4
		qmake PREFIX=/usr
	popd
}

src_compile() {
	# Build QT5 support #
	if use qt5; then
		pushd "${S}"-build_qt5
			emake
		popd
	fi

	# Build QT4 support #
	pushd "${S}"-build_qt4
		emake
	popd
}

src_install() {
	# Install QT5 support #
	if use qt5; then
		pushd "${S}"-build_qt5
			qt4-r2_src_install
		popd
	fi

	# Install QT4 support #
	pushd "${S}"-build_qt4
		qt4-r2_src_install
	popd
}
