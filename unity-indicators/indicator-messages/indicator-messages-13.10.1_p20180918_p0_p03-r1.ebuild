# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit autotools eutils flag-o-matic gnome2-utils ubuntu-versionator vala xdg-utils

UVER_PREFIX="+18.10.${PVR_MICRO}"

DESCRIPTION="Indicator that collects messages that need a response used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-messages"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!net-im/indicator-messages
	dev-libs/libappindicator
	dev-libs/libdbusmenu
	dev-util/dbus-test-runner
	$(vala_depend)"

S="${WORKDIR}"

src_prepare() {
	eapply "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"
	ubuntu-versionator_src_prepare
	eautoreconf

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
}

src_install() {
	default
	# Remove unused libtool libarchive files #
	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
	ubuntu-versionator_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
