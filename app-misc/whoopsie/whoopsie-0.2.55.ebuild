# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit ubuntu-versionator

UURL="mirror://unity/pool/main/w/${PN}"
UVER=

DESCRIPTION="Ubuntu error tracker submission"
HOMEPAGE="http://wiki.ubuntu.com/ErrorTracker"
SRC_URI="${UURL}/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libgcrypt
	net-misc/curl
	x11-libs/gtk+:3"

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -e 's:lib/systemd/system:/usr/lib/systemd/system:g' \
		-i Makefile
}
