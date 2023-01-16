# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

URELEASE="jammy"
inherit autotools eutils python-r1 ubuntu-versionator

UVER_PREFIX="+18.04.${PVR_MICRO}"

DESCRIPTION="GTK+ module for exporting old-style menus as GMenuModels"
HOMEPAGE="https://launchpad.net/unity-gtk-module"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libdbusmenu:=[gtk3]
	x11-libs/libX11
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	!x11-misc/appmenu-gtk"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eapply "${FILESDIR}/unity-gtk-module-0.0.0+14.04-deprecated-api.patch"

	# Fix "SyntaxError: Missing parentheses in call to 'print'" #
	sed -i \
		-e "s/print level \* ' ', root/print (level \* ' ', root)/" \
		tests/autopilot/tests/test_gedit.py

	eautoreconf
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
		../configure --prefix=/usr \
			--libdir=/usr/$(get_libdir) \
			--sysconfdir=/etc \
			--disable-static \
			--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
		../configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--sysconfdir=/etc \
		--disable-static || die
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
		emake DESTDIR="${D}" install || die
	popd

	# Append module to GTK_MODULES environment variable #
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/81unity-gtk-module"

	# Remove unused libtool libarchive files #
	find "${ED}" -name '*.la' -delete || die

	python_foreach_impl python_optimize
}
