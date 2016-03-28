# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
GCONF_DEBUG="yes"

URELEASE="wily"
inherit ubuntu-versionator

UURL="mirror://ubuntu/pool/main/s/${PN}"
UVER_PREFIX="~daily20130301"

DESCRIPTION="English sphinx language and acoustic models built from Voxforge audio corpus"
HOMEPAGE="http://www.voxforge.org/"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="mirror"

S="${WORKDIR}/${PN}"
DOCS="COPYING"

src_install() {
	insinto /usr/share/sphinx-voxforge-en/hmm/voxforge_en_sphinx.cd_cont_3000
	doins -r model_parameters/voxforge_en_sphinx.cd_cont_3000/*

	insinto /usr/share/sphinx-voxforge-en/lm/voxforge_en_sphinx.cd_cont_3000
	doins -r etc/voxforge_en_sphinx.{dic,lm.DMP}
}
