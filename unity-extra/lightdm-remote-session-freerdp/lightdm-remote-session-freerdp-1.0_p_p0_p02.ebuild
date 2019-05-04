# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
GNOME2_LA_PUNT="yes"

inherit ubuntu-versionator eutils

UURL="mirror://unity/pool/main/l/${PN}"
URELEASE="vivid"

DESCRIPTION="Configuration and a script to do a remote session using FreeRDP."
HOMEPAGE="https://launchpad.net/lightdm-remote-session-freerdp"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="net-misc/freerdp
	 >=gnome-extra/zenity-3.6.0
	 sys-apps/remote-login-service"

src_prepare() {
	epatch "${FILESDIR}"/0001_Fix_locale_file.patch
}
