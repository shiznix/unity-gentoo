# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit autotools eutils ubuntu-versionator vala

UURL="mirror://unity/pool/main/s/${PN}"

DESCRIPTION="Indicator showing active print jobs used by the Unity desktop"
HOMEPAGE="https://launchpad.net/snapd-glib"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-arch/snapd
	dev-libs/glib:2
	dev-libs/json-glib
	net-libs/libsoup
	$(vala_depend)"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	econf \
		--enable-snapd-qt=no \
		--enable-qml-module=no \
		--enable-gtk-doc-html \
		--enable-introspection \
		--enable-vala=yes
}
