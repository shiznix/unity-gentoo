# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qt5-build.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @BLURB: Eclass for Qt5 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt5.
# Requires EAPI 5.

case ${EAPI} in
	5)	: ;;
	*)	die "qt5-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit eutils flag-o-matic multilib toolchain-funcs versionator

HOMEPAGE="http://qt-project.org/ http://qt.digia.com/"
LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="5"

# @ECLASS-VARIABLE: QT5_MODULE
# @DESCRIPTION:
# The upstream name of the module this package belongs to. Used for
# SRC_URI and EGIT_REPO_URI. Must be defined before inheriting the eclass.
: ${QT5_MODULE:=${PN}}

case ${PV} in
	5.9999)
		# git dev branch
		QT5_BUILD_TYPE="live"
		EGIT_BRANCH="dev"
		;;
	5.?.9999)
		# git stable branch
		QT5_BUILD_TYPE="live"
		EGIT_BRANCH="stable"
		;;
	*_alpha?|*_beta?|*_rc?)
		# pre-releases
		QT5_BUILD_TYPE="release"
		MY_P="${QT5_MODULE}-opensource-src-${PV/_/-}"
		SRC_URI="http://download.qt-project.org/development_releases/qt/${PV%.*}/${PV/_/-}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
	*)
		# official stable releases
		QT5_BUILD_TYPE="release"
		MY_P="${QT5_MODULE}-opensource-src-${PV}"
		SRC_URI="http://download.qt-project.org/official_releases/qt/${PV%.*}/${PV}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
esac

EGIT_REPO_URI=(
	"git://gitorious.org/qt/${QT5_MODULE}.git"
	"https://git.gitorious.org/qt/${QT5_MODULE}.git"
)
[[ ${QT5_BUILD_TYPE} == "live" ]] && inherit git-r3

IUSE="debug test"

DEPEND="
	>=dev-lang/perl-5.14
	virtual/pkgconfig
"
if [[ ${PN} != "qttest" ]]; then
	if [[ ${QT5_MODULE} == "qtbase" ]]; then
		DEPEND+=" test? ( ~dev-qt/qttest-${PV}[debug=] )"
	else
		DEPEND+=" test? ( >=dev-qt/qttest-${PV}:5[debug=] )"
	fi
fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install src_test pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing all the patches to be applied. This variable
# is expected to be defined in the global scope of ebuilds. Make sure to
# specify the full path. This variable is used in src_prepare phase.
#
# Example:
# @CODE
#	PATCHES=(
#		"${FILESDIR}/mypatch.patch"
#		"${FILESDIR}/mypatch2.patch"
#	)
# @CODE

# @ECLASS-VARIABLE: QT5_TARGET_SUBDIRS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing the source directories that should be built.
# All paths must be relative to ${S}.

# @ECLASS-VARIABLE: QT5_BUILD_DIR
# @DESCRIPTION:
# Build directory for out-of-source builds.
: ${QT5_BUILD_DIR:=${S}_build}

# @ECLASS-VARIABLE: QT5_VERBOSE_BUILD
# @DESCRIPTION:
# Set to false to reduce build output during compilation.
: ${QT5_VERBOSE_BUILD:=true}

# @ECLASS-VARIABLE: QCONFIG_ADD
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of options that must be added to QT_CONFIG in qconfig.pri

# @ECLASS-VARIABLE: QCONFIG_REMOVE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of options that must be removed from QT_CONFIG in qconfig.pri

# @ECLASS-VARIABLE: QCONFIG_DEFINE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of macros that must be defined in QtCore/qconfig.h

# @FUNCTION: qt5-build_pkg_setup
# @DESCRIPTION:
# Warns and/or dies if the user is trying to downgrade Qt.
qt5-build_pkg_setup() {
	# Warn users of possible breakage when downgrading to a previous release.
	# Downgrading revisions within the same release is safe.
	if has_version ">${CATEGORY}/${P}-r9999:5"; then
		ewarn
		ewarn "Downgrading Qt is completely unsupported and can break your system!"
		ewarn
	fi
}

# @FUNCTION: qt5-build_src_unpack
# @DESCRIPTION:
# Unpacks the sources.
qt5-build_src_unpack() {
	if ! version_is_at_least 4.4 $(gcc-version); then
		ewarn
		ewarn "Using a GCC version lower than 4.4 is not supported."
		ewarn
	fi

	if [[ ${PN} == "qtwebkit" ]]; then
		eshopts_push -s extglob
		if is-flagq '-g?(gdb)?([1-9])'; then
			ewarn
			ewarn "You have enabled debug info (probably have -g or -ggdb in your CFLAGS/CXXFLAGS)."
			ewarn "You may experience really long compilation times and/or increased memory usage."
			ewarn "If compilation fails, please try removing -g/-ggdb before reporting a bug."
			ewarn "For more info check out https://bugs.gentoo.org/307861"
			ewarn
		fi
		eshopts_pop
	fi

	case ${QT5_BUILD_TYPE} in
		live)
			git-r3_src_unpack
			;;
		release)
			default
			;;
	esac
}

