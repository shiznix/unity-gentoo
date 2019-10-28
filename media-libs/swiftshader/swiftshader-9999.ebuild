# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="CPU-based implementation of the Vulkan, OpenGL ES, and Direct3D 9 graphics APIs"
HOMEPAGE="https://github.com/google/swiftshader"
EGIT_REPO_URI="https://github.com/google/${PN}.git"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-util/spirv-headers
	dev-util/spirv-tools"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWARNINGS_AS_ERRORS=0
		-DBUILD_TESTS=0
	)
	cmake-utils_src_configure
}

src_install() {
	pushd "${BUILD_DIR}"
		insinto /usr/lib/swiftshader
		doins libEGL.so libGLES_CM.so libGLESv2.so libvk_swiftshader.so
	popd
}
