# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gst-plugins10.eclass,v 1.6 2011/12/27 17:55:12 fauli Exp $

# Author : foser <foser@gentoo.org>

# gst-plugins eclass
#
# eclass to make external gst-plugins emergable on a per-plugin basis
# to solve the problem with gst-plugins generating far too much unneeded deps
#
# 3rd party applications using gstreamer now should depend on a set of plugins as
# defined in the source, in case of spider usage obtain recommended plugins to use from
# Gentoo developers responsible for gstreamer <gstreamer@gentoo.org> or the application
# developer.

inherit eutils


###
# variable declarations
###

# Create a major/minor combo for our SLOT and executables suffix
PVP=(${PV//[-\._]/ })
#PV_MAJ_MIN=${PVP[0]}.${PVP[1]}
PV_MAJ_MIN=1.0

# Extract the plugin to build from the ebuild name
# May be set by an ebuild and contain more than one indentifier, space seperated
# (only src_configure can handle mutiple plugins at this time)
GST_PLUGINS_BUILD=${PN/gst-plugins-/}

# Actual build dir, is the same as the configure switch name most of the time
GST_PLUGINS_BUILD_DIR=${PN/gst-plugins-/}

# general common gst-plugins ebuild entries
DESCRIPTION="${BUILD_GST_PLUGINS} plugin for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
LICENSE="GPL-2"

#SRC_URI="mirror://gnome/sources/gst-plugins/${PV_MAJ_MIN}/${MY_P}.tar.xz"
SLOT=${PV_MAJ_MIN}
###
# internal functions
###

gst-plugins101_find_plugin_dir() {

	GST_PLUGINS_BUILD_SRC_DIR=$(find . -maxdepth 2 -name ${GST_PLUGINS_BUILD_DIR} -type d)
	if [[ ! -d ${S}/${GST_PLUGINS_BUILD_SRC_DIR} ]]; then
		ewarn "No such plugin directory for ${GST_PLUGINS_BUILD_DIR}"
		die
	else
		cd "${S}/${GST_PLUGINS_BUILD_SRC_DIR}"
	fi
}

###
# public functions
###

gst-plugins101_remove_unversioned_binaries() {

	# remove the unversioned binaries gstreamer provide
	# this is to prevent these binaries to be owned by several SLOTs

	cd "${D}"/usr/bin
	local gst_bins
	for gst_bins in *-${PV_MAJ_MIN}; do
		[[ -e ${gst_bins} ]] || continue
		rm ${gst_bins/-${PV_MAJ_MIN}/}
		einfo "Removed ${gst_bins/-${PV_MAJ_MIN}/}"
	done

}
