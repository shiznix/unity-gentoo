# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 cmake-utils ubuntu-versionator	# Inheritance order important

UURL="mirror://ubuntu/pool/main/w/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140812"

DESCRIPTION="Unity webapps browser application"
HOMEPAGE="https://launchpad.net/webbrowser-app"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="net-libs/oxide-qt"
DEPEND="dev-libs/glib
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5[libxml2,qml,multimedia,webp,widgets,xslt]
	dev-qt/qtwidgets:5
	x11-libs/unity-webapps-qml"

S=${WORKDIR}/${PN}-${PV}${UVER_PREFIX}
export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	cmake-utils_src_install

	dosym /usr/share/qtdeclarative5-ubuntu-ui-extras-browser-plugin/assets/multi_selection_handle\@20.png \
		/usr/$(get_libdir)/qt5/qml/Ubuntu/Components/Extras/Browser/assets/multi_selection_handle.png
}
