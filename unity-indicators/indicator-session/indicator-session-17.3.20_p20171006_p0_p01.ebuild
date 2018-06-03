# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
inherit cmake-utils gnome2-utils ubuntu-versionator

UVER_PREFIX="+17.10.${PVR_MICRO}"

DESCRIPTION="Indicator showing session management, status and user switching used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-session"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+help"
RESTRICT="mirror"

RDEPEND="unity-base/unity-language-pack"
DEPEND="${RDEPEND}
	app-admin/system-config-printer
	dev-cpp/gtest
	dev-libs/glib:2
	dev-libs/libappindicator:=
	dev-libs/libdbusmenu:=
	dev-libs/libindicate-qt
	help? ( gnome-extra/yelp
		gnome-extra/gnome-user-docs
		unity-base/ubuntu-docs )"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Fix build attempting to violate sandbox #
	sed '/gtk-update-icon-cache/,+1 d' \
		-i data/icons/CMakeLists.txt || die

	# Remove dependency on whoopsie (Ubuntu's error submission tracker) #
	sed -e 's:libwhoopsie):):g' \
		-i CMakeLists.txt
	for each in $(grep -ri whoopsie | awk -F: '{print $1}'); do
		sed -e '/whoopsie/Id' -i "${each}"
	done

	if ! use help || has nodoc ${FEATURES}; then
		sed -n '/indicator.help/{s|^|//|};p' \
			-i src/service.c
	else
		sed -e 's:distro_name = g_strdup(value):distro_name = g_strdup(\"Unity\"):g' \
			-i src/service.c
		sed -e 's:yelp:yelp help\:ubuntu-help:g' \
			-i src/backend-dbus/actions.c
	fi
	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"
}

pkg_preinst() {
	gnome2_schemas_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
