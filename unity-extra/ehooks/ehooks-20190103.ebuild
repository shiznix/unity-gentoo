# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Ebuild hooks customizing packages for use with Unity desktop"
HOMEPAGE="https://packages.ubuntu.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-eselect/eselect-ehooks"

S="${FILESDIR}"

src_install() {
	insinto /etc/portage
	doins -r "${FILESDIR}"/ehooks

	## Rename slot delimiter '--' to ':'.
	##   (a dirname with char ':' can't be listed in the Manifest).
	local dirname prev_shopt=$(shopt -p nullglob)

	shopt -s nullglob
	for dirname in "${D}"/etc/portage/ehooks/*/*--*; do
		mv "${dirname}" "${dirname/--/:}"
	done
	${prev_shopt}
}

pkg_postinst() {
	einfo
	elog "Use 'eselect ehooks' to enable ebuild hooks"
	einfo
}
