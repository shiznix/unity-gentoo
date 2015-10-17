# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user

DESCRIPTION="Sync, protect, and share your files with Copy from Barracuda."
HOMEPAGE="https://www.copy.com"
SRC_URI="https://copy.com/install/linux/Copy.tgz -> ${P}.tgz"

LICENSE="Barracuda Networks Inc."
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-qt/qtcore:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
QA_PRESTRIPPED="opt/${PN}/.*"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/copy ${WORKDIR}/${PN}
}

src_install () {
	local TARGETDIR="/opt/copy-agent"
	dodir "${TARGETDIR}"
	insinto "${TARGETDIR}"/

	if [[ "${ARCH}" == "amd64" ]]; then
		doins -r ${S}/x86_64/*  || die "Install failed!"
	elif [[ "${ARCH}" == "x86" ]];then
		doins -r ${S}/x86/*  || die "Install failed!"
	fi

	fowners root:users -R "${TARGETDIR}" || die "Could not change ownership of copy-agent directory."

	insinto /usr/share/pixmaps
	doins "${FILESDIR}"/copy-agent.png || die "Could not copy copy-agent.png"
}

pkg_postinst() {
	chmod 755 /opt/copy-agent/Copy* || die "Could not change permission on Copy* files."
	xdg-desktop-menu install "${FILESDIR}"/copy-agent.desktop
}

pkg_postrm() {
	xdg-desktop-menu uninstall "${FILESDIR}"/copy-agent.desktop
}
