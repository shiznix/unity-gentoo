# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )

inherit distutils-r1 eutils ubuntu-versionator

URELEASE="trusty"
UVER_PREFIX="+13.10.20130723"
UURL="http://archive.ubuntu.com/ubuntu/pool/main/u"	# Mirrors can be unpredictable #

DESCRIPTION="Online scopes for the Unity Dash"
HOMEPAGE="https://launchpad.net/onehundredscopes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="!unity-extra/unity-lens-cooking
	dev-libs/dee:=
	dev-libs/glib:2
	dev-libs/libunity:=
	dev-python/feedparser
	dev-python/pygobject:3
	unity-scopes/unity-scope-home"
DEPEND="${RDEPEND}
	test? ( dev-python/nose )
	${PYTHON_DEPS}"

## Neat and efficient way of bundling and tracking all available scopes into one ebuild ##
## Borrowed from chenxiaolong's Unity-for-Arch overlay at https://github.com/chenxiaolong/Unity-for-Arch ##
setvar() {
	eval "_ver_${1//-/_}=${2}"
	eval "_rel_${1//-/_}=${3}"
	packages+=(${1})
}
setvar audacious		0.1+13.10.20130927.1	0ubuntu1
setvar calculator		0.1+14.04.20140328	0ubuntu1
setvar chromiumbookmarks	0.1+13.10.20130723	0ubuntu1
setvar clementine		0.1+13.10.20130723	0ubuntu1
setvar colourlovers		0.1+13.10.20130723	0ubuntu1
setvar devhelp			0.1+14.04.20140328	0ubuntu1
setvar deviantart		0.1+13.10.20130723	0ubuntu1
setvar firefoxbookmarks		0.1+13.10.20130809.1	0ubuntu1
setvar gallica			0.1+13.10.20130816.2	0ubuntu1
setvar gdrive			0.9+13.10.20130723	0ubuntu1
setvar github			0.1+13.10.20130723	0ubuntu1
setvar gmusicbrowser		0.1+13.10.20130723	0ubuntu1
setvar googlenews		0.1+13.10.20130723	0ubuntu1
setvar gourmet			0.1+13.10.20130723	0ubuntu1
setvar guayadeque		0.1+13.10.20130927.1	0ubuntu1
setvar manpages			3.0+14.04.20140324	0ubuntu1
setvar musique			0.1+13.10.20130723	0ubuntu1
setvar openclipart		0.1+13.10.20130723	0ubuntu1
setvar openweathermap		0.1+13.10.20130828	0ubuntu1
setvar soundcloud		0.1+13.10.20130723	0ubuntu1
setvar texdoc			0.1+14.04.20140328	0ubuntu1
setvar tomboy			0.1+13.10.20130723	0ubuntu1
setvar virtualbox		0.1+13.10.20130723	0ubuntu1
setvar yahoostock		0.1+13.10.20130723	0ubuntu1
setvar yelp			0.1+13.10.20130723	0ubuntu1
setvar zotero			0.1+13.10.20130723	0ubuntu1

for i in ${packages[@]}; do
	unset _rel
	eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
	SRC_URI_array+=("${UURL}/unity-scope-${_name}/unity-scope-${_name}_${_ver}.orig.tar.gz"
	"${UURL}/unity-scope-${_name}/unity-scope-${_name}_${_ver}-${_rel}.diff.gz")
done
SRC_URI="${SRC_URI_array[@]}"
S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	for i in ${packages[@]}; do
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			epatch -p1 "${S}/unity-scope-${_name}_${_ver}-${_rel}.diff"
			distutils-r1_src_prepare
		popd
	done
}

src_compile() {
	for i in ${packages[@]}; do
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			distutils-r1_src_compile
		popd
	done
}

src_test() {
	for i in ${packages[@]}; do
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			if grep -q python3-nose debian/control; then
				nosetests || :
			fi
		popd
	done
}

src_install() {
	for i in ${packages[@]}; do
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			distutils-r1_src_install
		popd
	done
}
