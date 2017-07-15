# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

URELEASE="zesty"
inherit autotools eutils gnome2 multilib-minimal ubuntu-versionator

UURL="mirror://unity/pool/main/a/${PN}"

DESCRIPTION="D-Bus accessibility specifications and registration daemon patched for the Unity desktop"
HOMEPAGE="https://wiki.gnome.org/Accessibility"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2+"
SLOT="2"
IUSE="X +introspection"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

# x11-libs/libSM is needed until upstream #719808 is solved either
# making the dep unneeded or fixing their configure
# Only libX11 is optional right now
RDEPEND="
	>=dev-libs/glib-2.36:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

PATCHES=(
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	"${FILESDIR}/${PN}-2.0.2-disable-teamspaces-test.patch"
)

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
	gnome2_src_prepare
}

multilib_src_configure() {
	# xevie is deprecated/broken since xorg-1.6/1.7
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-xevie \
		$(multilib_native_use_enable introspection) \
		$(use_enable X x11)

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		ln -s "${S}"/doc/libatspi/html doc/libatspi/html || die
	fi
}

multilib_src_compile() { gnome2_src_compile; }

multilib_src_install() {
	# Enable QT4 and QT5 accessibility by default #
	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${WORKDIR}/debian/90qt-a11y"

	gnome2_src_install
}
