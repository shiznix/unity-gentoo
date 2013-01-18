EAPI=4

inherit base qt4-r2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/s/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="Single Sign On framework for the Unity desktop"
HOMEPAGE="http://code.google.com/p/accounts-sso/"
SRC_URI="${UURL}/${MY_P}.orig.tar.bz2
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug doc"

DEPEND="x11-libs/qt-core
        x11-libs/qt-dbus
        x11-libs/qt-gui
        x11-libs/qt-sql
        x11-libs/qt-xmlpatterns
        doc? ( app-doc/doxygen )"

src_prepare() {
	# Fix building if sys-fs/cryptsetup is installed, requires specially patched cryptsetup #
	#  http://code.google.com/p/accounts-sso/issues/detail?id=114 #
	epatch -p1 "${FILESDIR}/cryptsetup-optional.patch"

	# Fix remotepluginprocess.cpp missing QDebug include on some systems #
	epatch "${FILESDIR}/remotepluginprocess-QDebug-fix.patch"

	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	use debug && \
		for file in $(grep -r debug * | grep \\.pro | awk -F: '{print $1}' | uniq); do
			sed -e 's:CONFIG -= debug_and_release:CONFIG += debug_and_release:g' \
				-i "${file}"
		done

	use doc || \
		for file in $(grep -r doc/doc.pri * | grep \\.pro | awk -F: '{print $1}'); do
			sed -e '/doc\/doc.pri/d' -i "${file}"
		done
}
