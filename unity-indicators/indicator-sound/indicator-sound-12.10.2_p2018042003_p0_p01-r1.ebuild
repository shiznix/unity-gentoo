# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit cmake-utils gnome2-utils ubuntu-versionator vala

UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="System sound indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-sound"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="sys-auth/polkit-pkla-compat
	unity-base/gsettings-ubuntu-touch-schemas"
DEPEND="${RDEPEND}
	sys-apps/accountsservice
	dev-libs/libappindicator
	dev-libs/libgee:0.8
	dev-libs/libdbusmenu:=
	dev-libs/libqtdbusmock
	dev-libs/libqtdbustest
	dev-util/dbus-test-runner
	media-sound/pulseaudio
	unity-base/bamf:=
	unity-base/unity-api
	unity-indicators/ido:=
	>=x11-libs/libnotify-0.7.6
	$(vala_depend)"

S="${WORKDIR}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Disable url-dispatcher when not using unity8-desktop-session
	eapply "${FILESDIR}/disable-url-dispatcher.diff"

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs+=(-DCMAKE_INSTALL_LOCALSTATEDIR=/var
		-DVALA_COMPILER=$VALAC
		-DVAPI_GEN=$VAPIGEN
		-DCMAKE_INSTALL_FULL_DATADIR=/usr/share)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	find "${ED}" -name "*.pkla" -exec chown root:polkitd {} \;
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
