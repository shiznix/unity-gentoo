EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libi/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection"

RDEPEND="dev-dotnet/gtk-sharp:2
	>=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.18:2
	>=dev-libs/libdbusmenu-0.6.1:3[introspection?]
	dev-libs/libxml2:2
	>=dev-python/pygtk-2.10
	=x11-libs/gtk+-99.3.4.2
	=x11-libs/libXfixes-5.0-r9999
	introspection? ( dev-libs/gobject-introspection )
	!<${CATEGORY}/${PN}-0.6.1-r201"
DEPEND="${RDEPEND}
        gnome-base/gnome-common
        app-text/gnome-doc-utils
        dev-util/gtk-doc-am
        dev-lang/vala:0.14[vapigen]
        virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	export VALAC=$(type -P valac-0.14)
	export VALA_API_GEN=$(type -p vapigen-0.14)

	# "Only <glib.h> can be included directly." #
	sed -e "s:glib/gmessages.h:glib.h:g" \
		-i libindicate/indicator.c
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-static \
		$(use_enable introspection) \
		--with-gtk=3 \
		--with-html-dir=/usr/share/doc/${PF}
}
