# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 gnome2-utils autotools git-r3

DESCRIPTION="GTK+ Bluetooth Manager, designed to be simple and intuitive for everyday bluetooth tasks"
HOMEPAGE="http://blueman-project.org/"

EGIT_REPO_URI="https://github.com/${PN}-project/${PN}.git"
KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"
IUSE="gconf network nls policykit pulseaudio"

CDEPEND="dev-libs/glib:2=
	x11-libs/gtk+:3=
	x11-libs/startup-notification:=
	dev-python/dbus-python[${PYTHON_USEDEP}]
	|| (
		dev-python/pygobject:2
		dev-python/pygobject:3
	)
	>=net-wireless/bluez-4.61:=
	${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	nls? ( dev-util/intltool sys-devel/gettext )
	virtual/pkgconfig
	dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	sys-apps/dbus
	x11-themes/hicolor-icon-theme
	gconf? ( dev-python/gconf-python[${PYTHON_USEDEP}] )
	network? ( || ( net-dns/dnsmasq
		net-misc/dhcp
		>=net-misc/networkmanager-0.8 ) )
	policykit? ( sys-auth/polkit )
	pulseaudio? ( media-sound/pulseaudio )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	sed -i \
		-e '/^Encoding/d' \
		data/blueman-manager.desktop.in || die "sed failed"

	epatch "${FILESDIR}/${PN}-9999-plugins-conf-file.patch"
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-nautilus-sendto=no \
		--enable-thunar-sendto=no \
		$(use_enable policykit polkit) \
		$(use_enable nls)
}

src_install() {
	default

	python_fix_shebang "${D}"
	rm "${D}"/$(python_get_sitedir)/*.la || die

	# Note: Python 3 support would need __pycache__ file removal too
	use gconf || { rm "${D}"/$(python_get_sitedir)/${PN}/plugins/config/Gconf.py* || die; }
	use policykit || { rm -rf "${D}"/usr/share/polkit-1 || die; }
	use pulseaudio || { rm "${D}"/$(python_get_sitedir)/${PN}/{main/Pulse*.py*,plugins/manager/Pulse*.py*} || die; }
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
