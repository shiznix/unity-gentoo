# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
inherit autotools ubuntu-versionator

MY_PN="policykit-1-gnome"
UURL="mirror://unity/pool/main/p/${MY_PN}"

DESCRIPTION="A dbus session bus service that is used to bring up authentication dialogs"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/PolicyKit"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.xz
	${UURL}/${MY_PN}_${PV}-${UVER}.debian.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.30
	>=sys-auth/polkit-0.102
	x11-libs/gtk+:3
	!lxde-base/lxpolkit"
DEPEND="${RDEPEND}
	dev-util/intltool
	gnome-base/gnome-common
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS HACKING NEWS README TODO )

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}


src_install() {
	default

	cat <<-EOF > "${T}"/polkit-gnome-authentication-agent-1.desktop
	[Desktop Entry]
	Name=PolicyKit Authentication Agent
	Comment=PolicyKit Authentication Agent
	Exec=/usr/libexec/polkit-gnome-authentication-agent-1
	Terminal=false
	Type=Application
	Categories=
	NoDisplay=true
	OnlyShowIn=GNOME;XFCE;Unity;
	X-GNOME-AutoRestart=true
	AutostartCondition=GNOME3 unless-session gnome
	X-Ubuntu-Gettext-Domain=polkit-gnome-1
	EOF

	insinto /etc/xdg/autostart
	doins "${T}"/polkit-gnome-authentication-agent-1.desktop
}
