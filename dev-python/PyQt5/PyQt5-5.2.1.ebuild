# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit eutils python-r1 qmake-utils toolchain-funcs

DESCRIPTION="Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/pyqt/intro/ http://pypi.python.org/pypi/PyQt"

MY_P="PyQt-gpl-${PV}"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="5"
KEYWORDS="~alpha ~amd64 arm ~ia64 ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror"

# QT Modules needing ebuilds #
# 	QtSensors, QtSerialPort, QtAxContainer, QtHelp, QtTest #

IUSE="X dbus debug designer doc examples kde multimedia opengl print qml sql svg webkit widgets xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	designer? ( X )
	multimedia? ( X )
	opengl? ( X )
	qml? ( X )
	sql? ( X )
	svg? ( X )
	webkit? ( X )
	widgets? ( X )
"

# Supported version stream of Qt.
QT_PV="${PV}:5"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/python-exec:2[${PYTHON_USEDEP}]
	>=dev-python/sip-4.15.5:=[${PYTHON_USEDEP}]
	~dev-qt/qtcore-${QT_PV}
	X? (
		>=dev-qt/qtgui-${QT_PV}
		~dev-qt/qttest-${QT_PV}
	)
	dbus? (
		>=dev-python/dbus-python-0.80[${PYTHON_USEDEP}]
		~dev-qt/qtdbus-${QT_PV}
	)
	designer? ( ~dev-qt/designer-${QT_PV} )
	multimedia? ( ~dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( ~dev-qt/qtopengl-${QT_PV} )
	print? ( ~dev-qt/qtprintsupport-${QT_PV} )
	qml? ( >=dev-qt/qtdeclarative-${QT_PV} )
	sql? ( ~dev-qt/qtsql-${QT_PV} )
	svg? ( ~dev-qt/qtsvg-${QT_PV} )
	webkit? ( >=dev-qt/qtwebkit-5.1.1 )
	xmlpatterns? ( ~dev-qt/qtxmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	dbus? ( virtual/pkgconfig )
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	export PATH="/usr/$(get_libdir)/qt5/bin:${PATH}"	# Need to see QT5's qmake

	if ! use dbus; then
		sed -i -e 's/^\(\s\+\)check_dbus()/\1pass/' configure.py || die
	fi

	python_copy_sources

	preparation() {
		if [[ ${EPYTHON} == python3.* ]]; then
			rm -fr pyuic/uic/port_v2
		else
			rm -fr pyuic/uic/port_v3
		fi
	}
	python_foreach_impl run_in_build_dir preparation
}

pyqt5_use_enable() {
	use $1 && echo --enable=${2:-Qt$(tr 'a-z' 'A-Z' <<< ${1:0:1})${1:1}}
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}" configure.py
			--confirm-license
			--bindir="${EPREFIX}/usr/bin"
			--destdir="$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip/${PN}"
			--assume-shared
			--no-timestamp
			--qsci-api
			$(use debug && echo --debug)
			--enable=QtCore
			--enable=QtNetwork
			$(pyqt5_use_enable X QtGui)
			$(pyqt5_use_enable X QtTest)
			$(pyqt5_use_enable dbus QtDBus)
			$(pyqt5_use_enable designer QtDesigner)
			$(pyqt5_use_enable multimedia QtMultimedia)
			$(pyqt5_use_enable multimedia QtMultimediaWidgets)
			$(pyqt5_use_enable opengl QtOpenGL)
			$(pyqt5_use_enable print QtPrintSupport)
			$(pyqt5_use_enable qml QtQml)
			$(pyqt5_use_enable qml QtQuick)
			$(pyqt5_use_enable sql QtSql)
			$(pyqt5_use_enable svg QtSvg)
			$(pyqt5_use_enable webkit QtWebKit)
			$(pyqt5_use_enable webkit QtWebKitWidgets)
			$(pyqt5_use_enable widgets QtWidgets)
			$(pyqt5_use_enable xmlpatterns QtXmlPatterns)
			AR="$(tc-getAR) cqs"
			CC="$(tc-getCC)"
			CFLAGS="${CFLAGS}"
			CFLAGS_RELEASE=
			CXX="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CXXFLAGS_RELEASE=
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			LFLAGS="${LDFLAGS}"
			LFLAGS_RELEASE=
			RANLIB=
			STRIP=
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		local mod
		for mod in QtCore \
				$(use X && echo QtGui) \
				$(use dbus && echo QtDBus) \
				$(use designer && echo QtDesigner) \
				$(use qml && echo "QtQml QtQuick"); do
			# Run eqmake5 inside the qpy subdirectories to respect
			# CC, CXX, CFLAGS, CXXFLAGS, LDFLAGS and avoid stripping.
			pushd qpy/${mod} > /dev/null || return
				eqmake5 $(ls w_qpy*.pro)
			popd > /dev/null || return

			# Fix insecure runpaths.
			sed -i -e "/^LFLAGS\s*=/ s:-Wl,-rpath,${BUILD_DIR}/qpy/${mod}::" \
				${mod}/Makefile || die "failed to fix rpath for ${mod}"
		done

		# Avoid stripping of libpythonplugin.so.
		if use designer; then
			pushd designer > /dev/null || return
				eqmake5 python.pro
			popd > /dev/null || return
		fi
	}
	python_parallel_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		# INSTALL_ROOT is used by designer/Makefile, other Makefiles use DESTDIR.
		emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
		mkdir -p "${ED}"/usr/lib/python-exec/${EPYTHON} || die
		mv "${ED}"/usr/bin/pyuic5 "${ED}"/usr/lib/python-exec/${EPYTHON}/ || die
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	dosym ../lib/python-exec/python-exec2 /usr/bin/pyuic5
	dodoc NEWS

	if use doc; then
		dohtml -r doc/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
