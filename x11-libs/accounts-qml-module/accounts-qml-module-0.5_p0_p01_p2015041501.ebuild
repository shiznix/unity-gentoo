# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VIRTUALX_REQUIRED="always"

URELEASE="vivid"
inherit base gnome2-utils qt5-build ubuntu-versionator virtualx

UURL="mirror://ubuntu/pool/main/a/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Expose Unity Online Accounts API to QML applications"
HOMEPAGE="https://launchpad.net/accounts-qml-module"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	unity-base/signon[qt5]
	x11-libs/libaccounts-qt[qt5]"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
QT5_BUILD_DIR="${S}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	gnome2_environment_reset
}

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"

	use doc || \
		sed -e '/doc\/doc.pri/d' \
			-i accounts-qml-module.pro
	qt5-build_src_prepare
}

src_install() {
	# 'make install' needs to be run in a virtual Xserver so that qmlplugindump's #
	#	qmltypes generation can successfully spawn dbus #
	pushd ${QT5_BUILD_DIR}
		Xemake INSTALL_ROOT="${ED}" install
	popd
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
