# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lightdm/lightdm-1.4.0-r1.ebuild,v 1.3 2013/03/02 23:49:52 hwoarang Exp $

EAPI=5
inherit base eutils pam readme.gentoo ubuntu-versionator user autotools

UURL="mirror://ubuntu/pool/main/l/${PN}"
URELEASE="raring-updates"

DESCRIPTION="A lightweight display manager"

HOMEPAGE="https://launchpad.net/lightdm"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"


IUSE_LIGHTDM_GREETERS="gtk unity kde razor"
for greeters in ${IUSE_LIGHTDM_GREETERS}; do
        IUSE+=" lightdm_greeters_${greeters}"
done

IUSE+=" +introspection qt4"

RESTRICT="mirror"

COMMON_DEPEND=">=dev-libs/glib-2.32.3:2
	dev-libs/libxml2
	sys-apps/accountsservice
	virtual/pam
	x11-libs/libX11
	>=x11-libs/libxklavier-5
	introspection? ( >=dev-libs/gobject-introspection-1 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		)"
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/pambase-20101024-r2
	x11-apps/xrandr
	app-admin/eselect-lightdm"

DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig"

PDEPEND="lightdm_greeters_gtk? ( x11-misc/lightdm-gtk-greeter )
	lightdm_greeters_kde? ( x11-misc/lightdm-kde )
	lightdm_greeters_razor? ( razorqt-base/razorqt-lightdm-greeter )
	lightdm_greeters_unity? ( unity-extra/unity-greeter )"

DOCS=( NEWS )

pkg_pretend() {
	if [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) || \
			( [[ $(gcc-version) == "4.7" && $(gcc-micro-version) -lt 3 ]] ); then
				die "${P} requires an active >=gcc-4.7.3, please consult the output of 'gcc-config -l'"
	fi
}

pkg_setup() {
        if [ -z "${LIGHTDM_GREETERS}" ]; then
		ewarn " "
                ewarn "At least one GREETER should be set in /etc/make.conf"
		ewarn " "
        fi
}

src_prepare() {
	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	# use startup script to stop dbus of lightdm when user session starts
	epatch "${FILESDIR}"/03_launch_dbus.patch

	# sets language setting of user session
	epatch "${FILESDIR}"/${PN}-${PV%%_p*}-fix-language-setting.patch

	# use system default language in greeter
	epatch "${FILESDIR}"/${PN}-${PV%%_p*}-make-sessions-inherit-system-default-locale.patch

#	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
#		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
#	done

	epatch_user

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
		$(use_enable introspection) \
		$(use_enable qt4 liblightdm-qt) \
		--enable-liblightdm-qt5=no \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

pkg_preinst() {
	enewgroup lightdm || die "problem adding 'lightdm' group"
	enewgroup video
	enewuser lightdm -1 -1 /var/lib/lightdm lightdm,video || die "problem adding 'lightdm' user"
}

src_install() {
	default

	insinto /etc/${PN}
	doins data/keys.conf
	newins data/${PN}.conf ${PN}.conf_example
	doins "${FILESDIR}"/${PN}.conf
	doins "${FILESDIR}"/Xsession
	fperms +x /etc/${PN}/Xsession

	# script for lauching greeter sessions itself
	# fixes problems with additional (2nd) nm-applet and
	# setting icon themes in Unity desktop
	doins "${FILESDIR}"/lightdm-greeter-session
	fperms +x /etc/${PN}/lightdm-greeter-session

	# script makes lightdm multi monitor sessions aware
	# and enable first display as primary output
	# all other monitors are aranged right of it in a row
	#
	# on 'unity-greeter' the login prompt will follow the mouse cursor
	#
	doins "${FILESDIR}"/lightdm-greeter-display-setup
	fperms +x /etc/${PN}/lightdm-greeter-display-setup

	prune_libtool_files --all
	rm -rf "${ED}"/etc/init

	pamd_mimic system-local-login ${PN} auth account session #372229
	dopamd "${FILESDIR}"/${PN}-autologin #390863, #423163

	readme.gentoo_create_doc
}
