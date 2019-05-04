# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools meson ubuntu-versionator

DESCRIPTION="Solus Project's Brisk Menu MATE Panel Applet"
HOMEPAGE="https://github.com/solus-project/brisk-menu"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-perl/XML-Parser
	dev-util/intltool
	gnome-base/dconf
	mate-base/mate-panel
	sys-devel/gettext
	x11-libs/gtk+:3"

src_install() {
	meson_src_install
	# Delete some files that are only useful on Ubuntu
	rm -rf "${D}"etc/apport
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
}
