EAPI=4

inherit eutils autotools

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
MY_P="${P/-/_}"

DESCRIPTION="Essential libraries needed for the Unity desktop"
HOMEPAGE="https://launchpad.net/libunity-webapps"
SRC_URI="https://launchpad.net/libunity-webapps/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-admin/packagekit-gtk
	>=dev-libs/glib-2.32.3
	dev-libs/libindicate[gtk]
	dev-libs/libunity
	>=x11-libs/gtk+-99.3.4.2:3"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Repair library naming #
	sed -e 's:lunity_webapps:lunity-webapps:g' \
		-i src/libunity-webapps/libunity_webapps-0.2.pc.in \
			src/libunity-webapps-repository/libunity-webapps-repository.pc.in

	# Make docs optional #
	! use doc && \
		sed -e 's:data docs:po:' \
			-i Makefile.in
}
