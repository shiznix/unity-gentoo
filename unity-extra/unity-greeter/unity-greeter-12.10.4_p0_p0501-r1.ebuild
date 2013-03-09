EAPI=4

inherit gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="The greeter (login screen) application for Unity. It is implemented as a LightDM greeter."
HOMEPAGE="https://launchpad.net/unity-greeter"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="x11-libs/gtk+:3
        dev-libs/libindicator
	>=x11-misc/lightdm-1.3.3
	media-libs/freetype:2
	x11-libs/cairo
	media-libs/libcanberra"

RDEPEND="unity-base/unity-language-pack
	unity-base/indicator-session
	unity-base/indicator-datetime
	unity-base/indicator-sound
	unity-base/indicator-application
	unity-extra/indicator-power
	media-fonts/ubuntu-font-family
	x11-themes/ubuntu-wallpapers"

src_prepare() {
#apply patches
	PV=${PV%%_p*}
	epatch "${FILESDIR}/${PV}/move-nm-applet.patch"
	epatch "${FILESDIR}/${PV}/do-not-mention-citrix-support.patch"
	epatch "${FILESDIR}/${PV}/sigterm-onboard.patch"
	epatch "${FILESDIR}/${PV}/close-orca.patch"
	epatch "${FILESDIR}/${PV}/do-not-read-password.patch"
	epatch "${FILESDIR}/${PV}/fix-timed-autologin.patch"
	epatch "${FILESDIR}/${PV}/fix-corruption.patch"

#patch 'at-spi-bus-launcher' path
	sed -i -e "s:/usr/lib/at-spi2-core/at-spi-bus-launcher:/usr/libexec/at-spi-bus-launcher:" \
                        "${S}"/src/unity-greeter.vala || die
}

src_install() {
        gnome2_src_install

        # Remove all installed language files as they can be incomplete #
        # due to being provided by Ubuntu's language-pack packages #
        rm -rf ${ED}usr/share/locale

	# Remove Ubuntu logo -> would be nice, if we can replace it with a gentoo logo
	rm -rf ${ED}usr/share/unity-greeter/logo.png
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
        elog
        elog "Don't forget to set 'greeter-session=${PN}' in [SeatDefaults] section in /etc/lightdm/lightdm.conf"
	elog
}

pkg_postrm() {
	gnome2_schemas_update
}
