# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libp/${PN}"

DESCRIPTION="Google's phone number handling library"
HOMEPAGE="http://code.google.com/p/libphonenumber/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/boost:=
	dev-libs/icu:=
	dev-libs/protobuf
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	net-libs/liboauth
	unity-base/signon
	x11-libs/libaccounts-qt"

S="${WORKDIR}/${PN}/cpp"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Replace the source's redundant debian/ directory with the more up-to-date one from the patchset tarball #
	rm -rf "${WORKDIR}/${PN}/debian" &> /dev/null
	mv "${WORKDIR}/debian" "${WORKDIR}/${PN}/" &> /dev/null

	# Cannot rely on eclasses to apply patchset due to source's odd paths, so do it manually #
	pushd "${WORKDIR}/${PN}"
		for patch in $(grep -v \# debian/patches/series); do
			epatch -p1 "debian/patches/${patch}"
		done
	popd
	ubuntu-versionator_src_prepare

	# Disable '-Werror' #
	sed -e 's/-Werror//g' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}
