# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lightdm/lightdm-1.4.0-r1.ebuild,v 1.3 2013/03/02 23:49:52 hwoarang Exp $

EAPI=5
inherit autotools eutils pam readme.gentoo ubuntu-versionator base

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l/${PN}"
URELEASE="Raring"

DESCRIPTION="A lightweight display manager"

HOMEPAGE="https://launchpad.net/lightdm"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
        ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.debian.tar.gz"


LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection gtk +unity kde qt4 razor"
REQUIRED_USE="|| ( unity gtk kde razor )"
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
	>=sys-auth/pambase-20101024-r2"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig"
PDEPEND="gtk? ( x11-misc/lightdm-gtk-greeter )
	kde? ( x11-misc/lightdm-kde )
	razor? ( razorqt-base/razorqt-lightdm-greeter )
	unity? ( unity-extra/unity-greeter )"

DOCS=( NEWS )

pkg_pretend() {
        if [[ ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 && $(gcc-micro-version) -lt 3 ) ]]; then
                die "${P} requires an active >=gcc-4.7.3:4.7, please consult the output of 'gcc-config -l'"
        fi
}

src_prepare() {
	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	epatch "${FILESDIR}"/session-wrapper-${PN}.patch

	sed -i '/03_launch_dbus.patch/d' "${WORKDIR}/debian/patches/series" || die
	sed -i '/04_language_options.patch/d' "${WORKDIR}/debian/patches/series" || die

        for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v '#'); do
                PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
        done
	base_src_prepare

	# Remove bogus Makefile statement. This needs to go upstream
	sed -i /"@YELP_HELP_RULES@"/d help/Makefile.am || die
	if has_version dev-libs/gobject-introspection; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi
}

src_configure() {
	# Set default values if global vars unset
	local _greeter _session _user
	_greeter=${LIGHTDM_GREETER:=lightdm-gtk-greeter}
	_session=${LIGHTDM_SESSION:=gnome}
	_user=${LIGHTDM_USER:=lightdm}
	# Let user know how lightdm is configured
	einfo "Gentoo configuration"
	einfo "Default greeter: ${_greeter}"
	einfo "Default session: ${_session}"
	einfo "Greeter user: ${_user}"

	econf \
		--localstatedir=/var \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable qt4 liblightdm-qt) \
		--with-user-session=${_session} \
		--with-greeter-session=${_greeter} \
		--with-greeter-user=${_user} \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

pkg_preinst() {
	enewgroup lightdm die "problem adding 'lightdm' group"
	enewgroup video
	enewuser lightdm -1 -1 /var/lib/lightdm lightdm,video || die "problem adding 'lightdm' user"
}

src_install() {
	default

	insinto /etc/${PN}
	doins data/{${PN},keys}.conf
	doins "${FILESDIR}"/Xsession
	fperms +x /etc/${PN}/Xsession

	prune_libtool_files --all
	rm -rf "${ED}"/etc/init

	pamd_mimic system-local-login ${PN} auth account session #372229
	dopamd "${FILESDIR}"/${PN}-autologin #390863, #423163
	
	readme.gentoo_create_doc
}
