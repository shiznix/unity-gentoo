# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

URELEASE="cosmic"
inherit autotools flag-o-matic python-r1 ubuntu-versionator

UVER_PREFIX="+17.04.${PVR_MICRO}"

DESCRIPTION="Library for single signon for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0/0.1.3"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
RESTRICT="mirror"

DEPEND="dev-db/sqlite:3
	>=dev-libs/check-0.9.10
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/libxml2
	dev-util/gtk-doc
	${PYTHON_DEPS}"

MAKEOPTS="${MAKEOPTS} -j1"
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

	eautoreconf
	append-cflags -Wno-error
}

src_configure() {
	python_copy_sources
	configuration() {
		econf --disable-wal \
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
		emake DESTDIR="${D}" install
	}
	python_foreach_impl run_in_build_dir installation

	rm -rf "${D}usr/doc"
	prune_libtool_files --modules
}