# @FUNCTION: qt5-build_src_prepare
# @DESCRIPTION:
# Prepares the sources before the configure phase.
qt5-build_src_prepare() {
	qt5_prepare_env

	if [[ ${QT5_MODULE} == "qtbase" ]]; then
		# Avoid unnecessary qmake recompilations
		sed -i -re "s|^if true;.*(\[ '\!').*(\"\\\$outpath/bin/qmake\".*)|if \1 -e \2 then|" \
			configure || die "sed failed (skip qmake bootstrap)"

		# Respect CC, CXX, *FLAGS, MAKEOPTS and EXTRA_EMAKE when bootstrapping qmake
		sed -i -e "/outpath\/qmake\".*\"\$MAKE\")/ s:): \
			${MAKEOPTS} ${EXTRA_EMAKE} 'CC=$(tc-getCC)' 'CXX=$(tc-getCXX)' \
			'QMAKE_CFLAGS=${CFLAGS}' 'QMAKE_CXXFLAGS=${CXXFLAGS}' 'QMAKE_LFLAGS=${LDFLAGS}'&:" \
			-e '/"$CFG_RELEASE_QMAKE"/,/^\s\+fi$/ d' \
			configure || die "sed failed (respect env for qmake build)"
		sed -i -e '/^CPPFLAGS\s*=/ s/-g //' \
			qmake/Makefile.unix || die "sed failed (CPPFLAGS for qmake build)"

		# Reset QMAKE_*FLAGS_{RELEASE,DEBUG} variables,
		# or they will override user's flags (bug 427782)
		sed -i -e '/^SYSTEM_VARIABLES=/ i \
			QMakeVar set QMAKE_CFLAGS_RELEASE\
			QMakeVar set QMAKE_CFLAGS_DEBUG\
			QMakeVar set QMAKE_CXXFLAGS_RELEASE\
			QMakeVar set QMAKE_CXXFLAGS_DEBUG\
			QMakeVar set QMAKE_LFLAGS_RELEASE\
			QMakeVar set QMAKE_LFLAGS_DEBUG\n' \
			configure || die "sed failed (QMAKE_*FLAGS_{RELEASE,DEBUG})"

		# Respect CXX in configure
		sed -i -e "/^QMAKE_CONF_COMPILER=/ s:=.*:=\"$(tc-getCXX)\":" \
			configure || die "sed failed (QMAKE_CONF_COMPILER)"

		# Respect toolchain and flags in config.tests
		find config.tests/unix -name '*.test' -type f -print0 | xargs -0 \
			sed -ri -e '/CXXFLAGS=/ s/"(\$CXXFLAGS) (\$PARAM)"/"\2 \1"/' \
				-e '/LFLAGS=/ s/"(\$LFLAGS) (\$PARAM)"/"\2 \1"/' \
				-e '/bin\/qmake/ s/-nocache //' \
			|| die "sed failed (config.tests)"
	fi

	if [[ ${PN} != "qtcore" ]]; then
		qt5_symlink_tools_to_buildtree
	fi

	# Apply patches
	[[ -n ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
	epatch_user
}

# @FUNCTION: qt5-build_src_configure
# @DESCRIPTION:
# Runs qmake, possibly preceded by ./configure.
qt5-build_src_configure() {
	# toolchain setup
	tc-export CC CXX RANLIB STRIP
	# qmake-generated Makefiles use LD/LINK for linking
	export LD="$(tc-getCXX)"

	mkdir -p "${QT5_BUILD_DIR}" || die
	pushd "${QT5_BUILD_DIR}" > /dev/null || die

	if [[ ${QT5_MODULE} == "qtbase" ]]; then
		qt5_base_configure
	fi

	qt5_foreach_target_subdir qt5_qmake

	popd > /dev/null || die
}

# @FUNCTION: qt5-build_src_compile
# @DESCRIPTION:
# Compiles the code in target directories.
qt5-build_src_compile() {
	qt5_foreach_target_subdir emake
}

# @FUNCTION: qt5-build_src_test
# @DESCRIPTION:
# Runs tests in target directories.
# TODO: find a way to avoid circular deps with USE=test.
qt5-build_src_test() {
	echo ">>> Test phase [QtTest]: ${CATEGORY}/${PF}"

	# create a custom testrunner script that correctly sets
	# {,DY}LD_LIBRARY_PATH before executing the given test
	local testrunner=${QT5_BUILD_DIR}/gentoo-testrunner
	cat <<-EOF > "${testrunner}"
	#!/bin/sh
	export LD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QT5_LIBDIR}"
	export DYLD_LIBRARY_PATH="${QT5_BUILD_DIR}/lib:${QT5_LIBDIR}"
	"\$@"
	EOF
	chmod +x "${testrunner}"

	qt5_foreach_target_subdir qt5_qmake
	qt5_foreach_target_subdir emake
	qt5_foreach_target_subdir emake TESTRUNNER="'${testrunner}'" check
}

# @FUNCTION: qt5-build_src_install
# @DESCRIPTION:
# Performs the actual installation of target directories.
qt5-build_src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install

	if [[ ${PN} == "qtcore" ]]; then
		pushd "${QT5_BUILD_DIR}" > /dev/null || die
		einfo "Running emake INSTALL_ROOT=${D} install_{mkspecs,qmake,syncqt}"
		emake INSTALL_ROOT="${D}" install_{mkspecs,qmake,syncqt}
		popd > /dev/null || die

		# create an empty Gentoo/gentoo-qconfig.h
		dodir "${QT5_HEADERDIR#${EPREFIX}}"/Gentoo
		: > "${D}${QT5_HEADERDIR}"/Gentoo/gentoo-qconfig.h

		# include gentoo-qconfig.h at the beginning of QtCore/qconfig.h
		sed -i -e '2a#include <Gentoo/gentoo-qconfig.h>\n' \
			"${D}${QT5_HEADERDIR}"/QtCore/qconfig.h \
			|| die "sed failed (qconfig.h)"
	fi

	qt5_install_module_qconfigs

	# remove .la files since we are building only shared libraries
	prune_libtool_files
}

