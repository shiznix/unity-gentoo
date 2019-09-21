# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools gnome2-utils multilib savedconfig ubuntu-versionator

UVER_PREFIX="+16.04.${PVR_MICRO}"

DESCRIPTION="Canonical's on-screen-display notification agent"
HOMEPAGE="http://launchpad.net/notify-osd"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.16
	>=x11-libs/gtk+-3.2:3
	>=x11-libs/libnotify-0.7
	>=x11-libs/libwnck-3
	x11-libs/libX11
	x11-libs/pixman
	!x11-misc/notification-daemon
	!x11-misc/qtnotifydaemon"
RDEPEND="${COMMON_DEPEND}
	!minimal? ( x11-themes/notify-osd-icons )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	gnome-base/gnome-common
	x11-base/xorg-proto"

RESTRICT="mirror test" # virtualx.eclass: 1 of 1: FAIL: test-modules

DOCS=( AUTHORS ChangeLog NEWS README TODO )
S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die
	restore_config src/{bubble,defaults,dnd}.c #428134
	eautoreconf
}

src_configure() {
	econf --libexecdir=/usr/$(get_libdir)/${PN}
}

src_install() {
	default
	save_config src/{bubble,defaults,dnd}.c
	rm -f "${ED}"/usr/share/${PN}/icons/*/*/*/README

	# kde-plasma/plasma-workspace provides a similar DBUS service that conflicts #
	#  by advertising the same 'org.freedesktop.Notifications' name on DBUS #
	#  This can cause dbus to fail both services in turn causing multimedia keys function to fail #
	#  Other side-effect symptoms include nm-applet displaying incorrect network connectivity state and mouse cursor slow to appear on login #
	if [ -n "$(grep org.freedesktop.Notifications$ /usr/share/dbus-1/services/* | grep -v org.freedesktop.Notifications.service)" ]; then
		einfo
		einfo "Conflicting notification service(s) have been found in /usr/share/dbus-1/services/"
		einfo " Installing workaround as /etc/xdg/autostart/notify-osd.desktop"
		einfo "Consider removing duplicate entries and re-emerging x11-misc/notify-osd"
		einfo " to have notifications work at Display Manager login"
		einfo "Review conflicting notification service(s) below:"
		einfo
		einfo "$(grep org.freedesktop.Notifications$ /usr/share/dbus-1/services/* | grep -v org.freedesktop.Notifications.service)"
		einfo
		rm -f "${ED}"/usr/share/dbus-1/services/org.freedesktop.Notifications.service
		insinto /etc/xdg/autostart
		doins "${FILESDIR}/notify-osd.desktop"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
