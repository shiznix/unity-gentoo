# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8,3_9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no

URELEASE="hirsute"
inherit distutils-r1 eutils ubuntu-versionator

UVER_PREFIX="+17.10.${PVR_MICRO}"

DESCRIPTION="Photo lens for the Unity desktop"
HOMEPAGE="https://launchpad.net/unity-lens-photos"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-online-accounts"

RESTRICT="mirror"

RDEPEND="
	$(python_gen_cond_dep '
		dev-libs/libunity[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject[${PYTHON_MULTI_USEDEP}]
	')
	media-gfx/shotwell
	unity-base/unity
	unity-base/unity-language-pack

	gnome-online-accounts? (
		dev-libs/libgdata[gnome-online-accounts]
		$(python_gen_cond_dep '
			dev-libs/dee[${PYTHON_MULTI_USEDEP}]
			dev-libs/libunity[${PYTHON_MULTI_USEDEP}]
			dev-python/httplib2[${PYTHON_MULTI_USEDEP}]
			dev-python/oauthlib[${PYTHON_MULTI_USEDEP}]
			net-libs/libaccounts-glib[${PYTHON_MULTI_USEDEP}]
			net-libs/libsignon-glib[${PYTHON_MULTI_USEDEP}]
		')
		net-libs/libsoup )

	${PYTHON_DEPS}"

S="${WORKDIR}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	ubuntu-versionator_src_prepare

	# Remove Facebook, Flickr and Picasa scopes #
	#  as they are not maintained and tested anymore #
	use gnome-online-accounts || eapply "${FILESDIR}/remove-goa-scopes.diff"

	distutils-r1_src_prepare
}

src_configure() {
	# Workaround for distutils-r1.eclass: install --skip-build #
	mydistutilsargs=( build )
	distutils-r1_src_configure
}

src_install() {
	distutils-r1_src_install

	# Remove all installed language files as they can be incomplete #
	#  due to being provided by Ubuntu's language-pack packages #
	rm -rf "${ED}/usr/share/locale"

	python_fix_shebang "${ED}"

	local DOCS=( AUTHORS COPYING )
	einstalldocs
}

pkg_postinst() {
	if use gnome-online-accounts; then
		echo
		ewarn "USE-flag 'gnome-online-accounts' declared:"
		ewarn "Facebook, Flickr and Picasa scopes are installed but not maintained and tested anymore."
		echo
	fi
}