# @FUNCTION: qt5-build_pkg_postinst
# @DESCRIPTION:
# Regenerate configuration, plus throw a message about possible
# breakages and proposed solutions.
qt5-build_pkg_postinst() {
	qt5_regenerate_global_qconfigs
}

# @FUNCTION: qt5-build_pkg_postrm
# @DESCRIPTION:
# Regenerate configuration when the package is completely removed.
qt5-build_pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${PN} != "qtcore" ]]; then
		qt5_regenerate_global_qconfigs
	fi
}

# @FUNCTION: qt_use
# @USAGE: <flag> [feature] [enableval]
# @DESCRIPTION:
# This will echo "-${enableval}-${feature}" if <flag> is enabled, or
# "-no-${feature}" if it's disabled. If [feature] is not specified,
# <flag> will be used for that. If [enableval] is not specified, the
# "-${enableval}" prefix is omitted.
qt_use() {
	use "$1" && echo "${3:+-$3}-${2:-$1}" || echo "-no-${2:-$1}"
}

# @FUNCTION: qt_use_disable_mod
# @USAGE: <flag> <module> <files...>
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <module> is the (lowercase) name of a Qt5 module.
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to treat <module> as not installed
# when <flag> is disabled, otherwise it does nothing.
# This can be useful to avoid an automagic dependency when the module
# is present on the system but the corresponding USE flag is disabled.
qt_use_disable_mod() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least 3 arguments"

	local flag=$1
	local module=$2
	shift 2

	use "${flag}" && return

	echo "$@" | xargs sed -i -e "s/qtHaveModule(${module})/false/g" || die
}


######  Internal functions  ######

# @FUNCTION: qt5_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt5_prepare_env() {
	# setup installation directories
	QT5_PREFIX=${EPREFIX}/usr
	QT5_HEADERDIR=${QT5_PREFIX}/include/qt5
	QT5_LIBDIR=${QT5_PREFIX}/$(get_libdir)
	QT5_ARCHDATADIR=${QT5_PREFIX}/$(get_libdir)/qt5
	QT5_BINDIR=${QT5_ARCHDATADIR}/bin
	QT5_PLUGINDIR=${QT5_ARCHDATADIR}/plugins
	QT5_LIBEXECDIR=${QT5_ARCHDATADIR}/libexec
	QT5_IMPORTDIR=${QT5_ARCHDATADIR}/imports
	QT5_QMLDIR=${QT5_ARCHDATADIR}/qml
	QT5_DATADIR=${QT5_PREFIX}/share/qt5
	QT5_DOCDIR=${QT5_PREFIX}/share/doc/qt-${PV}
	QT5_TRANSLATIONDIR=${QT5_DATADIR}/translations
	QT5_EXAMPLESDIR=${QT5_DATADIR}/examples
	QT5_TESTSDIR=${QT5_DATADIR}/tests
	QT5_SYSCONFDIR=${EPREFIX}/etc/qt5

	# see mkspecs/features/qt_config.prf
	export QMAKEMODULES="${QT5_BUILD_DIR}/mkspecs/modules:${S}/mkspecs/modules:${QT5_ARCHDATADIR}/mkspecs/modules"
}

