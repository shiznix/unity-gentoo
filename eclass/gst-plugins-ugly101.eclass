# gst-plugins-ugly eclass
#
# eclass to make external gst-plugins emergable on a per-plugin basis
# to solve the problem with gst-plugins generating far too much unneeded deps
#
# 3rd party applications using gstreamer now should depend on a set of plugins as
# defined in the source, in case of spider usage obtain recommended plugins to use from
# Gentoo developers responsible for gstreamer <gstreamer@gentoo.org>.

inherit eutils versionator gst-plugins101


###
# variable declarations
###

MY_PN=gst-plugins-ugly
MY_P=${MY_PN}-${PV}

# All relevant configure options for gst-plugins-ugly
# need a better way to extract these.
my_gst_plugins_ugly="a52dec amrnb amrwb cdio dvdread lame mad mpeg2dec sidplay
twolame x264"

GST_UGLY_EXPORTED_FUNCTIONS="src_unpack src_compile src_install"

case "${EAPI:-0}" in
	0)
		if [[ -n ${GST_ORC} ]]; then
			die "Usage of IUSE=+orc implying GST_ORC variable without EAPI-1"
		fi
		;;
	1|2|3)
		;;
	*)
		die "Unsupported EAPI ${EAPI}"
		;;
esac

# exports must be ALWAYS after inherit
EXPORT_FUNCTIONS ${GST_UGLY_EXPORTED_FUNCTIONS}

# Ensure GST_ORC is set to a default.
GST_ORC=${GST_ORC:-"no"}
if [[ ${GST_ORC} == "yes" ]]; then
	IUSE="+orc"
fi

#SRC_URI="mirror://gnome/sources/gst-plugins/${PV_MAJ_MIN}/${MY_P}.tar.xz"
SRC_URI="http://gstreamer.freedesktop.org/src/gst-plugins-ugly/${MY_P}.tar.xz"

S=${WORKDIR}/${MY_P}

if [[ ${GST_ORC} == "yes" ]]; then
	RDEPEND="orc? ( >=dev-lang/orc-0.4.6 )"
	DEPEND="${RDEPEND}"
fi

# added to remove circular deps
# 6/2/2006 - zaheerm
if [ "${PN}" != "${MY_PN}" ]; then
RDEPEND="${RDEPEND}
	=media-libs/gst-plugins-base-1.0*"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/pkgconfig"

RESTRICT=test
fi

###
# public functions
###

gst-plugins-ugly101_src_configure() {

	# disable any external plugin besides the plugin we want
	local plugin gst_conf gst_orc_conf

	einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."

	for plugin in ${my_gst_plugins_ugly}; do
		gst_conf="${gst_conf} --disable-${plugin} "
	done

	for plugin in ${GST_PLUGINS_BUILD}; do
		gst_conf="${gst_conf} --enable-${plugin} "
	done

	gst_orc_conf="--disable-orc"
	if [[ ${GST_ORC} == "yes" ]]; then
		gst_orc_conf="$(use_enable orc)"
	fi

	cd ${S}
	econf ${gst_orc_conf} ${@} --with-package-name="Gentoo GStreamer Ebuild" --with-package-origin="http://www.gentoo.org" ${gst_conf} || die "./configure failure"

}

###
# public inheritable functions
###

gst-plugins-ugly101_src_unpack() {

#	local makefiles

	unpack ${A}

	# Link with the syswide installed gst-libs if needed
#	gst-plugins-101_find_plugin_dir
#	cd ${S}

	# Remove generation of any other Makefiles except the plugin's Makefile
#	if [ -d "${S}/sys/${GST_PLUGINS_BUILD_DIR}" ]; then
#		makefiles="Makefile sys/Makefile sys/${GST_PLUGINS_BUILD_DIR}/Makefile"
#	elif [ -d "${S}/ext/${GST_PLUGINS_BUILD_DIR}" ]; then
#		makefiles="Makefile ext/Makefile ext/${GST_PLUGINS_BUILD_DIR}/Makefile"
#	fi
#	sed -e "s:ac_config_files=.*:ac_config_files='${makefiles}':" \
#		-i ${S}/configure

}

gst-plugins-ugly101_src_compile() {

	gst-plugins-ugly101_src_configure ${@}

	gst-plugins101_find_plugin_dir
	emake || die "compile failure"

}

gst-plugins-ugly101_src_install() {

	gst-plugins101_find_plugin_dir
	einstall || die
	find "${D}" -name '*.la' -exec rm -f {} +

	[[ -e README ]] && dodoc README
}
