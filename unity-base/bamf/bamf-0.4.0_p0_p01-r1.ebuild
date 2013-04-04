EAPI=4

inherit base eutils ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/b/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.03.07"

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/gobject-introspection
	dev-libs/libunity
	dev-libs/libunity-webapps
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3
	x11-libs/libXfixes"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	export VALAC=$(type -P valac-0.14) && \
	export VALA_API_GEN=$(type -p vapigen-0.14)
	epatch "${FILESDIR}/libbamf3.pc_missing-libwnck.diff"
}

src_configure() {
	sed -e "s:-Werror::g" \
		-i "configure.ac" || die

	./autogen.sh --prefix=/usr \
		--enable-introspection=yes \
		--disable-static || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	# Install dbus interfaces #
	insinto /usr/share/dbus-1/interfaces
	doins src/org.ayatana.bamf.*xml

	# Create a fresh bamf.index from bamfdaemon.postinst #
	perl -ne '/^(.*?)=(.*)/; $$d{$ARGV}{$1} = $2; END { for $f (keys %$d) { printf "%s\t%s%s\n", $f =~ m{.*/([^/]+)$}, $$d{$f}{'Exec'},$$d{$f}{'StartupWMClass'} ? "\tBAMF_WM_CLASS::$$d{$f}{'StartupWMClass'}" : "" } }' \
		/usr/share/applications/*.desktop > bamf.index
	insinto /usr/share/applications
	doins bamf.index
}
