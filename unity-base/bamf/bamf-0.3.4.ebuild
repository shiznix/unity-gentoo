EAPI=4

inherit base eutils

UURL="http://archive.ubuntu.com/ubuntu/pool/main/b/${PN}"
UVER="0ubuntu1"
URELEASE="quantal-updates"
MY_P="${P/-/_}"

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection"

DEPEND="dev-lang/vala:0.14[vapigen]
	dev-libs/libunity
	unity-base/unity-webapps
	>=x11-libs/gtk+-99.2.24.10:2
	>=x11-libs/gtk+-99.3.4.2:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3
	=x11-libs/libXfixes-5.0-r9999"

src_prepare() {
	use introspection && \
		export VALAC=$(type -P valac-0.14) && \
		export VALA_API_GEN=$(type -p vapigen-0.14)
}

src_configure() {
	# Build GTK2 support #
	[[ -d build-gtk2 ]] || mkdir build-gtk2
	pushd build-gtk2
	../configure --prefix=/usr \
		$(use_enable introspection) \
		--disable-static \
		--with-gtk=2 || die
	popd

	# Build GTK3 support #
	[[ -d build-gtk3 ]] || mkdir build-gtk3
	pushd build-gtk3
	../configure --prefix=/usr \
		$(use_enable introspection) \
		--disable-static \
		--with-gtk=3 || die
	popd
}

src_install() {
	# Install GTK2 support #
	pushd build-gtk2
	emake DESTDIR="${D}" install || die
	popd

	# Install GTK3 support #
	pushd build-gtk3
	emake DESTDIR="${D}" install || die
	popd

	# Install dbus interfaces #
	insinto /usr/share/dbus-1/interfaces
	doins src/org.ayatana.bamf.*xml

	# Create a fresh bamf.index from bamfdaemon.postinst #
	perl -ne '/^(.*?)=(.*)/; $$d{$ARGV}{$1} = $2; END { for $f (keys %$d) { printf "%s\t%s%s\n", $f =~ m{.*/([^/]+)$}, $$d{$f}{'Exec'},$$d{$f}{'StartupWMClass'} ? "\tBAMF_WM_CLASS::$$d{$f}{'StartupWMClass'}" : "" } }' \
		/usr/share/applications/*.desktop > bamf.index
	insinto /usr/share/applications
	doins bamf.index
}
