# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mad/gst-plugins-mad-0.10.18.ebuild,v 1.9 2012/07/23 22:32:06 blueness Exp $

inherit gst-plugins-ugly

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.26
	>=media-libs/gstreamer-0.10.26
	>=media-libs/libmad-0.15.1b
	media-libs/gst-plugins-good
	>=media-libs/libid3tag-0.15" # adds optional id3 tag support, but id3demux in -good should
	# be getting used in all cases for much more comprehensive ID3 tag support.
	# FIXME: Kill libid3tag dep once it's made not automagic
DEPEND="${RDEPEND}"