# @FUNCTION: qt5_symlink_tools_to_buildtree
# @INTERNAL
# @DESCRIPTION:
# Symlinks qtcore tools to buildtree, so they can be used when building other modules.
qt5_symlink_tools_to_buildtree() {
	mkdir -p "${QT5_BUILD_DIR}"/bin || die

	local bin
	for bin in "${QT5_BINDIR}"/{qmake,moc,rcc,uic,qdoc,qdbuscpp2xml,qdbusxml2cpp}; do
		if [[ -e ${bin} ]]; then
			ln -s "${bin}" "${QT5_BUILD_DIR}"/bin/ || die "failed to symlink ${bin}"
		fi
	done
}

# @FUNCTION: qt5_base_configure
# @INTERNAL
# @DESCRIPTION:
# Runs ./configure for modules belonging to qtbase.
qt5_base_configure() {
	# configure arguments
	local conf=(
		# installation paths
		-prefix "${QT5_PREFIX}"
		-bindir "${QT5_BINDIR}"
		-headerdir "${QT5_HEADERDIR}"
		-libdir "${QT5_LIBDIR}"
		-archdatadir "${QT5_ARCHDATADIR}"
		-plugindir "${QT5_PLUGINDIR}"
		-libexecdir "${QT5_LIBEXECDIR}"
		-importdir "${QT5_IMPORTDIR}"
		-qmldir "${QT5_QMLDIR}"
		-datadir "${QT5_DATADIR}"
		-docdir "${QT5_DOCDIR}"
		-translationdir "${QT5_TRANSLATIONDIR}"
		-sysconfdir "${QT5_SYSCONFDIR}"
		-examplesdir "${QT5_EXAMPLESDIR}"
		-testsdir "${QT5_TESTSDIR}"

		# debug/release
		$(use debug && echo -debug || echo -release)
		-no-separate-debug-info

		# licensing stuff
		-opensource -confirm-license

		# build shared libraries
		-shared

		# disabling accessibility support is not recommended by upstream,
		# as it will break QStyle and may break other internal parts of Qt
		-accessibility

		# use pkg-config to detect include and library paths
		-pkg-config

		# prefer system libraries
		-system-zlib
		-system-pcre
		-system-xcb
		-system-xkbcommon

		# exclude examples and tests from default build
		-nomake examples
		-nomake tests

		# disable rpath on non-prefix (bugs 380415 and 417169)
		$(use prefix || echo -no-rpath)

		# verbosity of the configure and build phases
		-verbose $(${QT5_VERBOSE_BUILD} || echo -silent)

		# don't strip
		-no-strip

		# precompiled headers aren't really useful for us
		# and cause problems on hardened, so turn them off
		-no-pch

		# reduce relocations in libraries through extra linker optimizations
		# requires GNU ld >= 2.18
		-reduce-relocations

		# disable all SQL drivers by default, override in qtsql
		-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci -no-sql-odbc
		-no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -no-sql-tds

		# disable all platform plugins by default, override in qtgui
		-no-xcb -no-xrender -no-eglfs -no-directfb -no-linuxfb -no-kms

		# disable gtkstyle because it adds qt4 include paths to the compiler
		# command line if x11-libs/cairo is built with USE=qt4 (bug 433826)
		-no-gtkstyle

		# do not build with -Werror
		-no-warnings-are-errors

		# module-specific options
		"${myconf[@]}"
	)

	einfo "Configuring with: ${conf[@]}"
	"${S}"/configure "${conf[@]}" || die "configure failed"
}

