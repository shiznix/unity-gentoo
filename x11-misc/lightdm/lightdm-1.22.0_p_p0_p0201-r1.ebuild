# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty-security"
inherit autotools eutils pam readme.gentoo-r1 systemd user ubuntu-versionator vala

UURL="mirror://unity/pool/main/l/${PN}"

DESCRIPTION="A lightweight display manager"
HOMEPAGE="https://launchpad.net/lightdm"
SRC_URI="${UURL}/${MY_P}-${UVER}.tar.gz"
#	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE_LIGHTDM_GREETERS="gtk kde"
for greeters in ${IUSE_LIGHTDM_GREETERS}; do
	IUSE+=" lightdm_greeters_${greeters}"
done

# add and enable 'unity' greeter by default
IUSE+=" +lightdm_greeters_unity audit +introspection qt4 qt5 mir test"
RESTRICT="mirror"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	sys-apps/accountsservice
	sys-libs/pam
	x11-libs/libX11
	>=x11-libs/libxklavier-5
	audit? ( sys-process/audit )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	mir? ( mir-base/unity-system-compositor )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		)"
RDEPEND="${COMMON_DEPEND}
	sys-auth/pambase
	x11-apps/xrandr
	>=app-eselect/eselect-lightdm-0.2"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	$(vala_depend)"
PDEPEND="lightdm_greeters_gtk? ( x11-misc/lightdm-gtk-greeter )
	lightdm_greeters_kde? ( x11-misc/lightdm-kde )
	lightdm_greeters_unity? ( unity-extra/unity-greeter )"
DOCS=( NEWS )

pkg_setup() {
	ubuntu-versionator_pkg_setup
	if [ -z "${LIGHTDM_GREETERS}" ]; then
		ewarn "At least one GREETER should be set in /etc/make.conf"
	fi
}

src_prepare() {
#	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	# Add support for settings GSettings/dconf defaults in the guest session. Just
	# put the files in /etc/guest-session/gsettings/. The file format is the same
	# as the regular GSettings override files.
	epatch "${FILESDIR}"/guest-session-add-default-gsettings-support_1.22.0.patch

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	# Remove bogus Makefile statement. This needs to go upstream
	sed -i /"@YELP_HELP_RULES@"/d help/Makefile.am || die

	if has_version dev-libs/gobject-introspection; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi
}

src_configure() {
	econf \
		--localstatedir=/var \
		--disable-static \
		--enable-vala \
		$(use_enable audit libaudit) \
		$(use_enable introspection) \
		$(use_enable qt4 liblightdm-qt) \
		$(use_enable qt5 liblightdm-qt5) \
		$(use_enable test tests) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

pkg_preinst() {
	enewgroup lightdm || die "problem adding 'lightdm' group"
	enewgroup video
	enewgroup vboxguest
	enewuser lightdm -1 -1 /var/lib/lightdm "lightdm,video,vboxguest" || die "problem adding 'lightdm' user"
}

src_install() {
	default

	# Delete apparmor profiles because they only work with Ubuntu's
	# apparmor package. Bug #494426
	if [[ -d ${D}/etc/apparmor.d ]]; then
		rm -r "${D}/etc/apparmor.d" || die \
			"Failed to remove apparmor profiles"
	fi

	insinto /etc/${PN}
	doins data/keys.conf
	newins data/${PN}.conf ${PN}.conf_example
	doins "${FILESDIR}"/${PN}.conf

	insinto /etc/${PN}/${PN}.conf.d
	doins "${FILESDIR}"/50-display-setup.conf		# Executes lightdm-greeter-display-setup
	doins debian/50-greeter-wrapper.conf			# Executes lightdm-greeter-session

	exeinto /usr/lib/${PN}
	doexe debian/lightdm-greeter-session                    # Handle extraneous dbus processes (eliminates 2nd nm-applet icon)
	# script makes lightdm multi monitor sessions aware
	# and enable first display as primary output
	# all other monitors are aranged right of it in a row
	#
	# on 'unity-greeter' the login prompt will follow the mouse cursor
	#
	doexe "${FILESDIR}"/lightdm-greeter-display-setup       # Handle multi-monitor setups

	exeinto /usr/sbin
	newexe "${FILESDIR}"/Xsession lightdm-session		# Install our custom Xsession as /usr/sbin/lightdm-session

	# install guest-account script
	exeinto /usr/bin
	newexe debian/guest-account.sh guest-account || die
	# to work the script properly
	exeinto /usr/share/lightdm/guest-session
	doexe "${FILESDIR}"/setup.sh
	dodir /usr/share/lightdm/guest-session/skel

	# Add guest session GSettings defaults
	g_settings_path="/etc/guest-session/gsettings/"
	insinto ${g_settings_path}
	doins "${FILESDIR}"/99_default.gschema.override

	# Install systemd tmpfiles.d file
	insinto /usr/lib/tmpfiles.d
	newins "${FILESDIR}"/${PN}.tmpfiles.d ${PN}.conf || die

	# Install PolicyKit rules from Fedora which allow the lightdm user to access
	# the systemd-logind, consolekit, and upower DBus interfaces
	insinto /usr/share/polkit-1/rules.d
	newins "${FILESDIR}"/${PN}.rules ${PN}.rules || die

	prune_libtool_files --all
	rm -rf "${ED}"/etc/init

        # Remove existing pam file. We will build a new one. Bug #524792
        rm -rf "${ED}"/etc/pam.d/${PN}{,-greeter}
        pamd_mimic system-local-login ${PN} auth account password session #372229
        pamd_mimic system-local-login ${PN}-greeter auth account password session #372229
        dopamd "${FILESDIR}"/${PN}-autologin #390863, #423163

	readme.gentoo_create_doc
	systemd_dounit "${FILESDIR}/${PN}.service"

	# Create data directory
	dodir /var/lib/${PN}-data
}

pkg_postinst() {
	elog
	elog "Guest session is disabled by default."
	elog "To enable it edit '/etc/${PN}/${PN}.conf'"
	elog "and set 'allow-guest=true'."
	elog
	elog "Guest session GSettings defaults can be"
	elog "found in '${g_settings_path}'."
	elog "You can place your settings over here."
	elog "Higher numbered files have higher priority."
	elog
}
