# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome.org versionator ubuntu-versionator

DESCRIPTION="A dbus session bus service that is used to bring up authentication dialogs"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/PolicyKit"
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
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS HACKING NEWS README TODO )

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
	OnlyShowIn=Gnome;XFCE;Unity
	X-GNOME-AutoRestart=true
	AutostartCondition=GNOME3 unless-session gnome
	EOF

	insinto /etc/xdg/autostart
	doins "${T}"/polkit-gnome-authentication-agent-1.desktop
}
