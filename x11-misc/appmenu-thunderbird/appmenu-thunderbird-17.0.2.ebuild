EAPI=4

MY_PN="thunderbird-globalmenu"

UURL="mirror://ubuntu/pool/main/t/thunderbird"
UVER="+build1-0ubuntu0.12.10.1"
URELEASE="quantal"

DESCRIPTION="Unity appmenu integration for Thunderbird mail client"
HOMEPAGE="https://code.launchpad.net/~extension-hackers/globalmenu-extension"
SRC_URI="( x86? ( ${UURL}/${MY_PN}_${PV}${UVER}_i386.deb )
		 amd64? ( ${UURL}/${MY_PN}_${PV}${UVER}_amd64.deb )
		 )"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="|| ( ~mail-client/thunderbird-${PV} ~mail-client/thunderbird-bin-${PV} )
		x11-misc/appmenu-gtk
		app-text/gnome-doc-utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PRESTRIPPED="//usr/lib/thunderbird/extensions/globalmenu@ubuntu.com/components/libglobalmenu.so"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_install() {
	rm -r usr/lib/thunderbird
	mv usr/lib/thunderbird-addons usr/lib/thunderbird
	cp -R usr "${D}"
	dosym "/usr/lib/thunderbird/extensions/globalmenu@ubuntu.com" "/opt/thunderbird/extensions/globalmenu@ubuntu.com"
}
