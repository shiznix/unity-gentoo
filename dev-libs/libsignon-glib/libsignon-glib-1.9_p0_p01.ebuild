# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )

inherit base eutils python-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/libs/${PN}"
URELEASE="raring"

DESCRIPTION="GObject introspection data for the Signon library for the Unity desktop"
HOMEPAGE="https://launchpad.net/libsignon-glib"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0/1.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
RESTRICT="mirror"

RDEPEND="dev-libs/check
	>=dev-libs/glib-2.34
	>=dev-libs/gobject-introspection-1.34.2
	dev-util/gdbus-codegen
	unity-base/signon"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare
}

src_configure() {
	python_copy_sources
	configuration() {
		econf $(use_enable debug) || die
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
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation

	rm -rf "${D}usr/doc"
	prune_libtool_files --modules
}
