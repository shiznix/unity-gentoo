EAPI=4

inherit versionator ubuntu-versionator

MY_PN="firefox-globalmenu"
MY_P="${MY_PN}_${PV}"
UURL="mirror://ubuntu/pool/main/f/firefox"
URELEASE="quantal"
UVER_PREFIX="+build1"

DESCRIPTION="Unity appmenu integration for Firefox"
HOMEPAGE="https://code.launchpad.net/~extension-hackers/globalmenu-extension"
SRC_URI="( x86? ( mirror://ubuntu/pool/main/f/firefox/${MY_P}${UVER_PREFIX}-${UVER}_i386.deb )
		 amd64? ( mirror://ubuntu/pool/main/f/firefox/${MY_P}${UVER_PREFIX}-${UVER}_amd64.deb )
		 )"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="|| ( =www-client/firefox-$(get_version_component_range 1-2)* =www-client/firefox-bin-$(get_version_component_range 1-2)* )
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
