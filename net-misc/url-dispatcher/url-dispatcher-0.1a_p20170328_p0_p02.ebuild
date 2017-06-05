# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Service to allow sending of URLs and get handlers started, used by the Unity desktop"
HOMEPAGE="https://launchpad.net/url-dispatcher"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libdbusmenu:=
	dev-util/dbus-test-runner
	mir-base/mir:=
	sys-apps/dbus
	sys-apps/ubuntu-app-launch"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Disable -Werror #
	epatch -p1 "${FILESDIR}/disable-Werror.diff"

	# Remove dependency on whoopsie (Ubuntu's error submission tracker)
	for each in $(grep -ri whoopsie | awk -F: '{print $1}'); do
		sed -e '/whoopsie/Id' -i "${each}"
	done
	cmake-utils_src_prepare
}

src_configure() {
	! use test && \
		mycmakeargs+=(-Denable_tests=OFF)
	cmake-utils_src_configure
}
