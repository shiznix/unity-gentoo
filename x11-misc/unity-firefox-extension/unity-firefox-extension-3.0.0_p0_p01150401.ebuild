# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="vivid-security"
inherit autotools eutils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
UVER_PREFIX="+14.04.20140416"

DESCRIPTION="Firefox extension for Unity desktop integration"
HOMEPAGE="https://launchpad.net/unity-firefox-extension"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libunity-webapps
	dev-libs/libxslt
	x11-libs/gtk+:2"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	ubuntu-versionator_src_prepare
	pushd libufe-xidgetter/
		eautoreconf
	popd
}

src_configure() {
	pushd libufe-xidgetter/
		econf --disable-static
	popd
}

src_compile() {
	pushd libufe-xidgetter/
		emake || die
	popd

	pushd unity-firefox-extension/
		bash ./build.sh || die
	popd
}

src_install() {
	pushd libufe-xidgetter/
		emake DESTDIR="${D}" install
	popd

	pushd unity-firefox-extension/
		local emid=$(sed -n 's/.*<em:id>\(.*\)<\/em:id>.*/\1/p' install.rdf | head -1)
		dodir usr/lib/firefox/browser/extensions/${emid}/
		unzip unity.xpi -d \
			"${D}usr/lib/firefox/browser/extensions/${emid}/" || die
	popd
	dosym /usr/lib/firefox/browser/extensions/${emid} /opt/firefox/browser/extensions/${emid}

	prune_libtool_files --modules
}
