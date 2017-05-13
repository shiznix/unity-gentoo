# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )
VALA_MIN_API_VERSION="0.26"
VALA_MAX_API_VERSION="0.26"

URELEASE="zesty"
inherit autotools eutils flag-o-matic gnome2-utils python-r1 ubuntu-versionator vala

UURL="mirror://unity/pool/main/i/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Keyboard indicator used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-keyboard"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="gnome-extra/gucharmap:2.90
	gnome-base/gnome-desktop:3="
DEPEND="${RDEPEND}
	>=app-i18n/fcitx-4.2.8.5
	app-i18n/ibus[vala]
	>=dev-libs/glib-2.37
	dev-libs/libappindicator
	dev-libs/libgee:0
	dev-libs/libdbusmenu
	gnome-base/dconf
	gnome-base/libgnomekbd
	sys-apps/accountsservice
	unity-base/bamf
	x11-libs/gtk+:3
	x11-libs/libxklavier
	x11-libs/pango
	x11-misc/lightdm
	$(vala_depend)
	${PYTHON_DEPS}"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# 'python-copy-sources' will not work if S="${WORKDIR}" because it bails if 'cp' prints anything to stderr #
	#       (the 'cp' command works but prints "cp: cannot copy a directory into itself" to stderr) #
	# Workaround by changing into a re-defined "${S}" #
	mkdir "${WORKDIR}/${P}"
	mv "${WORKDIR}"/* "${WORKDIR}/${P}" &> /dev/null
	export S="${WORKDIR}/${P}"
	cd "${S}"

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
