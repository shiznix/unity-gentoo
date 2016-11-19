# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://unity/pool/main/c/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Content sharing/picking service to allow apps to exchange content"
HOMEPAGE="https://launchpad.net/content-hub"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
#KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

# x11-libs/ubuntu-ui-toolkit is added to DEPEND to ensure it gets updated and rebuilt with any QT5 update before content-hub attempts to call qmplugindump #
#	Otherwise we get the error example "Cannot mix incompatible Qt library (version 0x50402) with this library (version 0x50501)" #
#	In future, better QT5 dep. version handling and subslot rebuilds should handle this without needing to add indirect deps. here #
#
DEPEND="!dev-libs/libupstart-app-launch
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qttest:5
	dev-qt/qdoc:5
	dev-util/dbus-test-runner
	dev-util/lcov
	net-libs/ubuntu-download-manager:=
	sys-apps/libertine
	sys-apps/ubuntu-app-launch
	>=sys-libs/libapparmor-2.9.1
	sys-libs/libnih[dbus]
	x11-libs/gsettings-qt
	x11-libs/libnotify
	x11-libs/ubuntu-ui-toolkit"

S="${WORKDIR}"
export QT_SELECT=5
export QT_DEBUG_PLUGINS=1	# Uncommented to debug the inevitable QML plugins problems
export QML_IMPORT_TRACE=1
unset QT_QPA_PLATFORMTHEME

pkg_setup() {
	## This only applies on an upgrade path. On a clean system these bugs are not encountered ##
	#	If system has www-client/webbrowser-app already installed
	#	then x11-libs/content-hub will fail to build due to qmlplugindump LP bugs #1332996 and #1341565
	if has_version "www-client/webbrowser-app"; then
		eerror
		eerror "Oops... www-client/webbrowser-app is detected as being installed on your system"
		eerror "  Please first 'emerge -C www-client/webbrowser-app' before (re-)installing x11-libs/content-hub"
		eerror "  www-client/webbrowser-app may be re-installed after x11-libs/content-hub has been installed"
		eerror "  Root cause of this qmlplugindump bug is being tracked as open Ubuntu Launchpad bugs #1332996 and #1341565"
		eerror
		die
	fi
	ubuntu-versionator_pkg_setup
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
