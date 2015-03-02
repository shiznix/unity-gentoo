# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

URELEASE="utopic"
inherit cmake-utils ubuntu-versionator

MY_PN="ubuntu-app-launch"
MY_P="${MY_PN}_${PV}"
UURL="mirror://ubuntu/pool/main/u/${MY_PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Session init system job for launching applications, libraries only"
HOMEPAGE="https://launchpad.net/ubuntu-app-launch"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+threads"
RESTRICT="mirror"

DEPEND="app-admin/cgmanager
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libzeitgeist
	dev-libs/libupstart
	>=dev-util/lttng-tools-2.5.0
	dev-util/dbus-test-runner
	sys-apps/click
	sys-libs/libnih[dbus]"

S="${WORKDIR}/${MY_PN}-${PV}${UVER_PREFIX}"


src_install() {
	cmake-utils_src_install

	# Only install libraries and includes #
	rm -rf "${ED}usr/share" "${ED}usr/libexec" "${ED}usr/bin"
}
