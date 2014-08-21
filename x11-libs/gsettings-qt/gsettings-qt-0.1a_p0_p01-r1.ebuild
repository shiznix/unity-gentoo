# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VIRTUALX_REQUIRED="always"

inherit qt5-build ubuntu-versionator virtualx

UURL="mirror://ubuntu/pool/main/g/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140807"

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
	qt5-build_src_prepare

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

src_install() {
	# Needs to be run in a virtual Xserver so that qmlplugindump's #
	#       qmltypes generation can successfully spawn dbus #
	pushd ${QT5_BUILD_DIR}
		Xemake INSTALL_ROOT="${ED}" install
	popd
}
