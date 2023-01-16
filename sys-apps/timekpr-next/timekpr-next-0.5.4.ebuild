# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils

DESCRIPTION="Control computer usage of users. Limit daily usage based on timed access duration, configure periods when they can log in"
HOMEPAGE="https://launchpad.net/timekpr-next"
SRC_URI="https://launchpad.net/timekpr-next/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="acct-group/timekpr
	dev-libs/libappindicator:3
	dev-python/dbus-python
	dev-python/psutil
	dev-python/pygobject:3
	gnome-extra/polkit-gnome
	x11-libs/gtk+:3"

S="${WORKDIR}/${PN}"


src_install() {
	cat debian/install | while read a b; do
		case "$a" in
			*"#"*) ;;
			"") ;;
			*)
			f=`basename "$a"`
			if [ -d $a ]; then
				install -d "${ED}/$b/$f"
			else
				install -D "$a" "${ED}/$b/$f"
			fi
		esac
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}
