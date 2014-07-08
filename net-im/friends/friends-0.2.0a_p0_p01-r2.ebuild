# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python3_3 )

inherit autotools gnome2-utils python-r1 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/f/${PN}"
URELEASE="trusty"
UVER_PREFIX="+14.04.20140217.1"

DESCRIPTION="Social from the Start! The friends service is the hub for all things social on the Unity Desktop"
HOMEPAGE="https://launchpad.net/friends"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-libs/dee[${PYTHON_USEDEP}]
	dev-libs/glib:2
	dev-libs/libaccounts-glib[${PYTHON_USEDEP}]
	dev-libs/libsignon-glib[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	>=gnome-extra/evolution-data-server-3.8
	net-libs/libsoup
	net-libs/libsoup-gnome
	net-misc/networkmanager
	unity-base/unity
	x11-libs/gtk+:3
	>=x11-libs/gdk-pixbuf-2.28
	x11-libs/libnotify
	${PYTHON_DEPS}
	$(vala_depend)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare

	cd service
	eautoreconf
}

src_configure() {
	python_copy_sources

	cd service
	econf
}

src_compile() {
	compilation() {
		${EPYTHON} setup.py build
	}
	python_foreach_impl run_in_build_dir compilation

	cd service
	emake
}

src_install(){
	installation() {
		${EPYTHON} setup.py install --root="${ED}"
		${EPYTHON} setup.py install_service_files -d "${ED}usr"
	}
	python_foreach_impl run_in_build_dir installation

	cd service
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
