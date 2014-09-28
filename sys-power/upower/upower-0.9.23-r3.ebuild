# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/upower/Attic/upower-0.9.23-r3.ebuild,v 1.4 2014/09/19 17:06:03 ssuominen dead $

EAPI=5
inherit eutils systemd

DESCRIPTION="For hibernate and suspend, use sys-apps/systemd or sys-power/upower-pm-utils"
HOMEPAGE="http://upower.freedesktop.org/"
SRC_URI="http://${PN}.freedesktop.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="doc +introspection ios kernel_FreeBSD kernel_linux"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.22
	sys-apps/dbus
	>=sys-auth/polkit-0.110
	introspection? ( dev-libs/gobject-introspection )
	kernel_linux? (
		virtual/libusb:1
		virtual/libgudev:=
		virtual/udev
		ios? (
			>=app-pda/libimobiledevice-1:=
			>=app-pda/libplist-1:=
			)
		)"
RDEPEND="${COMMON_DEPEND}
	kernel_linux? (
		app-shells/bash
	)"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	dev-util/intltool
	virtual/pkgconfig
	doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2
		)"

QA_MULTILIB_PATHS="usr/lib/${PN}/.*"

DOCS="AUTHORS HACKING NEWS README"

src_prepare() {
	sed -i -e '/DISABLE_DEPRECATED/d' configure || die

	epatch \
		"${FILESDIR}"/${P}-create-dir-runtime.patch \
		"${FILESDIR}"/${P}-fix-segfault.patch \
		"${FILESDIR}"/${P}-clamp_percentage_for_overfull_batt.patch
}

src_configure() {
	local backend myconf

	if use kernel_linux; then
		backend=linux
		myconf="--disable-deprecated"
	elif use kernel_FreeBSD; then
		backend=freebsd
	else
		backend=dummy
	fi

	econf \
		--libexecdir="${EPREFIX}"/usr/lib/${PN} \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable introspection) \
		--disable-static \
		${myconf} \
		--enable-man-pages \
		$(use_enable doc gtk-doc) \
		--disable-tests \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--with-backend=${backend} \
		$(use_with ios idevice) \
		"$(systemd_with_utildir)" \
		"$(systemd_with_unitdir)"
}

src_install() {
	default
	keepdir /var/lib/upower #383091
	prune_libtool_files
}
