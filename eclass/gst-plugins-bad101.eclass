# Purpose: This elcass is designed to help package external gst-plugins per
# plugin rather than in a single package.
#

inherit eutils multilib versionator gst-plugins101

GSTBAD_EXPF="src_unpack src_compile src_install"
case "${EAPI:-0}" in
	2|3|4|5) GSTBAD_EXPF+=" src_prepare src_configure" ;;
	0|1) ;;
	*) die "Unknown EAPI" ;;
esac
EXPORT_FUNCTIONS ${GSTBAD_EXPF}

# This list is current for gst-plugins-bad-0.10.21.
my_gst_plugins_bad="directsound directdraw osx_video quicktime vcd
assrender amrwb apexsink bz2 cdaudio celt cog dc1394 directfb dirac dts divx
faac faad fbdev flite gsm jp2k kate ladspa lv2 libmms
modplug mimic mpeg2enc mplex musepack musicbrainz mythtv nas neon ofa rsvg
timidity wildmidi sdl sdltest sndfile soundtouch spc gme swfdec xvid
dvb wininet acm vdpau schro zbar resindvd"

# When adding conditionals like below, be careful about having leading spaces

# Changes in 0.10.22:
# New curlsink element in a new curl plugin
# New Blackmagic Decklink source and sink
# New Linear Systems SDI plugin
if version_is_at_least "0.10.22"; then
	my_gst_plugins_bad+=" curl decklink linsys"
fi

# Unused ancient theora decoder, better one in -base long ago
if ! version_is_at_least "0.10.22"; then
	my_gst_plugins_bad+=" theoradec"
fi

# Changes in 0.10.21:
# New opencv and apple_media plugins
if version_is_at_least "0.10.21"; then
	my_gst_plugins_bad+=" opencv apple_media"
fi

# exif for a specific jifmux tests purpose only.
# Made automagic in 0.10.22, which is fine as a non-installed test
if [ ${PV} == "0.10.21" ]; then
	my_gst_plugins_bad+=" exif"
fi

# jack moved to -good, metadata removed (functionality in base classes)
# alsaspdif gone (gst-plugins-alsa from -base can do spdif on its own long ago)
if ! version_is_at_least "0.10.21"; then
	my_gst_plugins_bad+=" jack metadata alsa"
fi

# Changes in 0.10.20:
# New split plugins rtmp, gsettings and shm
if version_is_at_least "0.10.20"; then
	my_gst_plugins_bad+=" rtmp gsettings shm"
fi

MY_PN="gst-plugins-bad"
MY_P=${MY_PN}-${PV}

SRC_URI="http://gstreamer.freedesktop.org/src/gst-plugins-bad/${MY_P}.tar.xz"

# added to remove circular deps
# 6/2/2006 - zaheerm
if [ "${PN}" != "${MY_PN}" ]; then
RDEPEND="=media-libs/gstreamer-1.0*
		=media-libs/gst-plugins-base-1.0*
		>=dev-libs/glib-2.6"
DEPEND="${RDEPEND}
		sys-apps/sed
		virtual/pkgconfig
		sys-devel/gettext"

# -bad-0.10.20 uses orc optionally instead of liboil unconditionally.
# While <0.10.20 configure always check for liboil, it is used only by non-split
# plugins in gst/ (legacyresample and mpegdemux), so we only builddep for all
# old packages, and have a RDEPEND in old versions of media-libs/gst-plugins-bad
if ! version_is_at_least "0.10.20"; then
DEPEND="${DEPEND} >=dev-libs/liboil-0.3.8"
fi

RESTRICT=test
fi
S=${WORKDIR}/${MY_P}

gst-plugins-bad101_src_unpack() {
#	local makefiles

	unpack ${A}
	has src_prepare ${GSTBAD_EXPF} || gst-plugins-bad101_src_prepare
}

gst-plugins-bad101_src_prepare() {
	# Link with the syswide installed gst-libs if needed
	gst-plugins101_find_plugin_dir
	sed -e "s:\$(top_builddir)/gst-libs/gst/interfaces/libgstphotography:${ROOT}/usr/$(get_libdir)/libgstphotography:" \
		-e "s:\$(top_builddir)/gst-libs/gst/signalprocessor/libgstsignalprocessor:${ROOT}/usr/$(get_libdir)/libgstsignalprocessor:" \
		-e "s:\$(top_builddir)/gst-libs/gst/video/libgstbasevideo:${ROOT}/usr/$(get_libdir)/libgstbasevideo:" \
		-e "s:\$(top_builddir)/gst-libs/gst/basecamerabinsrc/libgstbasecamerabinsrc:${ROOT}/usr/$(get_libdir)/libgstbasecamerabinsrc:" \
		-i Makefile.in

	# Remove generation of any other Makefiles except the plugin's Makefile
#	if [[ -d "${S}/sys/${GST_PLUGINS_BUILD_DIR}" ]] ; then
#		makefiles="Makefile sys/Makefile sys/${GST_PLUGINS_BUILD_DIR}/Makefile"
#	elif [[ -d "${S}/ext/${GST_PLUGINS_BUILD_DIR}" ]] ; then
#		makefiles="Makefile ext/Makefile ext/${GST_PLUGINS_BUILD_DIR}/Makefile"
#	fi

#	sed -e "s:ac_config_files=.*:ac_config_files='${makefiles}':" \
#		-i ${S}/configure
}

gst-plugins-bad101_src_configure() {
	local plugin gst_conf

	einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."

	for plugin in ${my_gst_plugins_bad} ; do
		gst_conf+=" --disable-${plugin}"
	done

	for plugin in ${GST_PLUGINS_BUILD} ; do
		gst_conf+=" --enable-${plugin}"
	done

	cd ${S}
	econf ${@} --with-package-name="Gentoo GStreamer Ebuild" --with-package-origin="http://www.gentoo.org" ${gst_conf}
}

gst-plugins-bad101_src_compile() {
	has src_configure ${GSTBAD_EXPF} || gst-plugins-bad_src_configure ${@}

	gst-plugins101_find_plugin_dir
	emake || die "compile failure"
}

gst-plugins-bad101_src_install() {
	gst-plugins101_find_plugin_dir
	einstall || die "install failed"
	find "${D}" -name '*.la' -exec rm -f {} +

	[[ -e README ]] && dodoc README
}