# @FUNCTION: qt5_qmake
# @INTERNAL
# @DESCRIPTION:
# Helper function that runs qmake in the current target subdir.
# Intended to be called by qt5_foreach_target_subdir().
qt5_qmake() {
	local projectdir=${PWD/#${QT5_BUILD_DIR}/${S}}

	"${QT5_BUILD_DIR}"/bin/qmake "${projectdir}" \
		|| die "qmake failed (${projectdir})"
}

# @FUNCTION: qt5_foreach_target_subdir
# @INTERNAL
# @DESCRIPTION:
# Executes the arguments inside each directory listed in QT5_TARGET_SUBDIRS.
qt5_foreach_target_subdir() {
	[[ -z ${QT5_TARGET_SUBDIRS[@]} ]] && QT5_TARGET_SUBDIRS=("")

	local subdir
	for subdir in "${QT5_TARGET_SUBDIRS[@]}"; do
		if [[ ${EBUILD_PHASE} == "test" ]]; then
			subdir=tests/auto${subdir#src}
			[[ -d ${S}/${subdir} ]] || continue
		fi

		mkdir -p "${QT5_BUILD_DIR}/${subdir}" || die
		pushd "${QT5_BUILD_DIR}/${subdir}" > /dev/null || die

		einfo "Running $* ${subdir:+in ${subdir}}"
		"$@"

		popd > /dev/null || die
	done
}

# @FUNCTION: qt5_install_module_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Creates and installs gentoo-specific ${PN}-qconfig.{h,pri} files.
qt5_install_module_qconfigs() {
	local x

	# qconfig.h
	: > "${T}"/${PN}-qconfig.h
	for x in "${QCONFIG_DEFINE[@]}"; do
		echo "#define ${x}" >> "${T}"/${PN}-qconfig.h
	done
	[[ -s ${T}/${PN}-qconfig.h ]] && (
		insinto "${QT5_HEADERDIR#${EPREFIX}}"/Gentoo
		doins "${T}"/${PN}-qconfig.h
	)

	# qconfig.pri
	: > "${T}"/${PN}-qconfig.pri
	[[ -n ${QCONFIG_ADD[@]} ]] && echo "QCONFIG_ADD=${QCONFIG_ADD[@]}" \
		>> "${T}"/${PN}-qconfig.pri
	[[ -n ${QCONFIG_REMOVE[@]} ]] && echo "QCONFIG_REMOVE=${QCONFIG_REMOVE[@]}" \
		>> "${T}"/${PN}-qconfig.pri
	[[ -s ${T}/${PN}-qconfig.pri ]] && (
		insinto "${QT5_ARCHDATADIR#${EPREFIX}}"/mkspecs/gentoo
		doins "${T}"/${PN}-qconfig.pri
	)
}

# @FUNCTION: qt5_regenerate_global_qconfigs
# @INTERNAL
# @DESCRIPTION:
# Generates gentoo-specific qconfig.{h,pri}.
# Don't die here because dying in pkg_post{inst,rm} just makes things worse.
qt5_regenerate_global_qconfigs() {
	einfo "Regenerating gentoo-qconfig.h"

	find "${ROOT%/}${QT5_HEADERDIR}"/Gentoo \
		-name '*-qconfig.h' -a \! -name 'gentoo-qconfig.h' -type f \
		-execdir cat '{}' + > "${T}"/gentoo-qconfig.h

	[[ -s ${T}/gentoo-qconfig.h ]] || ewarn "Generated gentoo-qconfig.h is empty"
	mv -f "${T}"/gentoo-qconfig.h "${ROOT%/}${QT5_HEADERDIR}"/Gentoo/gentoo-qconfig.h \
		|| eerror "Failed to install new gentoo-qconfig.h"

	einfo "Updating QT_CONFIG in qconfig.pri"

	local qconfig_pri=${ROOT%/}${QT5_ARCHDATADIR}/mkspecs/qconfig.pri
	if [[ -f ${qconfig_pri} ]]; then
		local x qconfig_add= qconfig_remove=
		local qt_config=$(sed -n 's/^QT_CONFIG\s*+=\s*//p' "${qconfig_pri}")
		local new_qt_config=

		# generate list of QT_CONFIG entries from the existing list,
		# appending QCONFIG_ADD and excluding QCONFIG_REMOVE
		eshopts_push -s nullglob
		for x in "${ROOT%/}${QT5_ARCHDATADIR}"/mkspecs/gentoo/*-qconfig.pri; do
			qconfig_add+=" $(sed -n 's/^QCONFIG_ADD=\s*//p' "${x}")"
			qconfig_remove+=" $(sed -n 's/^QCONFIG_REMOVE=\s*//p' "${x}")"
		done
		eshopts_pop
		for x in ${qt_config} ${qconfig_add}; do
			if ! has "${x}" ${new_qt_config} ${qconfig_remove}; then
				new_qt_config+=" ${x}"
			fi
		done

		# now replace the existing QT_CONFIG with the generated list
		sed -i -e "s/^QT_CONFIG\s*+=.*/QT_CONFIG +=${new_qt_config}/" \
			"${qconfig_pri}" || eerror "Failed to sed QT_CONFIG in ${qconfig_pri}"
	else
		ewarn "${qconfig_pri} does not exist or is not a regular file"
	fi
}
