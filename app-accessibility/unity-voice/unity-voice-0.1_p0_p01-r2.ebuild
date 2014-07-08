# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140304"

DESCRIPTION="A simple 'command and control' type voice recognition service, using pocketsphinx under the hood."
HOMEPAGE="https://launchpad.net/unity-voice"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND="app-accessibility/sphinx-voxforge-en"
DEPEND="${RDEPEND}
	app-accessibility/pocketsphinx
	app-accessibility/sphinxbase
	dev-cpp/gmock
	dev-libs/libqtdbustest
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qttest:5
	media-sound/pulseaudio"

src_prepare() {
	# disable build of tests
	sed -i '/add_subdirectory(tests)/d' "${S}/CMakeLists.txt" || die
}

src_install() {
	cmake-utils_src_install

	# Remove upstart jobs, the service starts fine when triggered on dbus #
	rm -rf "${ED}usr/share/upstart"
}
