EAPI=4

inherit eutils mono ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/libu/${PN}"
URELEASE="raring"

DESCRIPTION="GTK widgets for integration of Ubuntu One functionalities into GTK applications."
HOMEPAGE="https://launchpad.net/libubuntuone"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/python
	dev-libs/libxml2
	dev-libs/dbus-glib
	dev-libs/openssl
	dev-lang/mono
	dev-dotnet/gtk-sharp
	dev-dotnet/gtk-sharp-gapi
	>=dev-python/pygtk-2.10
	gnome-base/gconf
	gnome-base/gnome-keyring
	>=net-libs/webkit-gtk-1.1.15
	unity-base/ubuntuone-client"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	prune_libtool_files --modules
}
