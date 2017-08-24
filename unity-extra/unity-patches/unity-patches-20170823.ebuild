# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Patches from Ubuntu package archive"
HOMEPAGE="https://packages.ubuntu.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-eselect/eselect-unity-patches"

S="${FILESDIR}"

src_install() {
	insinto /etc/portage
	doins -r "${FILESDIR}"/unity-patches

	## Rename slot delimiter '--' to ':'.
	##   (a dirname with char ':' can't be listed in the Manifest).
	local dirname prev_shopt=$(shopt -p nullglob)

	shopt -s nullglob
	for dirname in "${D}"/etc/portage/unity-patches/*/*--*; do
		mv "${dirname}" "${dirname/--/:}"
	done
	${prev_shopt}
}

pkg_postinst() {
	einfo
	elog "Use 'eselect unity-patches' to enable patches"
	einfo
}
