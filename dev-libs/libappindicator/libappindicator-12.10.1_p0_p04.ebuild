# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils python ubuntu-versionator vala

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

UURL="mirror://ubuntu/pool/main/liba/${PN}"
URELEASE="trusty"
UVER_PREFIX="+13.10.20130920"

DESCRIPTION="Application indicators used by the Unity desktop"
HOMEPAGE="https://launchpad.net/libappindicator"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="3/1.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="dev-libs/libdbusmenu:=
	dev-libs/libindicator:3="
DEPEND="${RDEPEND}
	dev-dotnet/gtk-sharp:2
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/xapian-bindings[python]
	dev-perl/XML-LibXML
	dev-python/dbus-python
	dev-python/pygobject:2
	dev-python/pygtk
	dev-python/pyxdg
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python_pkg_setup
}

src_prepare () {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff" # This needs to be applied for the debian/ directory to be present #

	# The /usr/lib/cli location for Mono bindings is specific to Ubuntu
	sed -e 's|assemblydir = $(libdir)/cli/appindicator-sharp-0.1|assemblydir = $(libdir)/appindicator-sharp-0.1|' \
		-i bindings/mono/Makefile.am
	sed -e 's|assemblies_dir=${libdir}/cli/appindicator-sharp-0.1|assemblies_dir=${libdir}/appindicator-sharp-0.1|' \
		-i bindings/mono/appindicator-sharp-0.1.pc.in

	# Disabled, vala error -> see launchpad
	sed -i -e '/examples/d' "${S}"/bindings/vala/Makefile.am || die

	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"
	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
		PYTHON="$(PYTHON -2)" ../configure --prefix=/usr \
			--disable-static \
			--with-gtk=2 \
			$(use_enable test tests ) \
			$(use_enable test mono-test ) || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
		PYTHON="$(PYTHON -2)" ../configure --prefix=/usr \
			--disable-static \
			--with-gtk=3 \
			$(use_enable test tests ) \
			$(use_enable test mono-test ) || die
	popd
}

src_compile() {
	# Build GTK2 support #
	pushd build-gtk2
		emake || die
	popd

	# Build GTK3 support #
	pushd build-gtk3
		emake || die
	popd
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
		emake DESTDIR="${D}" install || die
	popd

	# Install GTK3 support #
	pushd build-gtk3
		make -C src DESTDIR="${D}" install || die
		make -C bindings/vala DESTDIR="${D}" install || die
	popd

	prune_libtool_files --modules
}
