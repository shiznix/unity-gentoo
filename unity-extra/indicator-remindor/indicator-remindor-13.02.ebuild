# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils ubuntu-versionator

DESCRIPTION="Indicator application to schedule reminders"
HOMEPAGE="https://launchpad.net/indicator-remindor"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="app-text/yelp-tools
	<dev-lang/erlang-18
	dev-db/desktopcouch[${PYTHON_USEDEP}]
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/gobject-introspection-common
	dev-libs/libappindicator:3
	dev-python/couchdb-python[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	gnome-extra/yelp
	media-libs/gstreamer:0.10[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
