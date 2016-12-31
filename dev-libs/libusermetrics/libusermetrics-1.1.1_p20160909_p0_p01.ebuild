# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

URELEASE="yakkety"
inherit cmake-utils gnome2-utils ubuntu-versionator user

UURL="mirror://ubuntu/pool/main/libu/${PN}"
UVER_PREFIX="+${UVER_RELEASE}.${PVR_MICRO}"

DESCRIPTION="Library for retrieving anonymous metrics about users"
HOMEPAGE="http://launchpad.net/libusermetrics"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-db/qdjango
	dev-libs/libqtdbustest
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtxmlpatterns:5
	dev-util/cmake-extras
	sys-libs/libapparmor
	x11-libs/gsettings-qt"

S="${WORKDIR}"

pkg_preinst() {
	gnome2_schemas_savelist

	enewgroup usermetrics || die "problem adding 'usermetrics' group"
	enewuser usermetrics -1 -1 /var/lib/usermetrics "usermetrics" || die "problem adding 'usermetrics' user"
	keepdir /var/lib/usermetrics
	fowners usermetrics:usermetrics /var/lib/usermetrics
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
