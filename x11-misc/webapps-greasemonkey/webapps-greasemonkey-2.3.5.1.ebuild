EAPI=4

UURL="http://archive.ubuntu.com/ubuntu/pool/main/w/${PN}"
UVER="0ubuntu1"  
URELEASE="raring"
MY_P="${P/greasemonkey-/greasemonkey_}"

DESCRIPTION="WebApps: Websites integration Firefox plug-in for Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-greasemonkey"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/webapps"

OLDDATE="$(date +%Y.%m.%d)"

src_compile() {
	./build.sh
}

src_install() {
	local emid=$(sed -n 's/.*<em:id>\(.*\)<\/em:id>.*/\1/p' install.rdf | head -1)
	dodir usr/lib/firefox/extensions/${emid}/
	NEWDATE=$(date +%Y.%m.%d)
	if [[ "${OLDDATE}" != "${NEWDATE}" ]]; then
		die "Do not build at midnight :) Please rebuild"
	fi
	unzip webapps-${NEWDATE}.beta.xpi -d \
		"${D}usr/lib/firefox/extensions/${emid}/" || die
	dosym /usr/lib/firefox/extensions/${emid} /opt/firefox/extensions/${emid}
}
