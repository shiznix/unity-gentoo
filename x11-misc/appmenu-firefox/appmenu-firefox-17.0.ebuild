EAPI=4

MY_PN="firefox-globalmenu"
UURL="mirror://ubuntu/pool/main/f/firefox"
UVER="build2-0ubuntu0.12.10.1"
URELEASE="precise-updates"

DESCRIPTION="Unity appmenu integration for Firefox"
HOMEPAGE="https://code.launchpad.net/~extension-hackers/globalmenu-extension"
SRC_URI="( x86? ( mirror://ubuntu/pool/main/f/firefox/${MY_PN}_${PV}+${UVER}_i386.deb )
		 amd64? ( mirror://ubuntu/pool/main/f/firefox/${MY_PN}_${PV}+${UVER}_amd64.deb )
		 )"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="|| ( ~www-client/firefox-${PV} ~www-client/firefox-bin-${PV} )
		x11-misc/appmenu-gtk
		app-text/gnome-doc-utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PRESTRIPPED="//usr/lib/firefox/extensions/globalmenu@ubuntu.com/components/libglobalmenu.so"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_install() {
	rm -r usr/lib/firefox
	mv usr/lib/firefox-addons usr/lib/firefox
	cp -R usr "${D}"
	dosym "/usr/lib/firefox/extensions/globalmenu@ubuntu.com" "/opt/firefox/extensions/globalmenu@ubuntu.com"
}
