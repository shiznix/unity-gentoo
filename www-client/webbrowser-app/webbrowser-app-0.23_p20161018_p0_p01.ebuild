# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )
DISTUTILS_SINGLE_IMPL=1

URELEASE="yakkety-updates"
inherit distutils-r1 cmake-utils ubuntu-versionator	# Inheritance order important

UURL="mirror://unity/pool/main/w/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Unity webapps browser application"
HOMEPAGE="https://launchpad.net/webbrowser-app"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
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
	x11-libs/unity-webapps-qml
	x11-misc/xvfb-run"

S="${WORKDIR}"
export QT_SELECT=5

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	cmake-utils_src_install

	# If a .desktop file does not have inline translations, fall back #
	#  to calling gettext #
	find ${ED} -type f -name "*.desktop*" \
		-exec sh -c 'sed -i -e "/\[Desktop Entry\]/a X-GNOME-Gettext-Domain=${PN}" "$1"' -- {} \;

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}
