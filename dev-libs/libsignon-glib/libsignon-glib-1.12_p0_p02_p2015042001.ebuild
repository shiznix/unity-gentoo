# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
WANT_AUTOMAKE=1.12

URELEASE="wily"
inherit vala autotools base eutils flag-o-matic python-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libs/${PN}"
UVER_PREFIX="+15.04.${PVR_MICRO}"

DESCRIPTION="GObject introspection data for the Signon library for the Unity desktop"
HOMEPAGE="https://launchpad.net/libsignon-glib"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	 ${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-3"
SLOT="0/1.0.0"
#KEYWORDS="~amd64 ~x86"
IUSE="debug"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

RDEPEND="dev-libs/check
	>=dev-libs/glib-2.35.1
	>=dev-libs/gobject-introspection-1.36.0
	dev-util/gdbus-codegen
	unity-base/signon"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	${PYTHON_DEPS}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" || die
	vala_src_prepare
	append-cflags -Wno-error
	eautoreconf
}

src_configure() {
	python_copy_sources
	configuration() {
		econf \
			$(use_enable debug) || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	compilation() {
		emake || die
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	installation() {
		rm -rf "${D}usr/doc"
		emake DESTDIR="${ED}" install
	}
	python_foreach_impl run_in_build_dir installation
	prune_libtool_files --modules
}
