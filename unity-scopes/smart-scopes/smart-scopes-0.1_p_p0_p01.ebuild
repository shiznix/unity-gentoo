# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1 eutils ubuntu-versionator

URELEASE="disco"
UURL="http://archive.ubuntu.com/ubuntu/pool/universe/u"	# Mirrors can be unpredictable #

DESCRIPTION="Online scopes for the Unity Dash"
HOMEPAGE="https://launchpad.net/onehundredscopes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="onlinemusic test"
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/gobject-introspection
	dev-libs/libunity:=
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	unity-scopes/unity-scope-home

	onlinemusic? ( unity-scopes/unity-scope-onlinemusic )"

## Neat and efficient way of bundling and tracking all available scopes into one ebuild ##
## Borrowed from chenxiaolong's Unity-for-Arch overlay at https://github.com/chenxiaolong/Unity-for-Arch ##
setvar() {
	eval "_ver_${1//-/_}=${2}"
	eval "_rel_${1//-/_}=${3}"
	eval "_use_${1//-/_}=${4}"
	eval "_dep_${1//-/_}=\"${5}\""
	packages+=(${1})
}
setvar audacious		0.1+13.10.20130927.1	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"
setvar calculator		0.1+14.04.20140328	0ubuntu4 +
setvar chromiumbookmarks	0.1+13.10.20130723	0ubuntu1 +
setvar clementine		0.1+13.10.20130723	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"
setvar colourlovers		0.1+13.10.20130723	0ubuntu1 +
setvar devhelp			0.1+14.04.20140328	0ubuntu3 + "dev-python/lxml[${PYTHON_USEDEP}]"
setvar deviantart		0.1+13.10.20130723	0ubuntu1 - "dev-python/feedparser[${PYTHON_USEDEP}]"
setvar firefoxbookmarks		0.1+13.10.20130809.1	0ubuntu1 +
setvar gallica			0.1+13.10.20130816.2	0ubuntu1 - "dev-python/lxml[${PYTHON_USEDEP}]"
setvar github			0.1+13.10.20130723	0ubuntu1 -
setvar gmusicbrowser		0.1+13.10.20130723	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"
setvar gnote			0.1+13.10.20130723	0ubuntu2 -
setvar googlenews		0.1+13.10.20130723	0ubuntu1 - "dev-python/feedparser[${PYTHON_USEDEP}]"
setvar gourmet			0.1+13.10.20130723	0ubuntu1 -
setvar guayadeque		0.1+13.10.20130927.1	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"
setvar manpages			3.0+14.04.20140324	0ubuntu3 + "sys-apps/man-db x11-libs/gtk+:3"
setvar musique			0.1+13.10.20130723	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"
setvar openclipart		0.1+13.10.20130723	0ubuntu1 + "dev-python/feedparser[${PYTHON_USEDEP}]"
setvar openweathermap		0.1+13.10.20130828	0ubuntu1 -
setvar soundcloud		0.1+13.10.20130723	0ubuntu1 -
setvar sshsearch		0.1daily13.06.05	0ubuntu1 - "dev-python/paramiko[${PYTHON_USEDEP}]"
setvar texdoc			0.1+14.04.20140328	0ubuntu1 +
setvar virtualbox		0.1+13.10.20130723	0ubuntu1 +
setvar yahoostock		0.1+13.10.20130723	0ubuntu1 -
setvar yelp			0.1+13.10.20130723	0ubuntu1 +
setvar zotero			0.1+13.10.20130723	0ubuntu1 +

for i in ${packages[@]}; do
	unset _rel
	eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}; _use=\${_use_${i//-/_}}; _dep=\${_dep_${i//-/_}}"
	[[ -n ${_dep} ]] && RDEPEND+=" ${_name}? ( ${_dep} )"
	IUSE+=" ${_use/-}${_name}"
	SRC_URI_array+=("${_name}? ( ${UURL}/unity-scope-${_name}/unity-scope-${_name}_${_ver}.orig.tar.gz"
	"${UURL}/unity-scope-${_name}/unity-scope-${_name}_${_ver}-${_rel}.diff.gz )")
done

SRC_URI="${SRC_URI_array[@]}"

DEPEND="${RDEPEND}
	test? ( dev-python/nose )
	${PYTHON_DEPS}"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	for i in ${packages[@]}; do
		use ${i} || continue
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			epatch -p1 "${S}/unity-scope-${_name}_${_ver}-${_rel}.diff"
			distutils-r1_src_prepare
		popd
	done
}

src_compile() {
	for i in ${packages[@]}; do
		use ${i} || continue
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			distutils-r1_src_compile
		popd
	done
}

src_test() {
	for i in ${packages[@]}; do
		use ${i} || continue
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
		use ${i} || continue
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			distutils-r1_src_install
		popd
	done
}
