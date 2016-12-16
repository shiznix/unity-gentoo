# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety-updates"
inherit cmake-utils gnome2 ubuntu-versionator vala

UURL="mirror://unity/pool/main/d/${PN}"

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	app-backup/duplicity
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
	ubuntu-versionator_src_prepare
	sed -e '/RPATH/s:PKG_LIBEXECDIR:PKG_LIBDIR:g' \
		-i CMakeLists.txt || die

	# If a .desktop file does not have inline translations, fall back #
	#  to calling gettext #
	find ${WORKDIR} -type f -name "*.desktop*" \
		-exec sh -c 'sed -i -e "/\[Desktop Entry\]/a X-GNOME-Gettext-Domain=${PN}" "$1"' -- {} \;

	vala_src_prepare
	gnome2_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_EXECUTABLE="${VALAC}"
		-DENABLE_CCPANEL=ON
		-DENABLE_PK=OFF
		-DENABLE_UNITY=ON
		-DENABLE_UNITY_CCPANEL=ON
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc
		-DENABLE_NAUTILUS="$(usex nautilus)"
		-DENABLE_TESTING="$(usex test)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
