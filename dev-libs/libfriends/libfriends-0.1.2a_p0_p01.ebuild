# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
VALA_MAX_API_VERSION="0.18"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/libf/${PN}"
URELEASE="saucy"
UVER_PREFIX="daily13.06.07"

DESCRIPTION="API for accessing social networks"
HOMEPAGE="https://launchpad.net/friends"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="spell"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	net-im/friends
	spell? ( app-text/gtkspell:2 )
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	sed -e 's:gtkspell-3.0):gtkspell-2.0):' \
		-i configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable spell) \
		--enable-introspection
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}
