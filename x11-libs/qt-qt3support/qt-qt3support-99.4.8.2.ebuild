EAPI=4

inherit qt4-build

DESCRIPTION="The Qt3 support module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="+accessibility"

DEPEND="
	~x11-libs/qt-core-${PV}[aqua=,c++0x=,debug=,qpa=,qt3support]
	~x11-libs/qt-gui-${PV}[accessibility=,aqua=,c++0x=,debug=,qpa=,qt3support]
	~x11-libs/qt-sql-${PV}[aqua=,c++0x=,debug=,qpa=,qt3support]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-qatomic-x32.patch"
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/qt3support
		src/tools/uic3
		tools/designer/src/plugins/widgets
		tools/porting"

	QT4_EXTRACT_DIRECTORIES="
		src
		include
		tools"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-qt3support
		$(qt_use accessibility)"

	qt4-build_src_configure
}
