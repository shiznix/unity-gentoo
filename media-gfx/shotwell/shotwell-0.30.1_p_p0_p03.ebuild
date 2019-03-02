# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic-updates"
inherit eutils gnome2 multilib toolchain-funcs vala ubuntu-versionator

DESCRIPTION="Open source photo manager for GNOME patched for the Unity desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz
	http://pkgs.fedoraproject.org/repo/pkgs/shotwell/shotwell-icons.tar.bz2/1df95b65bb7689c10840faaa765bf931/shotwell-icons.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

CORE_SUPPORTED_LANGUAGES="
	af ar as ast bg bn bn_IN ca cs da de el en_GB eo es et eu fi fr gd gl gu he
	hi hr hu ia id it ja kk km kn ko ky lt lv mk ml mr nb nl nn or pa pl pt
	pt_BR ro ru sk sl sr sv ta te th tr uk vi zh_CN zh_HK zh_TW"

for x in ${CORE_SUPPORTED_LANGUAGES}; do
	IUSE+="linguas_${x} "
done

RDEPEND="app-text/gnome-doc-utils
	>=app-crypt/gcr-3[gtk]
	>=dev-db/sqlite-3.5.9:3
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/json-glib-0.7.6
	dev-libs/libgdata
	>=dev-libs/libgee-0.8.5:0.8
	>=dev-libs/libxml2-2.6.32:2
	>=dev-util/desktop-file-utils-0.13
	gnome-base/dconf
	>=media-libs/gexiv2-0.10.4
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gstreamer:1.0
	media-libs/lcms:2
	>=media-libs/libexif-0.6.16:=
	>=media-libs/libgphoto2-2.4.2:=
	>=media-libs/libraw-0.13.2:=
	>=net-libs/libsoup-2.26.0:2.4
	>=net-libs/rest-0.7:0.7
	net-libs/webkit-gtk:4
	unity-base/unity
	virtual/libgudev:=[introspection]
	>=x11-libs/gtk+-3.14.0:3[X]"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/itstool
	>=sys-devel/gettext-0.19.7
	>=sys-devel/m4-1.4.13
	virtual/pkgconfig"


src_prepare() {
	## FIXME: Patch currently broken ##
#	sed -i '/06_uoa.patch/d' "${WORKDIR}/debian/patches/series" || die

	ubuntu-versionator_src_prepare
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-unity-support
}

src_install() {
	default
	local res
	for res in 16 22 24 32 48 256; do
		doicon -s ${res} "${WORKDIR}"/${res}x${res}/*
	done
}

pkg_postinst() {
	xdg_desktop_database_update
}
