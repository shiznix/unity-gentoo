# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.7"
#SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit distutils python ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/r/${PN}"
URELEASE="raring"

DESCRIPTION="Ubuntu One rhythmbox plugin for the Unity desktop"
HOMEPAGE="https://launchpad.net/rhythmbox-ubuntuone"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libpeas
	dev-libs/libubuntuone
	dev-libs/libzeitgeist
	dev-python/dirspec
	dev-python/pygobject:2
	dev-python/pygobject:3
	>=dev-python/twisted-core-13.0.0
	gnome-base/gnome-menus:3
	>=media-sound/rhythmbox-2.98[dbus,python,zeitgeist]
	unity-base/ubuntuone-client
	unity-base/unity
	x11-themes/ubuntuone-client-data
	$(vala_depend)"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
