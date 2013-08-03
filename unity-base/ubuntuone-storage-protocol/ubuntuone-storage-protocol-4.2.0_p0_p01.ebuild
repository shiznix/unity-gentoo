# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils ubuntu-versionator

UURL="mirror://ubuntu/pool/main/u/${PN}"
URELEASE="raring"

DESCRIPTION="Ubuntu One file storage and sharing service for the Unity desktop"
HOMEPAGE="https://launchpad.net/ubuntuone-storage-protocol"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/protobuf[python]"
RDEPEND="${DEPEND}
	dev-python/dirspec
	>=dev-python/oauth-1.0
	dev-python/pyopenssl
	>=dev-python/twisted-core-12.2.0
	dev-python/pyxdg"
