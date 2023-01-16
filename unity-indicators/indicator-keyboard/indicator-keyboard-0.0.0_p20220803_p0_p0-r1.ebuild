# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

URELEASE="kinetic"
inherit autotools eutils flag-o-matic gnome2-utils python-r1 ubuntu-versionator vala

UVER_PREFIX="+19.10.${PVR_MICRO}"

DESCRIPTION="Keyboard indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-keyboard"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+charmap"
RESTRICT="mirror"

RDEPEND="gnome-base/gnome-desktop:3=
	charmap? ( gnome-extra/gucharmap )"
DEPEND="${RDEPEND}
	app-i18n/fcitx
	app-i18n/ibus[vala]
	>=dev-libs/glib-2.37
	dev-libs/libappindicator
	dev-libs/libgee:0.8
	dev-libs/libdbusmenu
	gnome-base/dconf
	gnome-base/libgnomekbd
	sys-apps/accountsservice
	unity-base/bamf
	x11-libs/gtk+:3
	x11-libs/libxklavier
	x11-libs/pango
	x11-misc/lightdm
	${PYTHON_DEPS}
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare

	! use charmap && sed -i \
		-e "/Character Map/d" \
		lib/indicator-menu.vala

	# Fix "SyntaxError: Missing parentheses in call to 'print'" #
	sed -i \
		-e "s/print level \* ' ', root/print (level \* ' ', root)/" \
		tests/autopilot/tests/test_indicator_keyboard.py

	# 'python-copy-sources' will not work if S="${WORKDIR}" because it bails if 'cp' prints anything to stderr #
	#       (the 'cp' command works but prints "cp: cannot copy a directory into itself" to stderr) #
	# Workaround by changing into a re-defined "${S}" #
#	mkdir "${WORKDIR}/${P}"
#	mv "${WORKDIR}"/* "${WORKDIR}/${P}" &> /dev/null
#	export S="${WORKDIR}/${P}"
#	cd "${S}"

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	python_copy_sources
	configuration() {
		econf
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation
	python_foreach_impl python_optimize

	prune_libtool_files --modules
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
