# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit qmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/a/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"
UVER_SUFFIX="~2"

DESCRIPTION="Application menu module for Qt"
HOMEPAGE="https://launchpad.net/appmenu-qt"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-libs/libdbusmenu-qt"
RDEPEND="${DEPEND}"

S="${WORKDIR}"
DOCS=( NEWS README )

src_configure() {
	# Poorly implemented source writes /usr/lib64/cmake/Qt5Gui/Qt5Gui_AppMenuPlatformThemePlugin.cmake
	#  out to root filesystem at compile step #
	# We include an 'addpredict' here so that the check to write out to root filesystem can quietly fail
	#  in the sandbox without stopping the entire build process
	# This means Qt5Gui_AppMenuPlatformThemePlugin.cmake is now not created but nothing seems to require it anymore
	#  (refer https://bugzilla.redhat.com/show_bug.cgi?id=1307320#c9)
	# Separate to this global appmenu QT5 support seems to break in >=QT-5.6 applications anyway #
	addpredict /usr/lib/cmake/Qt5Gui/
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	insinto /etc/profile.d
	doins data/appmenu-qt5.sh
}
