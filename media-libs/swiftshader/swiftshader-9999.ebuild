# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

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
		-DSWIFTSHADER_WARNINGS_AS_ERRORS=0
		-DSWIFTSHADER_BUILD_TESTS=0
		-DCMAKE_BUILD_RPATH=/usr/lib/swiftshader
	)
	cmake_src_configure
}

src_install() {
	pushd "${BUILD_DIR}"
		insinto /usr/lib/swiftshader
		find . -name 'libvk_*' -exec doins {} \;
		doins third_party/marl/libmarl*
	popd
}
