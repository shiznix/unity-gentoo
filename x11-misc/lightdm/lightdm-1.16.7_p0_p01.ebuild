# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="wily-updates"
inherit autotools base eutils pam readme.gentoo systemd user ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/l/${PN}"

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
IUSE+=" +lightdm_greeters_unity +introspection qt4 qt5 mir test"
RESTRICT="mirror"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	sys-apps/accountsservice
	sys-libs/pam[audit]
	x11-libs/libX11
	>=x11-libs/libxklavier-5
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

	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	# Do not depend on Debian/Ubuntu specific adduser package
	epatch "${FILESDIR}"/guest-session-cross-distro_1.12.3.patch

	# Add support for settings GSettings/dconf defaults in the guest session. Just
	# put the files in /etc/guest-session/gsettings/. The file format is the same
	# as the regular GSettings override files.
	epatch "${FILESDIR}"/guest-session-add-default-gsettings-support_1.11.5.patch

	epatch_user
	base_src_prepare
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
	# sys-libs/pam[audit] must be installed and '--enable-audit' specified or else build will fail #
	#  session-child.c:420:26: error: ‘AUDIT_USER_LOGIN’ undeclared (first use in this function)  #
	econf \
		--localstatedir=/var \
		--disable-static \
		--enable-audit \
		--enable-vala \
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
	doins "${FILESDIR}"/50-session-wrapper.conf		# Executes custom Xsession
	doins debian/50-greeter-wrapper.conf			# Executes lightdm-greeter-session

	exeinto /usr/lib/${PN}
	doexe debian/lightdm-greeter-session			# Handle extraneous dbus processes (eliminates 2nd nm-applet icon)
	doexe "${FILESDIR}"/Xsession

	# script makes lightdm multi monitor sessions aware
	# and enable first display as primary output
	# all other monitors are aranged right of it in a row
	#
	# on 'unity-greeter' the login prompt will follow the mouse cursor
	#
	doexe "${FILESDIR}"/lightdm-greeter-display-setup	# Handle multi-monitor setups

	# install guest-account script
	insinto /usr/bin
	newins debian/guest-account.sh guest-account || die
	fperms +x /usr/bin/guest-account

	# Create GSettings defaults directory
	insinto /etc/guest-session/gsettings/

	# Install systemd tmpfiles.d file
	insinto /usr/lib/tmpfiles.d
	newins "${FILESDIR}"/${PN}.tmpfiles.d ${PN}.conf || die

	# Install PolicyKit rules from Fedora which allow the lightdm user to access
	# the systemd-logind, consolekit, and upower DBus interfaces
	insinto /usr/share/polkit-1/rules.d
	newins "${FILESDIR}"/${PN}.rules ${PN}.rules || die

	prune_libtool_files --all
	rm -rf "${ED}"/etc/init

	pamd_mimic system-local-login ${PN} auth account session #372229
	dopamd "${FILESDIR}"/${PN}-autologin #390863, #423163

	readme.gentoo_create_doc

	systemd_dounit "${FILESDIR}/${PN}.service"

	# Create data directory
	dodir /var/lib/${PN}-data
}

pkg_postinst() {
	if use mir; then
		elog "'mir' useflag is enabled. If lightdm should fail to work, first try disabling the use of Mir display server"
		elog " by setting 'type=unity;xlocal' to 'type=xlocal' in /etc/lightdm/lightdm.conf.d/10-unity-system-compositor.conf"
		elog
	fi
	elog "'guest session' is disabled by default."
	elog "To enable guest session edit '/etc/${PN}/${PN}.conf'"
}
