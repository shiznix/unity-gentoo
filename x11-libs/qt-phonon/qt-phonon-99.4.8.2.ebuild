# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-phonon/qt-phonon-4.8.2.ebuild,v 1.2 2012/06/19 22:36:05 pesa Exp $

EAPI=4

inherit qt4-build

DESCRIPTION="The Phonon module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="dbus qt3support"

DEPEND="
	~x11-libs/qt-gui-${PV}[aqua=,c++0x=,qpa=,debug=,qt3support=]
	!kde-base/phonon-kde
	!kde-base/phonon-xine
	!media-libs/phonon
	!media-sound/phonon
	!aqua? ( media-libs/gstreamer
		 media-plugins/gst-plugins-meta )
	aqua? ( ~x11-libs/qt-opengl-${PV}[aqua,debug=,qt3support=] )
	dbus? ( ~x11-libs/qt-dbus-${PV}[aqua=,c++0x=,qpa=,debug=] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-qatomic-x32.patch"
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/phonon
		src/plugins/phonon
		tools/designer/src/plugins/phononwidgets"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include
		src
		tools"

	QCONFIG_ADD="phonon"
	QCONFIG_DEFINE="QT_PHONON
			$(use !aqua && echo QT_GSTREAMER)"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-phonon -phonon-backend -no-opengl -no-svg
		$(qt_use dbus qdbus)
		$(qt_use qt3support)"

	qt4-build_src_configure
}
