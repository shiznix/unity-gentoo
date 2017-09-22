# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit cmake-utils gnome2-utils ubuntu-versionator vala

UURL="mirror://unity/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Date and Time Indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-datetime"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+eds"
RESTRICT="mirror"

COMMON_DEPEND="
	dev-libs/libaccounts-glib
	dev-libs/libdbusmenu:=
	dev-libs/libtimezonemap:=
	media-libs/gstreamer:1.0
	sys-apps/util-linux
	unity-indicators/ido:=
	unity-indicators/indicator-messages
	>=x11-libs/libnotify-0.7.6

	eds? ( gnome-extra/evolution-data-server:= )"

RDEPEND="${COMMON_DEPEND}
	unity-base/unity-language-pack"
DEPEND="${COMMON_DEPEND}
	dev-libs/properties-cpp"
# PDEPEND to avoid circular dependency
PDEPEND="unity-base/unity-control-center"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare

	# Fix schema errors and sandbox violations #
	eapply "${FILESDIR}/sandbox_violations_fix.diff"

	eapply "${FILESDIR}/01-${PN}-add-custom-deps.patch"
	eapply "${FILESDIR}/02-${PN}-remove-url-dispatcher.patch"
	eapply "${FILESDIR}/02-${PN}-optional-eds.patch"

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN
		-DCMAKE_INSTALL_FULL_LOCALEDIR=/usr/share/locale
		-DWITH_EDS="$(usex eds)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}

pkg_preinst() {
        gnome2_schemas_savelist
        gnome2_icon_savelist
}
pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
