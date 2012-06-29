EAPI=4

inherit qt4-build flag-o-matic

DESCRIPTION="The WebKit module for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi
IUSE="+gstreamer icu +jit"

# libxml2[!icu?] is needed for bugs 407315 and 411091
DEPEND="dev-db/sqlite:3
	x11-libs/libX11
	x11-libs/libXrender
	~x11-libs/qt-core-${PV}[aqua=,debug=,ssl,qpa=]
	~x11-libs/qt-gui-${PV}[aqua=,debug=,qpa=]
	~x11-libs/qt-xmlpatterns-${PV}[aqua=,debug=,qpa=]
	gstreamer? (
		dev-libs/glib:2
		dev-libs/libxml2:2[!icu?]
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)
	icu? ( dev-libs/icu )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.8.0-c++0x-fix.patch"
	"${FILESDIR}/${PN}-4.8.1+glib-2.31.patch"
	"${FILESDIR}/${PV}-qatomic-x32.patch"
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/3rdparty/webkit/Source/JavaScriptCore
		src/3rdparty/webkit/Source/WebCore
		src/3rdparty/webkit/Source/WebKit/qt
		tools/designer/src/plugins/qwebview"

	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools"

	QCONFIG_ADD="webkit"
	QCONFIG_DEFINE="QT_WEBKIT"

	qt4-build_pkg_setup
}

src_prepare() {
	use c++0x && append-cxxflags -fpermissive

	# Fix version number in generated pkgconfig file, bug 406443
	sed -i -e 's/^isEmpty(QT_BUILD_TREE)://' \
		src/3rdparty/webkit/Source/WebKit/qt/QtWebKit.pro || die

	# Remove -Werror from CXXFLAGS
	sed -i -e '/QMAKE_CXXFLAGS\s*+=/ s:-Werror::g' \
		src/3rdparty/webkit/Source/WebKit.pri || die

	if use icu; then
		sed -i -e '/CONFIG\s*+=\s*text_breaking_with_icu/ s:^#\s*::' \
			src/3rdparty/webkit/Source/JavaScriptCore/JavaScriptCore.pri || die
	fi

	qt4-build_src_prepare
}

src_configure() {
	myconf+="
		-webkit
		-system-sqlite
		$(qt_use icu)
		$(qt_use jit javascript-jit)
		$(use gstreamer || echo -DENABLE_VIDEO=0)"

	qt4-build_src_configure
}
