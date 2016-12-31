# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils gnome2-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/q/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Qt platform abstraction (QPA) plugin for a Mir server (desktop)"
HOMEPAGE="https://launchpad.net/qtmir"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug test"
RESTRICT="mirror"

DEPEND="app-admin/cgmanager
	dev-libs/glib:2
	dev-libs/libqtdbusmock
	dev-libs/libqtdbustest
	dev-libs/process-cpp
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5[egl]
	dev-util/lttng-ust
	media-libs/fontconfig
	media-libs/mesa[egl,gles2]
	mir-base/mir:=
	net-misc/url-dispatcher
	sys-apps/ubuntu-app-launch
	unity-base/unity-api
	>=x11-libs/content-hub-0.2
	x11-libs/gsettings-qt
	x11-libs/libxkbcommon
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}"
export QT_SELECT=5

src_configure() {
	use test || mycmakeargs+=(-DNO_TESTS=ON)
	mycmakeargs+=(-DUSE_OPENGLES=1
			-DCMAKE_BUILD_TYPE="$(usex debug debug)")
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
