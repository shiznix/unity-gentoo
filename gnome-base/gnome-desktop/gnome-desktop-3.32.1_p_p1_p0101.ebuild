# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="disco-security"
inherit gnome2 meson ubuntu-versionator

MY_PN="${PN}3"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI patched for the Unity desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-desktop"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/12" # subslot = libgnome-desktop-3 soname version
IUSE="debug +introspection udev"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.58.0:2[dbus]
	>=x11-libs/gdk-pixbuf-2.36.5:2[introspection?]
	>=x11-libs/gtk+-3.24.0:3[X,introspection?]
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.28.0
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
	udev? (
		sys-apps/hwids
		virtual/libudev:= )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-desktop-2.32.1-r1:2[doc]
	app-i18n/ibus
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.6
	dev-util/itstool
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig
"

src_prepare() {
	ubuntu-versionator_src_prepare
	gnome2_src_prepare
}

meson_use_enable() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

src_configure() {
	local emesonargs=(
		-Dgnome_distributor=Gentoo
		$(meson_use debug debug_tools)
		$(meson_use_enable udev)
	)
	meson_src_configure
}
