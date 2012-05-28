EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/b/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection"

DEPEND="dev-lang/vala:0.14[vapigen]
	=x11-libs/gtk+-3.4.2-r9999
	=x11-libs/libXfixes-5.0-r9999"

src_configure() {
        export VALAC=$(type -P valac-0.14)
        export VALA_API_GEN=$(type -p vapigen-0.14)
	econf \
		$(use_enable introspection)
}

src_install() {
	DESTDIR="${D}" emake install

	# Install dbus interfaces #
	insinto /usr/share/dbus-1/interfaces
	doins src/org.ayatana.bamf.*xml

	# Create a fresh bamf.index from bamfdaemon.postinst #
	perl -ne '/^(.*?)=(.*)/; $$d{$ARGV}{$1} = $2; END { for $f (keys %$d) { printf "%s\t%s%s\n", $f =~ m{.*/([^/]+)$}, $$d{$f}{'Exec'},$$d{$f}{'StartupWMClass'} ? "\tBAMF_WM_CLASS::$$d{$f}{'StartupWMClass'}" : "" } }' \
		/usr/share/applications/*.desktop > bamf.index
	insinto /usr/share/applications
	doins bamf.index
}
