# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit python-any-r1 qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140731"

DESCRIPTION="Unity Webapps QML component"
HOMEPAGE="https://launchpad.net/unity-webapps-qml"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="x11-libs/content-hub"
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-libs/libunity
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	unity-base/hud
	unity-indicators/indicator-messages
	x11-libs/accounts-qml-module
	x11-libs/libnotify
	x11-libs/ubuntu-ui-toolkit
	x11-libs/unity-action-api
	${PYTHON_DEPS}"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
QT5_BUILD_DIR="${S}"
export PATH="${PATH}:/usr/$(get_libdir)/qt5/bin"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-any-r1_pkg_setup
	qt5-build_pkg_setup
}

src_prepare() {
	# Fix missing installation of files due to malformed UnityWebApps.pro #
	sed -e 's:js_files.files = $$PLUGIN_JS_FILES:js_files.files = $$PLUGIN_JS_FILES $$CLIENT_JS_FILES:' \
		-i src/Ubuntu/UnityWebApps/UnityWebApps.pro
	qt5-build_src_prepare
}
