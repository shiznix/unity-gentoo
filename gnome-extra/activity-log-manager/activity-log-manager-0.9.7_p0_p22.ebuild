# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="yes"

URELEASE="wily"
inherit autotools base eutils gnome2 ubuntu-versionator vala

UURL="mirror://ubuntu/pool/main/a/${PN}"

DESCRIPTION="Blacklist configuration user interface for Zeitgeist"
HOMEPAGE="https://launchpad.net/activity-log-manager"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libgee:0
	dev-libs/libzeitgeist
	gnome-extra/zeitgeist
	sys-auth/polkit
	unity-base/unity-control-center
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	$(vala_depend)"

src_prepare() {
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	# Install docs in /usr/share/doc #
	sed -e "s:\${prefix}/doc/alm:/usr/share/doc/${P}:g" \
		-i Makefile{.am,.in} || die
	DOCS="README NEWS INSTALL ChangeLog AUTHORS"

	cp "${FILESDIR}"/config.vapi src/ || die
	vala_src_prepare
	export VALA_API_GEN="$VAPIGEN"

	# Fix broken libgnome-control-center check #
	sed -e 's:test "x$with_ccpanel" != xcheck:test "x$with_ccpanel" != xcheck \&\& test "x$with_ccpanel" != xno:g' \
		-i configure.ac
	eautoreconf
}

src_configure() {
	econf \
		--with-ccpanel=no
}

src_install() {
	gnome2_src_install

	# Remove whoopsie crash database error tracking submission daemon #
	rm -rf "${ED}etc" \
		"${ED}usr/share/dbus-1" \
		"${ED}usr/share/polkit-1" \
		"${ED}usr/share/gnome-control-center"

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}usr/share/locale"

	prune_libtool_files --modules
}
