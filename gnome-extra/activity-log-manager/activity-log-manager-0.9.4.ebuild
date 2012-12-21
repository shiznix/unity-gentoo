EAPI=4

inherit autotools base eutils gnome2

UURL="http://archive.ubuntu.com/ubuntu/pool/main/a/${PN}"
UVER="0ubuntu6.1"
URELEASE="raring"
MY_P="${P/manager-/manager_}"

DESCRIPTION="Blacklist configuration user interface for Zeitgeist"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}.orig.tar.gz
	${UURL}/${MY_P}-${UVER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/vala:0.16[vapigen]
	dev-libs/glib:2
	dev-libs/libgee:0
	dev-libs/libzeitgeist
	gnome-extra/zeitgeist
	sys-auth/polkit
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-99.3.6.0:3
	x11-libs/pango"

src_prepare() {
	# Fix segfault from LP Bug 1058037 #
	epatch "${FILESDIR}/gtkapplication-fix.patch"

	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		epatch -p1 "${WORKDIR}/debian/patches/${patch}"
	done

	# Fix gnome-control-center loop executing when activity-log-manager is selected #
	sed -e "s:gnome-control-center activity-log-manager:activity-log-manager:" \
		-i data/activity-log-manager-ccpanel.desktop.in

	# Install docs in /usr/share/doc #
	sed -e "s:\${prefix}/doc/alm:/usr/share/doc/${P}:g" \
		-i Makefile{.am,.in} || die
	eautoreconf
}

src_configure() {
	export VALAC=$(type -P valac-0.16)
	export VALA_API_GEN=$(type -p vapigen-0.16)
	econf
}

src_install() {
	gnome2_src_install

	# Remove whoopsie crash database error tracking submission daemon #
	rm -rf ${ED}etc \
		${ED}usr/share/dbus-1 \
		${ED}usr/share/polkit-1 \
		${ED}usr/share/gnome-control-center
}
