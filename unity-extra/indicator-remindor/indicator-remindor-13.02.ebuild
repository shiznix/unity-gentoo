# Copyright 1999-2021 Gentoo Foundation
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

RDEPEND="dev-libs/glib:2[dbus]
	dev-libs/gobject-introspection
	dev-libs/libappindicator:3[introspection]
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/feedparser[${PYTHON_MULTI_USEDEP}]
		dev-python/python-dateutil[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	')
	gnome-extra/yelp
	media-libs/gstreamer:1.0[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

# Remove migrate from couchdb #
PATCHES=( "${FILESDIR}"/${PN}-remove_migrate.diff )

S="${WORKDIR}/${PN}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# Fix gst-1.0 sound player #
	sed -i \
		-e "s/playbin2/playbin/" \
		indicator_remindor/IndicatorRemindorWindow.py \
		remindor_common/scheduler.py

	# Fix help uri #
	sed -i \
		-e "s/%s#%s/%s\/%s/" \
		indicator_remindor/helpers.py
	sed -i \
		-e "s/ghelp/help/" \
		indicator_remindor/{PreferencesDialog,IndicatorRemindorWindow,ReminderDialog}.py

	ubuntu-versionator_src_prepare
	default
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
