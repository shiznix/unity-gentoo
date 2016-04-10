# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="xenial"
inherit python-any-r1 qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity Webapps QML component"
HOMEPAGE="https://launchpad.net/unity-webapps-qml"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE="doc"
RESTRICT="mirror"

RDEPEND="x11-libs/content-hub"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-libs/libunity
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	unity-base/hud
	unity-indicators/indicator-messages
	x11-libs/accounts-qml-module
	x11-libs/libnotify
	x11-libs/ubuntu-ui-toolkit
	x11-libs/unity-action-api
	doc? ( dev-qt/qdoc:5 )
	${PYTHON_DEPS}"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
QT5_BUILD_DIR="${S}"
export QT_SELECT=5

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare

	# Fix missing installation of files due to malformed UnityWebApps.pro #
	sed -e 's:js_files.files = $$PLUGIN_JS_FILES:js_files.files = $$PLUGIN_JS_FILES $$CLIENT_JS_FILES:' \
		-i src/Ubuntu/UnityWebApps/UnityWebApps.pro

	# Fix qdoc path #
	sed -e "s:/usr/lib/\*/qt5/bin/qdoc:/usr/$(get_libdir)/qt5/bin/qdoc:" \
		-i docs/docs.pri

	use doc || \
		sed '/docs.pri/d' \
			-i webapps-qml.pro
	qt5-build_src_prepare
}
