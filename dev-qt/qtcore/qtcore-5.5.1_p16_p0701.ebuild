# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT5_MODULE="qtbase"
SLOT="5/5.5"

URELEASE="xenial-updates"
inherit qt5-build ubuntu-versionator

UURL="mirror://unity/pool/main/q/${QT5_MODULE}-opensource-src"
UVER_PREFIX="+dfsg"

DESCRIPTION="Cross-platform application development framework"
SRC_URI="${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${QT5_MODULE}-opensource-src_${PV}${UVER_PREFIX}-${UVER}.debian.tar.xz"
RESTRICT="mirror"
KEYWORDS="~amd64 ~x86"

IUSE="icu systemd"
DEPEND="
	dev-libs/glib:2
	>=dev-libs/libpcre-8.30[pcre16]
	sys-libs/zlib
	virtual/libiconv
	icu? ( dev-libs/icu:= )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${QT5_MODULE}-opensource-src-${PV}"
QT5_BUILD_DIR="${S}"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/corelib
	src/tools/qlalr
)

src_prepare() {
	ubuntu-versionator_src_prepare
	qt5-build_src_prepare
}

src_configure() {
	local myconf=(
		$(qt_use icu)
		$(qt_use systemd journald)
	)
	qt5-build_src_configure
}

src_install() {
	if has_version =dev-qt/qtcore-5*; then
		elog "If after upgrading QT5, applications exhibit similar runtime failures such as:"
		elog " undefined symbol: _ZNK..MetaObject.."
		elog "Then it will be necessary to rebuild installed applications that use the QT5 library"
		elog " using the following command:  revdep-rebuild --library 'libQt5Core.so'"
	fi
	qt5-build_src_install
}
