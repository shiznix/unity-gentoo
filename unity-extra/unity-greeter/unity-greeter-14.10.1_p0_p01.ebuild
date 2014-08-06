# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
VALA_MIN_API_VERSION="0.24"
VALA_MAX_API_VERSION="0.24"

inherit autotools flag-o-matic gnome2 ubuntu-versionator base vala

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="utopic"

DESCRIPTION="The greeter (login screen) application for Unity. It is implemented as a LightDM greeter."
HOMEPAGE="https://launchpad.net/unity-greeter"
SRC_URI="${UURL}/${MY_P}-${UVER}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"

IUSE="accessibility battery +branding networkmanager nls"
RESTRICT="mirror"

DEPEND="dev-libs/libindicator
	gnome-base/gnome-desktop:3=
	media-libs/freetype:2
	media-libs/libcanberra
	unity-base/unity-settings-daemon
	unity-indicators/ido
	x11-libs/cairo
	x11-libs/gtk+:3
	>=x11-misc/lightdm-1.4.0
	$(vala_depend)"

RDEPEND="accessibility? ( app-accessibility/onboard
			app-accessibility/orca )
	battery? ( unity-indicators/indicator-power )
	networkmanager? ( >=gnome-extra/nm-applet-0.9.8.0 )
	>=app-admin/eselect-lightdm-0.1
	>=gnome-base/gsettings-desktop-schemas-3.8
	media-fonts/ubuntu-font-family
	unity-base/unity-language-pack
	unity-indicators/indicator-session
	unity-indicators/indicator-datetime
	unity-indicators/indicator-sound
	unity-indicators/indicator-application
	x11-themes/ubuntu-wallpapers"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 && $(gcc-micro-version) -lt 3 ) ]]; then
		die "${P} requires an active >=gcc-4.7.3, please consult the output of 'gcc-config -l'"
	fi
}

src_prepare() {
	epatch -p1 "${FILESDIR}/spawn_indicators.patch"

	# patch 'at-spi-bus-launcher' path
	sed -i -e "s:/usr/lib/at-spi2-core/at-spi-bus-launcher:/usr/libexec/at-spi-bus-launcher:" \
                  "${S}"/src/unity-greeter.vala || die

	# replace 'Ubuntu*' session with 'Unity' session to get right badge
	sed -i -e "s:case \"ubuntu:case \"unity:" "${S}"/src/session-list.vala || die

	# set gentoo badge
	if use branding; then
		sed -i -e "s:ubuntu_badge.png:gentoo_badge.png:" "${S}"/src/session-list.vala || die
	fi

	vala_src_prepare
	base_src_prepare
	append-cflags -Wno-error
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	gnome2_src_install

	# Remove all installed language files as they can be incomplete #
	# due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	# Remove Ubuntu logo -> would be nice, if we can replace it with a gentoo logo
	rm -rf "${ED}usr/share/unity-greeter/logo.png"

	# Gentoo logo for multi monitor usage #
        if use branding; then
                insinto /usr/share/unity-greeter/
                newins "${FILESDIR}/gentoo_cof.png" cof.png
        fi

	insinto /usr/share/unity-greeter/
	newins "${FILESDIR}/gentoo_badge.png" gentoo_badge.png

	insinto /usr/share/polkit-1/rules.d/
	newins "${FILESDIR}/50-unity-greeter.rules" 50-unity-greeter.rules || die

	exeinto /usr/bin
	doexe "${FILESDIR}/unity-greeter-indicators-start"
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update

	elog
	elog "Setting ${PN} as default greeter of LightDM."
	"${ROOT}"/usr/bin/eselect lightdm set unity-greeter

	elog "Setting 'unity' as default user session."
	if line=$(grep -s -m 1 -e "user-session" "/etc/lightdm/lightdm.conf"); then
		sed -i -e "s/user-session=.*/user-session=unity/" "/etc/lightdm/lightdm.conf"
	else
		echo "user-session=unity" >> "${EROOT}/etc/lightdm/lightdm.conf"
	fi
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	if [ -e /usr/libexec/lightdm/lightdm-set-defaults ]; then
		elog
		elog "Remove ${PN} as default greeter of LightDM"
		/usr/libexec/lightdm/lightdm-set-defaults --remove --greeter=${PN}
		/usr/libexec/lightdm/lightdm-set-defaults --remove --session=unity
	fi

	gnome2_schemas_update
}
