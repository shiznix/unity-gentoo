# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/t/${PN}"
URELEASE="utopic"
UVER_PREFIX="+14.10.20140814"

DESCRIPTION="Library that produces and stores thumbnails of image, audio and video files according to the Freedesktop thumbnail specification"
HOMEPAGE="https://launchpad.net/thumbnailer"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/libexif
	net-libs/libsoup:2.4
	x11-libs/gdk-pixbuf
	x11-misc/shared-mime-info"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
