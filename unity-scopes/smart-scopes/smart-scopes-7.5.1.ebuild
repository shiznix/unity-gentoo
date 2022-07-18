# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 eutils ubuntu-versionator

URELEASE="jammy"
UURL="http://archive.ubuntu.com/ubuntu/pool/universe/u"	# Mirrors can be unpredictable #

DESCRIPTION="Online scopes for the Unity Dash"
HOMEPAGE="https://launchpad.net/onehundredscopes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="dev-libs/dee:=
	dev-libs/gobject-introspection
	dev-libs/libunity:=
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	unity-scopes/unity-scope-home"

## Neat and efficient way of bundling and tracking all available scopes into one ebuild ##
## Borrowed from chenxiaolong's Unity-for-Arch overlay at https://github.com/chenxiaolong/Unity-for-Arch ##
setvar() {
	eval "_ver_${1//-/_}=${2}"
	eval "_rel_${1//-/_}=${3}"
	eval "_use_${1//-/_}=${4}"
	eval "_dep_${1//-/_}=\"${5}\""
	packages+=(${1})
}
setvar audacious		0.1+13.10.20130927.1	0ubuntu1 + "dev-python/dbus-python[${PYTHON_USEDEP}] unity-lenses/unity-lens-meta[music]"	## works with audacious 3.9
setvar calculator		0.1+14.04.20140328	0ubuntu5 + ""											## works with gnome-calculator 3.32
setvar chromiumbookmarks	0.1+13.10.20130723	0ubuntu1 + ""											## works with chromium 79 (fixed by patch)
setvar clementine		0.1+13.10.20130723	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"						## not tested
setvar colourlovers		0.1+13.10.20130723	0ubuntu1 + ""											## works
setvar devhelp			0.1+14.04.20140328	0ubuntu4 + "dev-python/lxml[${PYTHON_USEDEP}]"							## works
setvar deviantart		0.1+13.10.20130723	0ubuntu1 + "dev-python/feedparser[${PYTHON_USEDEP}]"						## works (fixed by patch)
setvar firefoxbookmarks		0.1+13.10.20130809.1	0ubuntu1 + ""											## works with firefox 72 (fixed by patch)
setvar gallica			0.1+13.10.20130816.2	0ubuntu1 + "dev-python/lxml[${PYTHON_USEDEP}]"							## works (fixed by patch)
#setvar gdrive			0.9+13.10.20130723	0ubuntu1 - ""											## doesn't work (account-plugins package not available)
setvar github			0.1+13.10.20130723	0ubuntu1 + ""											## works
setvar gmusicbrowser		0.1+13.10.20130723	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"						## not tested
setvar gnote			0.1+13.10.20130723	0ubuntu3 - ""											## not tested
#setvar googlenews		0.1+13.10.20130723	0ubuntu1 - "dev-python/feedparser[${PYTHON_USEDEP}]"						## doesn't work
#setvar gourmet			0.1+13.10.20130723	0ubuntu1 - ""											## doesn't work (gourmet package not available)
setvar guayadeque		0.1+13.10.20130927.1	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"						## not tested
#setvar launchpad		0.1daily13.06.05	0ubuntu1 - ""											## doesn't work (python-launchpadlib package not available)
setvar manpages			3.0+14.04.20140324	0ubuntu4 + "sys-apps/man-db x11-libs/gtk+:3"							## works
setvar musique			0.1+13.10.20130723	0ubuntu1 - "dev-python/dbus-python[${PYTHON_USEDEP}]"						## not tested
#setvar openclipart		0.1+13.10.20130723	0ubuntu1 - "dev-python/feedparser[${PYTHON_USEDEP}]"						## doesn't work (https://en.wikipedia.org/wiki/Openclipart#Lockdown_and_attempts_at_mirroring_the_library)
#setvar openweathermap		0.1+13.10.20130828	0ubuntu1 - ""											## doesn't work (needs API key)
setvar soundcloud		0.1+13.10.20130723	0ubuntu3 + "unity-lenses/unity-lens-meta[music]"						## works
setvar sshsearch		0.1daily13.06.05	0ubuntu1 - "dev-python/paramiko[${PYTHON_USEDEP}]"						## not tested
setvar texdoc			0.1+14.04.20140328	0ubuntu1 + ""											## works
#setvar tomboy			0.1+13.10.20130723	0ubuntu1 - ""											## doesn't work (tomboy package not available)
setvar virtualbox		0.1+13.10.20130723	0ubuntu3 + ""											## works
#setvar yahoostock		0.1+13.10.20130723	0ubuntu1 - ""											## doesn't work
setvar yelp			0.1+13.10.20130723	0ubuntu1 + ""											## works
setvar zotero			0.1+13.10.20130723	0ubuntu3 - ""											## not tested (Zotero 4.0 for Firefox is being replaced by a Zotero Connector for Firefox)

