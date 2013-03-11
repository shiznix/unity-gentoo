EAPI=4

inherit gnome2 ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="quantal"
GNOME2_LA_PUNT="1"

DESCRIPTION="The greeter (login screen) application for Unity. It is implemented as a LightDM greeter."
HOMEPAGE="https://launchpad.net/unity-greeter"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

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
	x11-themes/ubuntu-wallpapers
	>=gnome-base/gsettings-desktop-schemas-3.6.1"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done

	# kill 'nm-applet' before login the user, otherwise two instances will be run and shown in the try
	# One instance of the user with all settings and the left over instance of the greeter without the chance to
        # make any setting.
	# If someone has a better idea, let me know!
	epatch "${FILESDIR}/kill-nm-applet.patch"

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
        elog "Set ${PN} as default greeter of LightDM"
	elog
	/usr/libexec/lightdm/lightdm-set-defaults --keep-old --greeter=${PN}
}

pkg_postrm() {
	gnome2_schemas_update
}
