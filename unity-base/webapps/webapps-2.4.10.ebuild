EAPI=4

inherit autotools eutils gnome2-utils python versionator

URELEASE="quantal"
UURL="https://launchpad.net/webapps-applications/$(get_version_component_range 1-2)/${PV}/+download"

DESCRIPTION="WebApps: Initial set of Apps for the Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-applications"
SRC_URI="${UURL}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-admin/packagekit-gtk
	>=dev-libs/glib-2.32.3
	dev-libs/json-glib
	dev-libs/libindicate[gtk]
	dev-libs/libunity
	dev-libs/libunity-webapps
	dev-python/polib
	>=x11-libs/gtk+-99.3.4.2:3"

src_prepare() {
	python_convert_shebangs 2 scripts/install-default-webapps-in-launcher.py
}

src_configure() {
	econf \
		--enable-applications \
		--enable-default-applications
}

src_install() {
	emake DESTDIR="${D}" install

	mv scripts/install-default-webapps-in-launcher.py scripts/install-default-webapps-in-launcher
	dobin scripts/install-default-webapps-in-launcher

	# Move userscripts into their proper directory names #
	for webapp in `find "${D}usr/share/unity-webapps/userscripts" -name "*.user.js" | awk -F.user.js '{print $1}' | awk -F/ ' { print ( $(NF-1) ) }'`; do
		mv "${D}usr/share/unity-webapps/userscripts/${webapp}" \
			"${D}usr/share/unity-webapps/userscripts/unity-webapps-`echo ${webapp} | tr '[A-Z]' '[a-z]'`"
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
