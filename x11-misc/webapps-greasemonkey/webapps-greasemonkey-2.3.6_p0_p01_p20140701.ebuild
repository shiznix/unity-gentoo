# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="vivid"
inherit ubuntu-versionator

UURL="mirror://ubuntu/pool/main/w/${PN}"
UVER_PREFIX="+14.10.${PVR_MICRO}"

DESCRIPTION="WebApps: Websites integration Firefox plug-in for Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-greasemonkey"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/webapps"

OLDDATE="$(date +%Y.%m.%d)"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_compile() {
	./build.sh
}

src_install() {
	local emid=$(sed -n 's/.*<em:id>\(.*\)<\/em:id>.*/\1/p' install.rdf | head -1)
	dodir usr/lib/firefox/browser/extensions/${emid}/
	NEWDATE=$(date +%Y.%m.%d)
	if [[ "${OLDDATE}" != "${NEWDATE}" ]]; then
		die "Do not build at midnight :) Please rebuild"
	fi
	unzip webapps-${NEWDATE}.beta.xpi -d \
		"${D}usr/lib/firefox/browser/extensions/${emid}/" || die
	dosym /usr/lib/firefox/browser/extensions/${emid} /opt/firefox/browser/extensions/${emid}
}
