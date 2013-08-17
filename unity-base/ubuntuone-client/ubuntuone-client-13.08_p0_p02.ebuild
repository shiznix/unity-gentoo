# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit autotools base distutils gnome2-utils python ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="saucy"

DESCRIPTION="Ubuntu One client for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntuone-client"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"

DEPEND="dev-lang/python
	dev-libs/dbus-glib
	gnome-base/nautilus"

# dev-libs/libubuntuone is dropped for Saucy as UbuntuOne project becomes a pure python only project (LP 1196684) #
RDEPEND="!dev-libs/libubuntuone
	${DEPEND}
	dev-python/configglue
	dev-python/dbus-python
	dev-python/gnome-keyring-python
	dev-python/httplib2
	dev-python/notify-python
	>=dev-python/oauth-1.0
	dev-python/pygobject:2
	>=dev-python/pygtk-2.10
	dev-python/pyinotify
	dev-python/pyxdg
	dev-python/simplejson
	>=dev-python/twisted-names-12.2.0
	>=dev-python/twisted-web-12.2.0
	unity-base/ubuntu-sso-client
	unity-base/ubuntuone-storage-protocol
	x11-misc/lndir
	x11-misc/xdg-utils"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -e "s:\[ -d \"\$HOME\/Ubuntu One\" \] \&\& ubuntuone-launch:\[ ! -d \"\$HOME\/Ubuntu One\" \] \&\& mkdir \"\$HOME/Ubuntu One\" \&\& ubuntuone-launch || ubuntuone-launch:" \
		-i "${S}/data/ubuntuone-launch.desktop.in" || die
	python_convert_shebangs -r 2 .
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
