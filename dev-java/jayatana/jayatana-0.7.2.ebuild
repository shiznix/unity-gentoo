# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils java-utils-2

DESCRIPTION="Global Menu for Java applications"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu/tree/master/subprojects/jayatana
	https://gitlab.com/vala-panel-project/vala-panel-appmenu/releases"

COMMIT="3f19440d0dff20cebe692d7cfce00e10"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/${COMMIT}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="system-wide"
RESTRICT="mirror"

DEPEND=">=dev-libs/glib-2.40.0
	>=dev-libs/libdbusmenu-16.04.0
	>=virtual/jdk-1.8
	>=x11-libs/libxkbcommon-0.5.0"
RDEPEND="${DEPEND}"

src_configure() {
	sed -i \
		-e "/JAVADIR/{s/java/${PN}\/lib/}" \
		lib/config.h.in

	local mycmakeargs=(
		-DENABLE_JAYATANA=ON
		-DSTANDALONE=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED%/}"/usr/share/java || die
	java-pkg_dojar "${BUILD_DIR}"/java/"${PN}".jar "${BUILD_DIR}"/java/"${PN}"ag.jar

	if use system-wide; then
		exeinto /etc/X11/xinit/xinitrc.d
		doexe "${FILESDIR}"/90jayatana
		sed -i \
			-e "s:JAVA_AGENT:${JAVA_PKG_JARDEST}/${PN}ag.jar:" \
			"${ED%/}"/etc/X11/xinit/xinitrc.d/90jayatana
	fi
}

pkg_postinst() {
	if ! use system-wide; then
		einfo
		elog "Enabling Jayatana"
		einfo
		elog "1. System-wide way (recommended only if you have many Java programs with menus):"
		einfo
		elog "   Set 'system-wide' USE flag."
		einfo
		elog "2. Application-specific ways (useful if you usually have one or 2 Java programs, like Android Studio) and if above does not work."
		einfo
		elog "2.1. Intellij programs (Idea, PhpStorm, CLion, Android Studio)"
		einfo
		elog "   Edit *.vmoptions file, and add -javaagent:${JAVA_PKG_JARDEST}/${PN}ag.jar to the end of file."
		elog "   Edit *.properties file, and add linux.native.menu=true to the end of it."
		einfo
		elog "2.2. Netbeans"
		einfo
		elog "   Edit netbeans.conf, and add -J-javaagent:${JAVA_PKG_JARDEST}/${PN}ag.jar to the end of it."
		einfo
		elog "3. Enable agent via desktop file (for any single application)"
		einfo
		elog "   Add -javaagent:${JAVA_PKG_JARDEST}/${PN}ag.jar after Exec or TryExec line of application's desktop file (if application executes JAR directly). If application executes JAR via wrapper, and this option to the end of JVM options for running actual JAR."
		einfo
	fi
}
