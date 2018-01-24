# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="vivid-security"
inherit autotools eutils gnome2-utils multilib ubuntu-versionator

UURL="mirror://unity/pool/main/w/${PN}"

DESCRIPTION="Ubuntu Online Accounts browser extension"
HOMEPAGE="https://launchpad.net/online-accounts-browser-extension"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/libaccounts-glib:="
DEPEND="${RDEPEND}
	app-editors/vim-core
	dev-libs/json-glib
	gnome-base/dconf
	unity-base/gnome-control-center-signon
	|| ( www-client/firefox www-client/firefox-bin )
		x11-misc/unity-firefox-extension"
## Chromium support is disabled for now as Ubuntu have broken it's support ##
#	chromium? ( www-client/chromium
#			x11-misc/unity-chromium-extension )"
# Webapp integration doesn't work properly for www-client/firefox-bin or www-client/google-chrome #

#pkg_setup() {
#	ubuntu-versionator_pkg_setup
#	! use firefox && ! use chromium && \
#		die "At least one or both of either 'chromium' or 'firefox' USE flags needs to be enabled"
#}

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #
	sed -e 's:fix-libtool-check.diff:#fix-libtool-check.diff:g' \
		-i debian/patches/series
	ubuntu-versionator_src_prepare
	cp "debian/webaccounts.pem" .
	eautoreconf
}

src_configure() {
	# Don't use econf as it injects an invalid host type #
	# Both chromium and firefox plugins are enabled by default, so only disable #
#	! use firefox && local conflag="${conflag} --disable-firefox"
#	! use chromium && local conflag="${conflag} --disable-chromium"
	./configure --prefix=/usr \
			--disable-chromium \
			${conflag}
}

src_install() {
	emake DESTDIR="${D}" install

	# Make browser plugins optional for each firefox and chromium #
	rm -rf "${D}/usr/$(get_libdir)/webaccounts-chromium/"
	rm -rf "${D}/usr/$(get_libdir)/webaccounts-firefox/"
	rm -rf "${D}/usr/share/chromium/"

#	if use chromium ; then
#		make -C chromium-extension DESTDIR="${D}" install
#	fi

#	if use firefox ; then
		local emid=$(sed -n 's/.*<em:id>\(.*\)<\/em:id>.*/\1/p' \
			firefox-extension/install.rdf | head -1)
		dodir usr/lib/firefox/browser/extensions/${emid}/
		unzip firefox-extension/webaccounts-firefox-extension.xpi -d \
			"${D}usr/lib/firefox/browser/extensions/${emid}/" || die
		dosym /usr/lib/firefox/browser/extensions/${emid} /opt/firefox/browser/extensions/${emid}
#	fi

	prune_libtool_files --modules
}

pkg_postinst() {
	if has_version www-client/firefox-bin; then
		elog
		elog "www-client/firefox-bin is known to not work with many webapps"
		elog "and so is completely unsupported but is included"
		elog "for your convenience should you choose to use it"
		elog
	fi
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
