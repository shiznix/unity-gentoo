# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
VALA_MIN_API_VERSION="0.24"
VALA_MAX_API_VERSION="0.24"

URELEASE="wily"
inherit autotools flag-o-matic gnome2 ubuntu-versionator base vala

UURL="mirror://ubuntu/pool/main/u/${PN}"

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
	>=app-eselect/eselect-lightdm-0.1
	>=gnome-base/gsettings-desktop-schemas-3.8
	media-fonts/ubuntu-font-family
	sys-auth/polkit-pkla-compat
	unity-base/unity-language-pack
	unity-indicators/indicator-session
	unity-indicators/indicator-datetime
	unity-indicators/indicator-sound
	unity-indicators/indicator-application
	x11-themes/ubuntu-wallpapers"

src_prepare() {
	# patch 'at-spi-bus-launcher' path
	sed -i -e "s:/usr/lib/at-spi2-core/at-spi-bus-launcher:/usr/libexec/at-spi-bus-launcher:" \
                  "${S}"/src/unity-greeter.vala || die

	# replace 'Ubuntu*' session with 'Unity' session to get right badge
	sed -i -e "s:case \"ubuntu:case \"unity:" "${S}"/src/session-list.vala || die

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

	# Remove Ubuntu logo #
	rm -rf "${ED}usr/share/unity-greeter/logo.png"

	# Gentoo logo for multi monitor usage #
	if use branding; then
		insinto /usr/share/unity-greeter
		newins "${FILESDIR}/gentoo_cof.png" cof.png
	fi

	# Install polkit privileges config #
	insinto /var/lib/polkit-1/localauthority/10-vendor.d
	doins debian/unity-greeter.pkla
	fowners root:polkitd /var/lib/polkit-1/localauthority/10-vendor.d/unity-greeter.pkla
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
		elog "Removing ${PN} as default greeter of LightDM"
		/usr/libexec/lightdm/lightdm-set-defaults --remove --greeter=${PN}
		/usr/libexec/lightdm/lightdm-set-defaults --remove --session=unity
	fi

	gnome2_schemas_update
}
