EAPI=5
VALA_MIN_API_VERSION="0.20"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils ubuntu-versionator vala

UURL="http://archive.ubuntu.com/ubuntu/pool/main/b/${PN}"
URELEASE="raring"
UVER_PREFIX="daily13.04.03"

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0/1.0.0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/gobject-introspection
	dev-libs/libunity
	dev-libs/libunity-webapps
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3
	x11-libs/libXfixes"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_prepare() {
	vala_src_prepare
	export VALA_API_GEN=$VAPIGEN
	sed -e "s:-Werror::g" \
		-i "configure.ac" || die
	eautoreconf
}

src_configure() {
	econf \
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

	prune_libtool_files --modules
}
