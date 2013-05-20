# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2 ubuntu-versionator base

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="raring"
GNOME2_LA_PUNT="1"

DESCRIPTION="The greeter (login screen) application for Unity. It is implemented as a LightDM greeter."
HOMEPAGE="https://launchpad.net/unity-greeter"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="battery networkmanager +branding"
RESTRICT="mirror"

DEPEND="x11-libs/gtk+:3
	dev-libs/libindicator
	>=x11-misc/lightdm-1.4.0
	media-libs/freetype:2
	x11-libs/cairo
	media-libs/libcanberra"

RDEPEND="unity-base/unity-language-pack
	unity-indicators/indicator-session
	unity-indicators/indicator-datetime
	unity-indicators/indicator-sound
	unity-indicators/indicator-application
	battery? ( unity-indicators/indicator-power )
	networkmanager? ( >=gnome-extra/nm-applet-0.9.8.0 )
	media-fonts/ubuntu-font-family
	x11-themes/ubuntu-wallpapers
	>=gnome-base/gsettings-desktop-schemas-3.6.1
	>=app-admin/eselect-lightdm-0.1"

pkg_pretend() {
	if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 && $(gcc-micro-version) -lt 3 ) ]]; then
		die "${P} requires an active >=gcc-4.7.3:4.7, please consult the output of 'gcc-config -l'"
	fi
}

src_prepare() {
#	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"      # This needs to be applied for the debian/ directory to be present #
#	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
#		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
#	done

	# patch 'at-spi-bus-launcher' path
	sed -i -e "s:/usr/lib/at-spi2-core/at-spi-bus-launcher:/usr/libexec/at-spi-bus-launcher:" \
                  "${S}"/src/unity-greeter.vala || die

	# replace 'Ubuntu*' session with 'Unity' session to get right badge
	sed -i -e "s:case \"ubuntu:case \"unity:" "${S}"/src/session-list.vala || die

	# set gentoo badge
	if use branding; then
		sed -i -e "s:ubuntu_badge.png:gentoo_badge.png:" "${S}"/src/session-list.vala || die
	fi

	base_src_prepare
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
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update

	elog
	elog "Set ${PN} as default greeter of LightDM."
	"${ROOT}"/usr/bin/eselect lightdm set unity-greeter

}

pkg_postrm() {
	elog
	elog "Remove ${PN} as default greeter of LightDM"
	/usr/libexec/lightdm/lightdm-set-defaults --remove --greeter=${PN}

	gnome2_schemas_update
}
