# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140801.1"

DESCRIPTION="Qml bindings for GSettings."
HOMEPAGE="https://launchpad.net/gsettings-qt"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	>=dev-libs/glib-2.38.1
"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	# Don't pre-strip
	echo "CONFIG+=nostrip" >> "${S}"/GSettings/gsettings-qt.pro
	echo "CONFIG+=nostrip" >> "${S}"/src/gsettings-qt.pro
	echo "CONFIG+=nostrip" >> "${S}"/tests/tests.pro

	if ! use test; then
		# remove from build
		sed -e 's:tests\/tests.pro: :g' \
			-i "${S}"/gsettings-qt.pro
	fi

}

src_configure() {
	cd "${WORKDIR}"
	cp -rf "${S}" "${S}"-build_qt5
	pushd "${S}"-build_qt5
		/usr/$(get_libdir)/qt5/bin/qmake PREFIX=/usr
	popd
}

src_compile() {
	pushd "${S}"-build_qt5
		emake
	popd
}

src_install() {
	pushd "${S}"-build_qt5
#		qt5-build_src_install
		 qt4-r2_src_install
	popd
}

