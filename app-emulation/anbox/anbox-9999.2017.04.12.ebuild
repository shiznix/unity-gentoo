# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit cmake-utils git-r3 linux-info versionator

DESCRIPTION="Run Android applications on any GNU/Linux operating system"
HOMEPAGE="https://anbox.io/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
IMG_PATH="$(get_version_component_range 2)/$(get_version_component_range 3)/$(get_version_component_range 4)"
SRC_URI="http://build.anbox.io/android-images/${IMG_PATH}/android_1_amd64.img"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-emulation/lxc
	dev-cpp/gmock
	dev-cpp/gtest
	dev-libs/boost:=[threads]
	dev-libs/dbus-cpp
	dev-libs/glib:2
	dev-libs/properties-cpp
	dev-libs/protobuf
	media-libs/libsdl2
	media-libs/mesa[egl,gles2]
	media-libs/sdl2-image
	sys-apps/dbus
	sys-libs/libcap"

CONFIG_CHECK="
	~ANDROID_BINDER_IPC
	~ASHMEM
	~NAMESPACES
	~IPC_NS
	~NET_NS
	~PID_NS
	~USER_NS
	~UTS_NS
"

pkg_setup() {
	linux-info_pkg_setup
}

src_install() {
	cmake-utils_src_install
	insinto /var/lib/anbox
	newins "${DISTDIR}/android_1_amd64.img" android.img
}
