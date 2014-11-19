# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/gnome-terminal/Attic/gnome-terminal-3.10.2.ebuild,v 1.7 2014/11/13 12:42:16 pacho dead $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 readme.gentoo

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="https://help.gnome.org/users/gnome-terminal/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+nautilus"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"

# FIXME: automagic dependency on gtk+[X]
RDEPEND="
	>=dev-libs/glib-2.33.2:2
	>=x11-libs/gtk+-3.6:3[X]
	>=x11-libs/vte-0.34.9:2.90
	>=gnome-base/dconf-0.12
	>=gnome-base/gconf-2.31.3
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	sys-apps/util-linux
	x11-libs/libSM
	x11-libs/libICE
	nautilus? ( >=gnome-base/nautilus-3 )
"
# gtk+:2 needed for gtk-builder-convert, bug 356239
DEPEND="${RDEPEND}
	|| ( dev-util/gtk-builder-convert <=x11-libs/gtk+-2.24.10:2 )
	>=dev-util/intltool-0.40
	>=gnome-base/dconf-0.14.0
	sys-devel/gettext
	virtual/pkgconfig
"

DOC_CONTENTS="To get previous working directory inherited in new opened
	tab you will need to add the following line to your ~/.bashrc:\n
	. /etc/profile.d/vte.sh"

src_prepare() {
	# patch from 3.12, fixes buld on non-glibc systems
	epatch "${FILESDIR}/${PN}-3.10.2-sys-wait.h.patch"

	gnome2_src_prepare
}

src_configure() {
	# FIXME: leave smclient configure unset until it accepts values from the
	# switch and not from GDK_TARGET, bug #363033
	gnome2_src_configure \
		--disable-static \
		--enable-migration \
		$(use_with nautilus nautilus-extension) \
		ITSTOOL=$(type -P true)
}

src_install() {
	DOCS="AUTHORS ChangeLog HACKING NEWS"
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	if [[ ${REPLACING_VERSIONS} < 3.6.1-r1 && ${REPLACING_VERSIONS} != 2.32.1-r1 &&
		  ${REPLACING_VERSIONS} != 3.4.1.1-r1 ]]; then
		elog
		elog "Gnome Terminal no longer uses login shell by default, switching"
		elog "to upstream default. Because of this, if you have some command you"
		elog "want to be run, be sure to have it placed in your ~/.bashrc file."
		elog
	fi
	readme.gentoo_print_elog
}
