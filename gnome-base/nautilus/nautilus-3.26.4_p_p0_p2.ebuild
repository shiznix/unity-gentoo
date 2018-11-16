# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes" # Needed with USE 'sendto'

URELEASE="bionic-updates"
inherit eutils gnome-meson readme.gentoo-r1 virtualx ubuntu-versionator

UVER="-${PVR_PL_MAJOR}~ubuntu${UVER_RELEASE}.${PVR_PL_MINOR}"

DESCRIPTION="A file manager for the GNOME desktop patched for the Unity desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}${UVER}.debian.tar.xz"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
IUSE="exif gnome +introspection packagekit +previewer selinux sendto +tracker xmp"
KEYWORDS="~amd64 ~x86"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
# need org.gnome.SessionManager service (aka gnome-session) but cannot find it
RESTRICT="mirror test"

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=app-arch/gnome-autoar-0.2.1
	>=dev-libs/glib-2.51.2:2=[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.22.6:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	dev-libs/libunity

	gnome-base/dconf
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	selinux? ( >=sys-libs/libselinux-2 )
	tracker? ( >=app-misc/tracker-2.0:= )
	xmp? ( >=media-libs/exempi-2.1.0:2 )"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.33
	>=dev-util/gtk-doc-1.10
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-base/xorg-proto
	gnome-extra/zeitgeist"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )"

PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk]"
# Need gvfs[gtk] for recent:/// support

src_prepare() {
	# Disable selected patches #
	sed \
		`# multiarch_fallback.patch causes segfault in /usr/lib/nautilus/extensions-3.0/libterminal-nautilus.so` \
		-e 's:multiarch_fallback:#multiarch_fallback:g' \
			-i "${WORKDIR}/debian/patches/series"
	ubuntu-versionator_src_prepare
	eapply "${FILESDIR}/${P/_*}-optional-tracker.patch"
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi
	gnome-meson_src_prepare
}

src_configure() {
	# FIXME no doc useflag??
	gnome-meson_src_configure \
		-Denable-desktop=true \
		-Denable-gtk-doc=true \
		-Denable-profiling=false \
		-Denable-unity=true \
		$(meson_use exif enable-exif) \
		$(meson_use packagekit enable-packagekit) \
		$(meson_use sendto enable-nst-extension) \
		$(meson_use selinux enable-selinux) \
		$(meson_use tracker enable-tracker) \
		$(meson_use xmp enable-xmp)
}

src_test() {
	virtx meson_src_test
}

src_install() {
	use previewer && readme.gentoo_create_doc
	gnome-meson_src_install

	insinto /usr/share/applications/
	doins "${WORKDIR}"/debian/*.desktop
}

pkg_postinst() {
	gnome-meson_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi

	ubuntu-versionator_pkg_postinst
}
