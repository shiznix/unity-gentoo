# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="cosmic"
inherit autotools eutils python-single-r1 ubuntu-versionator vala xdummy

UVER_PREFIX="+18.04.${PVR_MICRO}"

DESCRIPTION="BAMF Application Matching Framework"
HOMEPAGE="https://launchpad.net/bamf"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz
	${UURL}/${MY_P}${UVER_PREFIX}-${UVER}.diff.gz"

LICENSE="LGPL-3"
SLOT="0/1.0.0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

DEPEND="dev-libs/gobject-introspection
	dev-libs/libdbusmenu[gtk3]
	dev-libs/libunity[${PYTHON_USEDEP}]
	dev-libs/libxslt[python,${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	dev-util/gdbus-codegen
	gnome-base/libgtop
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3
	x11-libs/libXfixes
	$(vala_depend)"

S="${WORKDIR}"

pkg_setup() {
	ubuntu-versionator_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch -p1 "${WORKDIR}/${MY_P}${UVER_PREFIX}-${UVER}.diff"	# This needs to be applied for the debian/ directory to be present #
	ubuntu-versionator_src_prepare

	# workaround launchpad bug #1186915
	epatch "${FILESDIR}/${PN}-0.5.0-remove-desktop-fullname.patch"

	# removed gtester2xunit-check
	epatch "${FILESDIR}/${PN}-0.5.0-disable-gtester2xunit-check.patch"

	# Correct path to upstart's /usr/bin/initctl #
	sed -e 's:/sbin/initctl:/usr/bin/initctl:g' \
		-i data/bamfdaemon-dbus-runner.in

	#  'After=graphical-session-pre.target' must be explicitly set in the unit files that require it #
	#  Relying on the upstart job /usr/share/upstart/systemd-session/upstart/systemd-graphical-session.conf #
	#       to create "$XDG_RUNTIME_DIR/systemd/user/${unit}.d/graphical-session-pre.conf" drop-in units #
	#       results in weird race problems on desktop logout where the reliant desktop services #
	#       stop in a different jumbled order each time #
	sed -e '/PartOf=/i After=graphical-session-pre.target' \
		-i data/bamfdaemon.service.in || \
			die "Sed failed for data/bamfdaemon.service.in"

	# Remove 'Restart=on-failure' and instead bind to unity7.service so as not to create false fail triggers for both services #
	sed -e 's:Restart=on-failure::g' \
		-e '/PartOf=/a BindsTo=unity7.service' \
			-i data/bamfdaemon.service.in || \
				die "Sed failed for data/bamfdaemon.service.in"

	vala_src_prepare
	export VALA_API_GEN=$VAPIGEN
	python_fix_shebang .

	sed -e "s:-Werror::g" \
		-i "configure.ac" || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-export-actions-menu=yes \
		--enable-introspection=yes \
		--disable-static || die
}

src_test() {
	local XDUMMY_COMMAND="make check"
	xdummymake
}

src_install() {
	emake DESTDIR="${ED}" install || die

	# Install dbus interfaces #
	insinto /usr/share/dbus-1/interfaces
	doins lib/libbamf-private/org.ayatana.bamf.*xml

	# Install bamf-2.index creation script #
	#  Run at postinst of *.desktop files from ubuntu-versionator.eclass #
	#  bamf-index-create only indexes *.desktop files in /usr/share/applications #
	#    Why not also /usr/share/applications/kde4/ ?
	exeinto /usr/bin
	newexe debian/bamfdaemon.postinst bamf-index-create

	# Tell upstart not to start bamf as it will instead be started by systemd #
	dodir /usr/share/upstart/systemd-session/upstart
	echo manual > "${ED}"usr/share/upstart/systemd-session/upstart/bamfdaemon.override

	prune_libtool_files --modules
}
