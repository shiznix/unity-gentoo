# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Merge this to setup the Unity desktop build environment package.{accept_keywords,mask,use} files"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="yakkety"
UVER=

LICENSE="GPL-2"
SLOT="0/${URELEASE}"
KEYWORDS="amd64 x86"
IUSE=""

pkg_setup() {
	mkdir -p "${S}"
}

src_install() {
	local REPO_ROOT="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	local PROFILE_RELEASE=$(eselect --brief profile show | sed -n 's/.*:\(.*\)\/.*/\1/p')

	if [ -z "${REPO_ROOT}" ] || [ -z "${PROFILE_RELEASE}" ]; then
		die "Failed to detect unity-gentoo overlay and/or profile"
	fi

	for pfile in {env,accept_keywords,mask,unmask,use}; do
		dodir "/etc/portage/package.${pfile}"
		dosym "${REPO_ROOT}/profiles/${PROFILE_RELEASE}/unity-portage.p${pfile}" \
			"/etc/portage/package.${pfile}/unity-portage.p${pfile}" || die
	done

	dodir "/etc/portage/env"
	for envconf in $(ls -1 ${REPO_ROOT}/profiles/${PROFILE_RELEASE}/env/* | awk -F/ '{print $NF}'); do
		dosym "${REPO_ROOT}/profiles/${PROFILE_RELEASE}/env/${envconf}" \
			"/etc/portage/env/${envconf}" || die
	done

	# Old mono deps. have the potential to fail as >=dev-lang/mono-4.0.5 needed for gcc:5 migration #
	#       removes /usr/bin/gmcs to now be /usr/bin/mcs most of these small mono projects seem to be suffering from bitrot #
	dosym /usr/bin/mcs /usr/bin/gmcs        # Is there a better alternative?
}

pkg_postinst() {
	echo
	elog "If you have recently changed profile then you should re-run 'emerge -uDNavt --backtrack=30 @world' to catch any upgrades"
	echo
}
