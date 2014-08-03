# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-r1 ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140721"

DESCRIPTION="Monochrome icons for the Unity desktop (default icon theme)"
HOMEPAGE="https://launchpad.net/ubuntu-themes"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="phone"
RESTRICT="mirror"

RDEPEND="!x11-themes/light-themes
	>=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	python_export_best
}

src_configure() {
	:
}

src_compile() {
	emake
}

src_install() {
	dodir /usr/share/icons/
	insinto /usr/share/icons
	doins -r LoginIcons ubuntu-mono-dark ubuntu-mono-light

	dodir /usr/share/themes/
	insinto /usr/share/themes
	doins -r Ambiance Radiance

	use phone && \
		doins -r ubuntu-mobile

	## Remove broken symlinks ##
	find -L "${ED}" -type l -exec rm {} +
}
