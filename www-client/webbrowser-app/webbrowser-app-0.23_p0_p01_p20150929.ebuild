# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )
DISTUTILS_SINGLE_IMPL=1

URELEASE="wily"
inherit distutils-r1 cmake-utils ubuntu-versionator	# Inheritance order important

UURL="mirror://unity/pool/main/w/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity webapps browser application"
HOMEPAGE="https://launchpad.net/webbrowser-app"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-qt/qtquickcontrols:5[widgets]
	net-libs/oxide-qt
	x11-themes/ubuntu-themes"
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5[qml,multimedia,webp]
	dev-qt/qtwidgets:5
	x11-libs/unity-webapps-qml"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
export QT_SELECT=5

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	cmake-utils_src_install
	dosym /usr/share/qtdeclarative5-ubuntu-web-plugin/assets/multi_selection_handle\@20.png \
		/usr/$(get_libdir)/qt5/qml/Ubuntu/Components/Extras/Browser/assets/multi_selection_handle.png
	dosym /usr/share/qtdeclarative5-ubuntu-web-plugin/assets/multi_selection_handle\@20.png \
		/usr/$(get_libdir)/qt5/qml/Ubuntu/Web/assets/multi_selection_handle.png
}
