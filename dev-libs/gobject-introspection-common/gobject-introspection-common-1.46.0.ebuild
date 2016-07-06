# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME_ORG_MODULE="gobject-introspection"

URELEASE="xenial"
inherit ubuntu-versionator gnome.org

UVER="-3ubuntu1"

DESCRIPTION="Build infrastructure for GObject Introspection"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="!<${CATEGORY}/${PN/-common}-${PV}"
# Use !<${PV} because mixing gobject-introspection with different version of -common can cause issues like:
# https://forums.gentoo.org/viewtopic-p-7421930.html

src_configure() { :; }

src_compile() { :; }

src_install() {
	dodir /usr/share/aclocal
	insinto /usr/share/aclocal
	doins m4/introspection.m4

	dodir /usr/share/gobject-introspection-1.0
	insinto /usr/share/gobject-introspection-1.0
	doins Makefile.introspection
}
