# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit eutils gnome2-utils meson ubuntu-versionator vala

UVER="+dfsg1"
UVER_SUFFIX="-${PVR_PL_MINOR}"

DESCRIPTION="Global Menu plugin for xfce4 and vala-panel"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel-appmenu"
SRC_URI="${UURL}/${MY_P}${UVER}.orig.tar.xz
	${UURL}/${MY_P}${UVER}${UVER_SUFFIX}.debian.tar.xz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+bamf +vala-panel mate xfce"
REQUIRED_USE="|| ( xfce vala-panel )"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	unity-base/bamf
	mate? ( mate-base/mate-panel )
	vala-panel? ( x11-misc/vala-panel )
	bamf? ( unity-base/bamf )
	xfce? ( >=xfce-base/xfce4-panel-4.11.2 )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext
	$(vala_depend)"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dwm_backend=$(usex bamf auto) \
	)
	meson_src_configure
}

src_install () {
	meson_src_install
	insinto /usr/share/glib-2.0/schemas
	doins ${WORKDIR}/debian/10_mate*
	insinto /etc/profile.d
	doins ${WORKDIR}/debian/vala-panel-appmenu.sh
}

pkg_postinst() {
	gnome2_schemas_update
	ubuntu-versionator_pkg_postinst
}
pkg_postrm() {
	gnome2_schemas_update
}
