# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy-updates"
inherit gnome2-utils meson ubuntu-versionator vala xdg

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test +nautilus"
RESTRICT="mirror test"

COMMON_DEPEND="
	>=app-backup/duplicity-0.7.14
	app-crypt/libsecret[vala]
	>=dev-libs/glib-2.46:2
	dev-libs/json-glib
	dev-libs/libgpg-error
	>=gui-libs/libhandy-1.6
	>=net-libs/gnome-online-accounts-3.8.0
	net-libs/libsoup
	>=x11-libs/gtk+-3.22:3

	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	dev-libs/atk
	gnome-base/dconf
	gnome-base/gvfs[fuse]
	sys-auth/polkit
	x11-libs/pango"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	sys-apps/dbus

	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	$(vala_depend)"

src_prepare() {
	# Make Deja Dup appear in unity-control-center #
	sed -i \
		-e "/Categories/{s/X-GNOME-Utilities/Settings;X-GNOME-SystemSettings;X-Unity-Settings-Panel\nX-Unity-Settings-Panel=deja-dup/}" \
		data/org.gnome.DejaDup.desktop.in

	ubuntu-versionator_src_prepare
	vala_src_prepare
	xdg_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
