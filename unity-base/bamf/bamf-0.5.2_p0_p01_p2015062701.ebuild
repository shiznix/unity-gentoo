# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

URELEASE="wily"
inherit autotools eutils ubuntu-versionator vala xdummy python-single-r1

UURL="mirror://ubuntu/pool/main/b/${PN}"
UVER_PREFIX="~bzr0+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-3"
SLOT="0/1.0.0"
#KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/gobject-introspection
	dev-libs/libunity[${PYTHON_USEDEP}]
	dev-libs/libunity-webapps
	dev-libs/libxslt[python,${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-util/gdbus-codegen
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3
	x11-libs/libXfixes
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"

	# workaround launchpad bug #1186915
	epatch "${FILESDIR}"/${PN}-0.5.0-remove-desktop-fullname.patch

	# removed gtester2xunit-check
	epatch "${FILESDIR}"/${PN}-0.5.0-disable-gtester2xunit-check.patch

	vala_src_prepare
	export VALA_API_GEN=$VAPIGEN
	python_fix_shebang .

	sed -e "s:-Werror::g" \
		-i "configure.ac" || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-introspection=yes \
		--disable-static || die
}

src_test() {
	local XDUMMY_COMMAND="make check"
	xdummymake
}

src_install() {
	emake DESTDIR="${ED}" install || die

	# Install dbus interfaces #
	insinto /usr/share/dbus-1/interfaces
	doins lib/libbamf-private/org.ayatana.bamf.*xml

	# Install bamf-2.index creation script #
	#  Run at postinst of *.desktop files from ubuntu-versionator.eclass #
	#  bamf-index-create only indexes *.desktop files in /usr/share/applications #
	#    Why not also /usr/share/applications/kde4/ ?
	exeinto /usr/bin
	newexe debian/bamfdaemon.postinst bamf-index-create

	prune_libtool_files --modules
}
