# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="disco"
inherit meson ubuntu-versionator vala

UVER="-${PVR_PL_MINOR}"

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="test +nautilus"
RESTRICT="mirror test"

COMMON_DEPEND="
	app-crypt/libsecret[vala]
	dev-libs/libdbusmenu:=
	dev-libs/libunity:=
	dev-libs/glib:2
	dev-libs/libpeas
	unity-base/unity-control-center
	x11-libs/gtk+:3
	x11-libs/libnotify
	>=app-backup/duplicity-0.7.14
	dev-libs/dbus-glib
	nautilus? ( gnome-base/nautilus )"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs[fuse]"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
	$(vala_depend)"

src_prepare() {
	# Make Deja Dup appear in unity-control-center #
	sed -i \
		-e "/Categories/{s/X-GNOME-Utilities/Settings;X-GNOME-SystemSettings;X-Unity-Settings-Panel\nX-Unity-Settings-Panel=deja-dup/}" \
		data/org.gnome.DejaDup.desktop

	ubuntu-versionator_src_prepare
	vala_src_prepare
	rm -v Makefile	# Force Makefile recreation so that 'builddir is correct #
}
