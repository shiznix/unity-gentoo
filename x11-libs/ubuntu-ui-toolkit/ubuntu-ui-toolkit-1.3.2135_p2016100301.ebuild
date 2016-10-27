# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit gnome2-utils qt5-build ubuntu-versionator virtualx

UURL="mirror://unity/pool/main/u/${PN}"
UVER="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Qt Components for the Unity desktop - QML plugin"
HOMEPAGE="https://launchpad.net/ubuntu-ui-toolkit"
SRC_URI="${UURL}/${MY_P}${UVER}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="examples test"
RESTRICT="mirror"

RDEPEND="dev-qt/qtfeedback:5
	x11-libs/unity-action-api"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qdoc:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtpim:5
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	media-gfx/thumbnailer"

S="${WORKDIR}"
QT5_BUILD_DIR="${S}"
export QT_SELECT=5
unset QT_QPA_PLATFORMTHEME

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare

	# Fix build hanging when trying to build with QT-5.6 #
	epatch -p1 "${FILESDIR}/qt-5.6_qmlplugindump-wrapper.sh-fix.diff"

	# Don't install autopilot python testsuite files, they require dpkg to run tests #
	sed -e '/autopilot/d' \
		-i tests/tests.pro
	qt5-build_src_prepare
}

src_test() {
	Xemake check	# Currently fails with 'tst_headActions.qml exited with 666' #
}

src_install() {
	qt5-build_src_install
	use examples || \
		rm -rf "${ED}usr/lib/ubuntu-ui-toolkit/examples" \
			"${ED}usr/share/applications"
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
