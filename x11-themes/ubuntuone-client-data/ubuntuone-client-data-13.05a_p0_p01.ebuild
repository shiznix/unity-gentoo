# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="trusty"

DESCRIPTION="Data files used by the Ubuntu One suite"
HOMEPAGE="https://launchpad.net/ubuntuone-client-data"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RESTRICT="mirror"

DEPEND=">=dev-python/python-distutils-extra-2.37
	${PYTHON_DEPS}"

src_install() {
	distutils-r1_src_install

	# Removed apport stuff #
	rm -rf "${ED}etc" "${ED}usr/share/apport"
}
