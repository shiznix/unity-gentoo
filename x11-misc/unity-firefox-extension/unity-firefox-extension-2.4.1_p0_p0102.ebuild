EAPI=4

inherit autotools base ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}"
URELEASE="quantal-updates"

DESCRIPTION="Firefox extension for Unity desktop integration"
HOMEPAGE="https://launchpad.net/unity-firefox-extension"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libunity-webapps
	dev-libs/libxslt
	x11-libs/gtk+:2"

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
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
		emake
	popd

	pushd unity-firefox-extension/
		bash ./build.sh
	popd
}

src_install() {
	pushd libufe-xidgetter/
		emake DESTDIR="${D}" install
	popd

	pushd unity-firefox-extension/
		local emid=$(sed -n 's/.*<em:id>\(.*\)<\/em:id>.*/\1/p' install.rdf | head -1)
		dodir usr/lib/firefox/extensions/${emid}/
		unzip unity.xpi -d \
			"${D}usr/lib/firefox/extensions/${emid}/" || die
	popd
	dosym /usr/lib/firefox/extensions/${emid} /opt/firefox/extensions/${emid}
}
