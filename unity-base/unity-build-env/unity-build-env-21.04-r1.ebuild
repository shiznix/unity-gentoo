# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit ubuntu-versionator

DESCRIPTION="Merge this to setup the Unity desktop build environment package.{accept_keywords,mask,use} files"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="hirsute"
UVER=

LICENSE="GPL-2"
SLOT="0/${URELEASE}"
KEYWORDS="amd64 x86"
IUSE="minimal"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	mkdir -p "${S}"
}

src_install() {
	for pfile in {accept_keywords,mask,unmask,use}; do
		dodir "/etc/portage/package.${pfile}"
		dosym "${REPO_ROOT}/profiles/releases/${PROFILE_RELEASE}/unity-portage.p${pfile}" \
			"/etc/portage/package.${pfile}/0000_unity-portage.p${pfile}" || die
	done

	use minimal \
		&& dosym "${REPO_ROOT}/profiles/releases/${PROFILE_RELEASE}/unity-portage-minimal.puse" \
			"/etc/portage/package.${pfile}/0001_unity-portage-minimal.puse"
}

pkg_postinst() {
	echo
	elog "If you have recently changed profile then you should re-run 'emerge -uDNavt --backtrack=30 @world' to catch any upgrades"
	echo
}
