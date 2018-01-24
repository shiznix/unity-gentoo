# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manage ebuild hooks in /etc/portage/ehooks"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"

S="${FILESDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/${P}.eselect ehooks.eselect
}
