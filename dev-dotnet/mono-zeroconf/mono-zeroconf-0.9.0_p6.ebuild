# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="groovy"
inherit mono ubuntu-versionator

UVER="-${PVR_MICRO}"

DESCRIPTION="a cross platform Zero Configuration Networking library for Mono and .NET"
HOMEPAGE="http://www.mono-project.com/Mono.Zeroconf"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

DEPEND=">=dev-lang/mono-2.0"
RDEPEND=">=net-dns/avahi-0.6[mono]"
BDEPEND="virtual/pkgconfig"
RESTRICT="mirror"

src_prepare() {
	sed -e 's:mono/2.0:mono/2.0-api:g' \
		-i configure || die
	default
}

src_configure() {
	econf $(use_enable doc docs) --enable-avahi
}

src_compile() {
	emake -j1 || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README || die "docs failed"
	mono_multilib_comply
}