for i in ${packages[@]}; do
	unset _rel
	eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}; _use=\${_use_${i//-/_}}; _dep=\${_dep_${i//-/_}}"
	[[ -n ${_dep} ]] && RDEPEND+=" ${_name}? ( ${_dep} )"
	IUSE+=" ${_use/-}${_name}"
	SRC_URI_array+=("${_name}? ( ${UURL}/unity-scope-${_name}/unity-scope-${_name}_${_ver}.orig.tar.gz"
	"${UURL}/unity-scope-${_name}/unity-scope-${_name}_${_ver}-${_rel}.diff.gz )")
done

SRC_URI="${SRC_URI_array[@]}"

BDEPEND="test? ( dev-python/nose )
	${PYTHON_DEPS}"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	for i in ${packages[@]}; do
		use ${i} || continue
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
		pushd "${S}/unity-scope-${_name}-${_ver}"
			eapply "${S}/unity-scope-${_name}_${_ver}-${_rel}.diff"
			[[ -f ${FILESDIR}/${i}.patch ]] && eapply "${FILESDIR}/${i}.patch"
			distutils-r1_src_prepare
			fgrep -qsx "RemoteContent=true" "data/${i}.scope.in" && RSCOPES+=( ${i} )
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

pkg_postinst() {
	local ylp dvh rs

	has_version "gnome-extra/yelp" || ylp="to install gnome-extra/yelp package and "
	has_version "dev-util/devhelp" || dvh="to install dev-util/devhelp package and "

	echo
	use audacious && ! has_version "media-sound/audacious" && elog "audacious scope needs to install media-sound/audacious package." && echo
	use calculator && ! has_version "gnome-extra/gnome-calculator" && elog "calculator scope needs to install gnome-extra/gnome-calculator." && echo
	use chromiumbookmarks && ! has_version "www-client/chromium" && elog "chromiumbookmarks scope needs to install www-client/chromium package." && echo
	use devhelp && [[ -n ${dvh} ]] && elog "devhelp scope needs ${dvh/ and /.}" && echo
	use firefoxbookmarks && ! has_version "www-client/firefox" && elog "firefoxbookmarks scope needs to install www-client/firefox package." && echo
	use manpages && elog "manpages scope needs ${ylp}to run mandb to create or update the manual page index caches." && echo
	use texdoc && ([[ -n ${dvh} ]] || ! has_version "app-text/texlive-core[doc]") && elog "texdoc scope needs ${dvh}to install app-text/texlive-core[doc] package." && echo
	use virtualbox && ! has_version "app-emulation/virtualbox" && elog "virtualbox scope needs to install app-emulation/virtualbox package." && echo
	use yelp && [[ -n ${ylp} ]] && elog "yelp scope needs ${ylp/ and /.}" && echo

	if [[ -n ${RSCOPES} ]]; then
		elog "Remote scopes need 'Include online search results' option to be turned on."
		elog "The option is located in System Settings > Security & Privacy > Search tab."
		echo
		elog "Installed remote scopes:"
		for rs in "${RSCOPES[@]}"; do
			elog "${rs}"
		done
		echo
	fi
}
