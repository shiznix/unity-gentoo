# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

URELEASE="artful"
inherit mono ubuntu-versionator

UVER="-${PVR_PL_MAJOR}build${PVR_PL_MINOR}"

DESCRIPTION="Taglib# 2.0 - Managed tag reader/writer"
HOMEPAGE="https://github.com/mono/taglib-sharp"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RESTRICT="mirror"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	sed -i	-e "s:docs::" \
		-e "s:examples::" \
		Makefile.in || die "sedding sense into makefiles failed"
}

src_configure() {
	econf --disable-docs
}
