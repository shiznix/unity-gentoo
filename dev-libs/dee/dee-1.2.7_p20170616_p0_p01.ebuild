# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_5,3_6} )
AUTOTOOLS_AUTORECONF=y

URELEASE="artful"
inherit autotools-utils eutils python-r1 ubuntu-versionator vala

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="mirror://unity/pool/main/d/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Provide objects allowing to create Model-View-Controller type programs across DBus"
HOMEPAGE="https://launchpad.net/dee/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

SLOT="0/4.2.1"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples +icu static-libs test"
RESTRICT="mirror"

RDEPEND="dev-libs/glib:2
	dev-libs/icu:="
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	test? ( dev-util/dbus-test-runner )
	${PYTHON_DEPS}
	$(vala_depend)"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare

	# Disable '-Werror' #
	sed -e 's:-Werror::g' \
		-i configure.ac

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable debug trace-log)
		$(use_enable doc gtk-doc)
		$(use_enable icu)
		$(use_enable test tests)
#		$(use_enable test extended-tests)
		)
	autotools-utils_src_configure
	python_copy_sources
}

src_compile() {
	autotools-utils_src_compile

	compilation() {
		cd bindings || die
		emake \
			pyexecdir="$(python_get_sitedir)"
	}
	python_foreach_impl run_in_build_dir compilation
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PN}/
		doins -r examples
	fi

	installation() {
		cd bindings || die
		emake \
			PYGI_OVERRIDES_DIR="$(python_get_sitedir)"/gi/overrides \
			DESTDIR="${D}" \
			install
	}
	python_foreach_impl run_in_build_dir installation

	prune_libtool_files --modules
}
