# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="3:3.2"
RESTRICT_PYTHON_ABIS="2.*"
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools distutils gnome2-utils python ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/f/${PN}"
URELEASE="saucy"
UVER_PREFIX="daily13.06.07.1"

DESCRIPTION="Social from the Start! The friends service is the hub for all things social on the Unity Desktop"
HOMEPAGE="https://launchpad.net/friends"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee
	dev-libs/glib:2
	dev-libs/libaccounts-glib
	dev-libs/libsignon-glib
	dev-python/dbus-python
	dev-python/pygobject
	|| ( ( net-libs/libsoup
		net-libs/libsoup-gnome )
		>net-libs/libsoup-2.42 )
	net-misc/networkmanager
	unity-base/unity
	x11-libs/gtk+:3
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

pkg_setup() {
	python_set_active_version 3
	python_pkg_setup
}

src_prepare() {
	vala_src_prepare
	distutils_src_prepare
	cd service
	eautoreconf
}

src_configure() {
	cd service
	econf
}

src_compile() {
	distutils_src_compile
	cd service
	emake
}

src_install(){
	distutils_src_install
	python3 setup.py install_service_files -d "${ED}usr"

	cd service
	emake DESTDIR="${ED}" install

	cd service/data
	emake DESTDIR="${ED}" install
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
