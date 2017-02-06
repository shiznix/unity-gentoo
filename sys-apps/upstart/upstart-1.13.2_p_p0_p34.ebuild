# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit autotools eutils ubuntu-versionator

UURL="mirror://unity/pool/main/u/${PN}"

DESCRIPTION="Desktop services daemon used by the Unity desktop"
HOMEPAGE="http://upstart.ubuntu.com/"
SRC_URI="${UURL}/${PN}_${PV}.orig.tar.gz
	${UURL}/${PN}_${PV}-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
RESTRICT="mirror"

DEPEND="sys-devel/gettext
	sys-libs/libnih[dbus]
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	## Gentoo does not allow /sbin or /usr/sbin to be in user's $PATH as Ubuntu does ##
	econf \
		--sbindir=/usr/bin \
		$(use_enable threads threading)
}

src_install() {
	emake DESTDIR="${ED}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README TODO

	## Remove unecessary files colliding with sysvinit, we only need 'upstart --user' to start Unity desktop services ##
	rm -rfv ${ED}usr/share/man/man5
	rm -rv ${ED}usr/share/man/man8/{halt,init,poweroff,reboot,restart,runlevel,shutdown,telinit}.8
	rm -rv ${ED}usr/share/man/man7/runlevel.7
	rm -rv ${ED}usr/bin/{halt,init,poweroff,reboot,runlevel,shutdown,telinit}

	insinto /etc/init/
	doins debian/conf/*.conf

	insinto /usr/share/upstart/sessions/
	rm debian/user-conf/logrotate.conf	# Gentoo does not run logrotate as a user process
	doins debian/user-conf/*.conf
	doins "${FILESDIR}/dbus.conf"

	exeinto /usr/bin
	newexe init/init upstart

	insinto /usr/share/man/man8
	newins init/man/init.8 upstart.8

	exeinto /etc/X11/xinit/xinitrc.d
	doexe "${FILESDIR}/99upstart-systemd"

	insinto /usr/share/upstart/systemd-session/upstart
	doins debian/systemd-graphical-session.conf

	# disable job due to Unity logout lag
	mv ${ED}usr/share/upstart/sessions/upstart-dconf-bridge.conf{,.disabled}

	prune_libtool_files --modules
}

pkg_postinst() {
	elog
	elog "Following job is disabled by default due to Unity logout lag:"
	elog
	elog "/usr/share/upstart/sessions/upstart-dconf-bridge.conf"
	elog
	elog "To enable this job, simply remove extension '.disabled'"
	elog
}
