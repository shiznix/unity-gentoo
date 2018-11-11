# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.34"
VALA_MAX_API_VERSION="0.36"

URELEASE="cosmic"
inherit cmake-utils eutils gnome2-utils ubuntu-versionator vala

UVER="+dfsg1"
UVER_SUFFIX="-${PVR_PL_MINOR}"

DESCRIPTION="Lightweight desktop panel"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel"
SRC_URI="${UURL}/${MY_P}${UVER}.orig.tar.xz"

LICENSE="LGPL-3"
#KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+wnck +X"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=dev-libs/libpeas-1.2.0
	X? ( x11-libs/libX11 )
	wnck? ( >=x11-libs/libwnck-3.4.0:3 )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext
	$(vala_depend)"

GNOME2_ECLASS_GLIB_SCHEMAS="org.valapanel.gschema.xml"

src_prepare() {
	ubuntu-versionator_src_prepare
	vala_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWNCK=$(usex wnck)
		-DX11=$(usex X)
		-DGSETTINGS_COMPILE=OFF
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DVALA_EXECUTABLE="${VALAC}"
	)
	cmake-utils_src_configure
}

src_install () {
	cmake-utils_src_install
}

pkg_postinst() {
	ubuntu-versionator_pkg_postinst
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}
