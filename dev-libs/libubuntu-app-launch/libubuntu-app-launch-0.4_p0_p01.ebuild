# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu-versionator

MY_PN="ubuntu-app-launch"
MY_P="${MY_PN}_${PV}"
#UURL="mirror://ubuntu/pool/main/u/${MY_PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140605.3"
UURL="https://launchpad.net/ubuntu/utopic/+source/ubuntu-app-launch/${PV}${UVER_PREFIX}-${UVER}/+files"

DESCRIPTION="An Upstart Job that is used to launch applications in a controlled and predictable manner. This is a small project, but there are *a lot* of different parts from different people, so we need a place to collaborate."
HOMEPAGE="https://launchpad.net/ubuntu-app-launch"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="+threads"
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libzeitgeist
	dev-libs/libupstart
	dev-util/lttng-tools
	dev-util/dbus-test-runner
	sys-apps/click
	sys-libs/libnih[dbus]"

S="${WORKDIR}/${MY_PN}-${PV}${UVER_PREFIX}"


src_install() {
	cmake-utils_src_install

	# Only install libraries and includes #
	rm -rf "${ED}usr/share" "${ED}usr/libexec" "${ED}usr/bin"
}
