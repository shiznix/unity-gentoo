# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils gnome2 python ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="saucy"
UVER_PREFIX="+13.10.20130812"

DESCRIPTION="Monochrome icons for the Unity desktop (default icon theme)"
HOMEPAGE="https://launchpad.net/ubuntu-themes"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="phone"
RESTRICT="mirror"

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	:
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

	use phone && \
		doins -r ubuntu-mobile
}
