# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools distutils eutils ubuntu-versionator

URELEASE="saucy"
UVER_PREFIX="+13.10.20130723"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/u"

DESCRIPTION="Online scopes for the Unity Dash"
HOMEPAGE="https://launchpad.net/onehundredscopes"

SCOPES="audacious_0.1${UVER_PREFIX}
	calculator_0.1${UVER_PREFIX}
	chromiumbookmarks_0.1${UVER_PREFIX}
	clementine_0.1${UVER_PREFIX}
	colourlovers_0.1${UVER_PREFIX}
	deviantart_0.1${UVER_PREFIX}
	firefoxbookmarks_0.1+13.10.20130809.1
	gallica_0.1+13.10.20130816.2
	gdrive_0.9${UVER_PREFIX}
	github_0.1${UVER_PREFIX}
	gmusicbrowser_0.1${UVER_PREFIX}
	googlenews_0.1${UVER_PREFIX}
	gourmet_0.1${UVER_PREFIX}
	guayadeque_0.1${UVER_PREFIX}
	manpages_3.0${UVER_PREFIX}
	musique_0.1${UVER_PREFIX}
	openclipart_0.1${UVER_PREFIX}
	openweathermap_0.1${UVER_PREFIX}
	soundcloud_0.1${UVER_PREFIX}
	texdoc_0.1${UVER_PREFIX}
	tomboy_0.1${UVER_PREFIX}
	virtualbox_0.1${UVER_PREFIX}
	yahoostock_0.1${UVER_PREFIX}
	yelp_0.1${UVER_PREFIX}
	zotero_0.1${UVER_PREFIX}"

for SCOPE in ${SCOPES}; do
	SCOPE_UURL="${SCOPE%%_*}"
	SRC_URI_array+=( ${UURL}/unity-scope-${SCOPE_UURL}/unity-scope-${SCOPE}.orig.tar.gz )
done
SRC_URI="${SRC_URI_array[@]}"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!unity-extra/unity-lens-cooking
	dev-libs/dee:=
	dev-libs/libunity:=
	unity-scopes/unity-scope-home"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	for SCOPE in ${SCOPES}; do
		SCOPE="${SCOPE/_/-}"
		pushd "${S}/unity-scope-${SCOPE}"
			distutils_src_prepare
		popd
	done
}

src_compile() {
	for SCOPE in ${SCOPES}; do
		SCOPE="${SCOPE/_/-}"
		pushd "${S}/unity-scope-${SCOPE}"
			distutils_src_compile
		popd
	done
}

src_install() {
	for SCOPE in ${SCOPES}; do
		SCOPE="${SCOPE/_/-}"
		pushd "${S}/unity-scope-${SCOPE}"
			distutils_src_install
		popd
	done
}
