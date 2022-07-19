# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Merge this to setup the Unity desktop build environment package.{accept_keywords,mask,use} files"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="jammy"
UVER=

LICENSE="GPL-2"
SLOT="0/${URELEASE}"
KEYWORDS="amd64 x86"
IUSE="minimal"

pkg_setup() {
	mkdir -p "${S}"
}

src_install() {
	local REPO_ROOT="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	#local PROFILE_RELEASE=$(eselect --brief profile show | sed -n 's/.*:\(.*\)\/.*/\1/p')
	local CURRENT_PROFILE=$(readlink /etc/portage/make.profile)
	local PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | awk -F/ '{print $(NF-0)}')

	if [ -z "${REPO_ROOT}" ] || [ -z "${PROFILE_RELEASE}" ]; then
		die "Failed to detect unity-gentoo overlay and/or profile"
	fi

#	for pfile in {env,accept_keywords,mask,unmask,use}; do
	for pfile in {accept_keywords,mask,unmask,use}; do
		dodir "/etc/portage/package.${pfile}"
		dosym "${REPO_ROOT}/profiles/releases/${PROFILE_RELEASE}/unity-portage.p${pfile}" \
			"/etc/portage/package.${pfile}/0000_unity-portage.p${pfile}" || die
	done

	use minimal \
		&& dosym "${REPO_ROOT}/profiles/releases/${PROFILE_RELEASE}/unity-portage-minimal.puse" \
			"/etc/portage/package.${pfile}/0001_unity-portage-minimal.puse"

#	dodir "/etc/portage/env"
#	for envconf in $(ls -1 ${REPO_ROOT}/profiles/releases/${PROFILE_RELEASE}/env/* | awk -F/ '{print $NF}'); do
#		dosym "${REPO_ROOT}/profiles/releases/${PROFILE_RELEASE}/env/${envconf}" \
#			"/etc/portage/env/${envconf}" || die
#	done
}

pkg_postinst() {
	echo
	elog "If you have recently changed profile then you should re-run 'emerge -uDNavt --backtrack=30 @world' to catch any upgrades"
	echo
}
