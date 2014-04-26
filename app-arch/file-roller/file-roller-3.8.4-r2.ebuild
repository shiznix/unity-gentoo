# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/file-roller/file-roller-3.8.4-r2.ebuild,v 1.4 2014/02/20 07:12:55 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 readme.gentoo

DESCRIPTION="Archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
IUSE="nautilus packagekit"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

# gdk-pixbuf used extensively in the source
# cairo used in eggtreemultidnd.c
# pango used in fr-window
RDEPEND="
	>=app-arch/libarchive-3:=
	>=dev-libs/glib-2.29.14:2
	>=dev-libs/json-glib-0.14
	>=x11-libs/gtk+-3.6:3
	>=x11-libs/libnotify-0.4.3:=
	sys-apps/file
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/pango
	nautilus? ( >=gnome-base/nautilus-3 )
	packagekit? ( app-admin/packagekit-base )
"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#	gnome-base/gnome-common

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
${PN} is a frontend for several archiving utilities. If you want a
particular archive format support, see ${HOMEPAGE}
and install the relevant package. For example:
7-zip   - app-arch/p7zip
ace     - app-arch/unace
arj     - app-arch/arj
cpio    - app-arch/cpio
deb     - app-arch/dpkg
iso     - app-cdr/cdrtools
jar,zip - app-arch/zip and app-arch/unzip
lha     - app-arch/lha
lzop    - app-arch/lzop
rar     - app-arch/unrar or app-arch/unar
rpm     - app-arch/rpm
unstuff - app-arch/stuffit
zoo     - app-arch/zoo"

src_prepare() {
	# Use absolute path to GNU tar since star doesn't have the same
	# options. On Gentoo, star is /usr/bin/tar, GNU tar is /bin/tar
	epatch "${FILESDIR}"/${PN}-2.10.3-use_bin_tar.patch

	# app-arch/{un,}rar-5 support, https://bugzilla.gnome.org/show_bug.cgi?id=707568
	epatch "${FILESDIR}"/${PN}-3.8.4-rar-5.patch

	# libarchive: fixed failure when extracting some tar archives
	epatch "${FILESDIR}"/${PN}-3.8.4-extract-failure.patch

	# libarchive: restore the folders modification time correctly
	epatch "${FILESDIR}"/${PN}-3.8.4-modifications-time.patch

	# Ignore errors when setting file attributes
	epatch "${FILESDIR}"/${PN}-3.8.4-ignore-errors.patch

	# File providing Gentoo package names for various archivers
	cp -f "${FILESDIR}/3.6.0-packages.match" data/packages.match || die

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README* TODO"
	# --disable-debug because enabling it adds -O0 to CFLAGS
	gnome2_src_configure \
		--disable-run-in-place \
		--disable-static \
		--disable-debug \
		--enable-magic \
		--enable-libarchive \
		--with-smclient=xsmp \
		$(use_enable nautilus nautilus-actions) \
		$(use_enable packagekit) \
		ITSTOOL=$(type -P true)
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
