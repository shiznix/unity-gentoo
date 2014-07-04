# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit ubuntu-versionator

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l"	# Mirrors are too unpredictable #
UVER=
URELEASE="saucy"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="sys-devel/gettext"

setvar() {
	eval "_ver_${1//-/_}=${2}"
	packages+=(${1})
}
setvar language-pack-aa			13.10+20131012
setvar language-pack-aa-base		13.10+20131012
setvar language-pack-gnome-aa		13.10+20131012
setvar language-pack-gnome-aa-base	13.10+20131012
setvar language-pack-af			13.10+20131012
setvar language-pack-af-base		13.10+20131012
setvar language-pack-gnome-af		13.10+20131012
setvar language-pack-gnome-af-base	13.10+20131012
setvar language-pack-am			13.10+20131012
setvar language-pack-am-base		13.10+20131012
setvar language-pack-gnome-am		13.10+20131012
setvar language-pack-gnome-am-base	13.10+20131012
setvar language-pack-an			13.10+20131012
setvar language-pack-an-base		13.10+20131012
setvar language-pack-gnome-an		13.10+20131012
setvar language-pack-gnome-an-base	13.10+20131012
setvar language-pack-ar			13.10+20131012
setvar language-pack-ar-base		13.10+20131012
setvar language-pack-gnome-ar		13.10+20131012
setvar language-pack-gnome-ar-base	13.10+20131012
setvar language-pack-as			13.10+20131012
setvar language-pack-as-base		13.10+20131012
setvar language-pack-gnome-as		13.10+20131012
setvar language-pack-gnome-as-base	13.10+20131012
setvar language-pack-ast		13.10+20131012
setvar language-pack-ast-base		13.10+20131012
setvar language-pack-gnome-ast		13.10+20131012
setvar language-pack-gnome-ast-base	13.10+20131012
setvar language-pack-az			13.10+20131012
setvar language-pack-az-base		13.10+20131012
setvar language-pack-gnome-az		13.10+20131012
setvar language-pack-gnome-az-base	13.10+20131012
setvar language-pack-be			13.10+20131012
setvar language-pack-be-base		13.10+20131012
setvar language-pack-gnome-be		13.10+20131012
setvar language-pack-gnome-be-base	13.10+20131012
setvar language-pack-bem		13.10+20131012
setvar language-pack-bem-base		13.10+20131012
setvar language-pack-gnome-bem		13.10+20131012
setvar language-pack-gnome-bem-base	13.10+20131012
setvar language-pack-ber		13.10+20131012
setvar language-pack-ber-base		13.10+20131012
setvar language-pack-gnome-ber		13.10+20131012
setvar language-pack-gnome-ber-base	13.10+20131012
setvar language-pack-bg			13.10+20131012
setvar language-pack-bg-base		13.10+20131012
setvar language-pack-gnome-bg		13.10+20131012
setvar language-pack-gnome-bg-base	13.10+20131012
setvar language-pack-bn			13.10+20131012
setvar language-pack-bn-base		13.10+20131012
setvar language-pack-gnome-bn		13.10+20131012
setvar language-pack-gnome-bn-base	13.10+20131012
setvar language-pack-bo			13.10+20131012
setvar language-pack-bo-base		13.10+20131012
setvar language-pack-gnome-bo		13.10+20131012
setvar language-pack-gnome-bo-base	13.10+20131012
setvar language-pack-br			13.10+20131012
setvar language-pack-br-base		13.10+20131012
setvar language-pack-gnome-br		13.10+20131012
setvar language-pack-gnome-br-base	13.10+20131012
setvar language-pack-bs			13.10+20131012
setvar language-pack-bs-base		13.10+20131012
setvar language-pack-gnome-bs		13.10+20131012
setvar language-pack-gnome-bs-base	13.10+20131012
setvar language-pack-ca			13.10+20131012
setvar language-pack-ca-base		13.10+20131012
setvar language-pack-gnome-ca		13.10+20131012
setvar language-pack-gnome-ca-base	13.10+20131012
setvar language-pack-crh		13.10+20131012
setvar language-pack-crh-base		13.10+20131012
setvar language-pack-gnome-crh		13.10+20131012
setvar language-pack-gnome-crh-base	13.10+20131012
setvar language-pack-cs			13.10+20131012
setvar language-pack-cs-base		13.10+20131012
setvar language-pack-gnome-cs		13.10+20131012
setvar language-pack-gnome-cs-base	13.10+20131012
setvar language-pack-csb		13.10+20131012
setvar language-pack-csb-base		13.10+20131012
setvar language-pack-gnome-csb		13.10+20131012
setvar language-pack-gnome-csb-base	13.10+20131012
setvar language-pack-cv			13.10+20131012
setvar language-pack-cv-base		13.10+20131012
setvar language-pack-gnome-cv		13.10+20131012
setvar language-pack-gnome-cv-base	13.10+20131012
setvar language-pack-cy			13.10+20131012
setvar language-pack-cy-base		13.10+20131012
setvar language-pack-gnome-cy		13.10+20131012
setvar language-pack-gnome-cy-base	13.10+20131012
setvar language-pack-da			13.10+20131012
setvar language-pack-da-base		13.10+20131012
setvar language-pack-gnome-da		13.10+20131012
setvar language-pack-gnome-da-base	13.10+20131012
setvar language-pack-de			13.10+20131012
setvar language-pack-de-base		13.10+20131012
setvar language-pack-gnome-de		13.10+20131012
setvar language-pack-gnome-de-base	13.10+20131012
setvar language-pack-dv			13.10+20131012
setvar language-pack-dv-base		13.10+20131012
setvar language-pack-gnome-dv		13.10+20131012
setvar language-pack-gnome-dv-base	13.10+20131012
setvar language-pack-dz			13.10+20131012
setvar language-pack-dz-base		13.10+20131012
setvar language-pack-gnome-dz		13.10+20131012
setvar language-pack-gnome-dz-base	13.10+20131012
setvar language-pack-el			13.10+20131012
setvar language-pack-el-base		13.10+20131012
setvar language-pack-gnome-el		13.10+20131012
setvar language-pack-gnome-el-base	13.10+20131012
setvar language-pack-en			13.10+20131012
setvar language-pack-en-base		13.10+20131012
setvar language-pack-gnome-en		13.10+20131012
setvar language-pack-gnome-en-base	13.10+20131012
setvar language-pack-eo			13.10+20131012
setvar language-pack-eo-base		13.10+20131012
setvar language-pack-gnome-eo		13.10+20131012
setvar language-pack-gnome-eo-base	13.10+20131012
setvar language-pack-es			13.10+20131012
setvar language-pack-es-base		13.10+20131012
setvar language-pack-gnome-es		13.10+20131012
setvar language-pack-gnome-es-base	13.10+20131012
setvar language-pack-et			13.10+20131012
setvar language-pack-et-base		13.10+20131012
setvar language-pack-gnome-et		13.10+20131012
setvar language-pack-gnome-et-base	13.10+20131012
setvar language-pack-eu			13.10+20131012
setvar language-pack-eu-base		13.10+20131012
setvar language-pack-gnome-eu		13.10+20131012
setvar language-pack-gnome-eu-base	13.10+20131012
setvar language-pack-fa			13.10+20131012
setvar language-pack-fa-base		13.10+20131012
setvar language-pack-gnome-fa		13.10+20131012
setvar language-pack-gnome-fa-base	13.10+20131012
setvar language-pack-fi			13.10+20131012
setvar language-pack-fi-base		13.10+20131012
setvar language-pack-gnome-fi		13.10+20131012
setvar language-pack-gnome-fi-base	13.10+20131012
setvar language-pack-fil		13.10+20131012
setvar language-pack-fil-base		13.10+20131012
setvar language-pack-gnome-fil		13.10+20131012
setvar language-pack-gnome-fil-base	13.10+20131012
setvar language-pack-fo			13.10+20131012
setvar language-pack-fo-base		13.10+20131012
setvar language-pack-gnome-fo		13.10+20131012
setvar language-pack-gnome-fo-base	13.10+20131012
setvar language-pack-fr			13.10+20131012
setvar language-pack-fr-base		13.10+20131012
setvar language-pack-gnome-fr		13.10+20131012
setvar language-pack-gnome-fr-base	13.10+20131012
setvar language-pack-fur		13.10+20131012
setvar language-pack-fur-base		13.10+20131012
setvar language-pack-gnome-fur		13.10+20131012
setvar language-pack-gnome-fur-base	13.10+20131012
setvar language-pack-fy			13.10+20131012
setvar language-pack-fy-base		13.10+20131012
setvar language-pack-gnome-fy		13.10+20131012
setvar language-pack-gnome-fy-base	13.10+20131012
setvar language-pack-ga			13.10+20131012
setvar language-pack-ga-base		13.10+20131012
setvar language-pack-gnome-ga		13.10+20131012
setvar language-pack-gnome-ga-base	13.10+20131012
setvar language-pack-gd			13.10+20131012
setvar language-pack-gd-base		13.10+20131012
setvar language-pack-gnome-gd		13.10+20131012
setvar language-pack-gnome-gd-base	13.10+20131012
setvar language-pack-gl			13.10+20131012
setvar language-pack-gl-base		13.10+20131012
setvar language-pack-gnome-gl		13.10+20131012
setvar language-pack-gnome-gl-base	13.10+20131012
setvar language-pack-gu			13.10+20131012
setvar language-pack-gu-base		13.10+20131012
setvar language-pack-gnome-gu		13.10+20131012
setvar language-pack-gnome-gu-base	13.10+20131012
setvar language-pack-gv			13.10+20131012
setvar language-pack-gv-base		13.10+20131012
setvar language-pack-gnome-gv		13.10+20131012
setvar language-pack-gnome-gv-base	13.10+20131012
setvar language-pack-ha			13.10+20131012
setvar language-pack-ha-base		13.10+20131012
setvar language-pack-gnome-ha		13.10+20131012
setvar language-pack-gnome-ha-base	13.10+20131012
setvar language-pack-he			13.10+20131012
setvar language-pack-he-base		13.10+20131012
setvar language-pack-gnome-he		13.10+20131012
setvar language-pack-gnome-he-base	13.10+20131012
setvar language-pack-hi			13.10+20131012
setvar language-pack-hi-base		13.10+20131012
setvar language-pack-gnome-hi		13.10+20131012
setvar language-pack-gnome-hi-base	13.10+20131012
setvar language-pack-hr			13.10+20131012
setvar language-pack-hr-base		13.10+20131012
setvar language-pack-gnome-hr		13.10+20131012
setvar language-pack-gnome-hr-base	13.10+20131012
setvar language-pack-ht			13.10+20131012
setvar language-pack-ht-base		13.10+20131012
setvar language-pack-gnome-ht		13.10+20131012
setvar language-pack-gnome-ht-base	13.10+20131012
setvar language-pack-hu			13.10+20131012
setvar language-pack-hu-base		13.10+20131012
setvar language-pack-gnome-hu		13.10+20131012
setvar language-pack-gnome-hu-base	13.10+20131012
setvar language-pack-hy			13.10+20131012
setvar language-pack-hy-base		13.10+20131012
setvar language-pack-gnome-hy		13.10+20131012
setvar language-pack-gnome-hy-base	13.10+20131012
setvar language-pack-ia			13.10+20131012
setvar language-pack-ia-base		13.10+20131012
setvar language-pack-gnome-ia		13.10+20131012
setvar language-pack-gnome-ia-base	13.10+20131012
setvar language-pack-id			13.10+20131012
setvar language-pack-id-base		13.10+20131012
setvar language-pack-gnome-id		13.10+20131012
setvar language-pack-gnome-id-base	13.10+20131012
setvar language-pack-ig			13.10+20131012
setvar language-pack-ig-base		13.10+20131012
setvar language-pack-gnome-ig		13.10+20131012
setvar language-pack-gnome-ig-base	13.10+20131012
setvar language-pack-is			13.10+20131012
setvar language-pack-is-base		13.10+20131012
setvar language-pack-gnome-is		13.10+20131012
setvar language-pack-gnome-is-base	13.10+20131012
setvar language-pack-it			13.10+20131012
setvar language-pack-it-base		13.10+20131012
setvar language-pack-gnome-it		13.10+20131012
setvar language-pack-gnome-it-base	13.10+20131012
setvar language-pack-ja			13.10+20131012
setvar language-pack-ja-base		13.10+20131012
setvar language-pack-gnome-ja		13.10+20131012
setvar language-pack-gnome-ja-base	13.10+20131012
setvar language-pack-ka			13.10+20131012
setvar language-pack-ka-base		13.10+20131012
setvar language-pack-gnome-ka		13.10+20131012
setvar language-pack-gnome-ka-base	13.10+20131012
setvar language-pack-kk			13.10+20131012
setvar language-pack-kk-base		13.10+20131012
setvar language-pack-gnome-kk		13.10+20131012
setvar language-pack-gnome-kk-base	13.10+20131012
setvar language-pack-kl			13.10+20131012
setvar language-pack-kl-base		13.10+20131012
setvar language-pack-gnome-kl		13.10+20131012
setvar language-pack-gnome-kl-base	13.10+20131012
setvar language-pack-km			13.10+20131012
setvar language-pack-km-base		13.10+20131012
setvar language-pack-gnome-km		13.10+20131012
setvar language-pack-gnome-km-base	13.10+20131012
setvar language-pack-kn			13.10+20131012
setvar language-pack-kn-base		13.10+20131012
setvar language-pack-gnome-kn		13.10+20131012
setvar language-pack-gnome-kn-base	13.10+20131012
setvar language-pack-ko			13.10+20131012
setvar language-pack-ko-base		13.10+20131012
setvar language-pack-gnome-ko		13.10+20131012
setvar language-pack-gnome-ko-base	13.10+20131012
setvar language-pack-ks			13.10+20131012
setvar language-pack-ks-base		13.10+20131012
setvar language-pack-gnome-ks		13.10+20131012
setvar language-pack-gnome-ks-base	13.10+20131012
setvar language-pack-ku			13.10+20131012
setvar language-pack-ku-base		13.10+20131012
setvar language-pack-gnome-ku		13.10+20131012
setvar language-pack-gnome-ku-base	13.10+20131012
setvar language-pack-kw			13.10+20131012
setvar language-pack-kw-base		13.10+20131012
setvar language-pack-gnome-kw		13.10+20131012
setvar language-pack-gnome-kw-base	13.10+20131012
setvar language-pack-ky			13.10+20131012
setvar language-pack-ky-base		13.10+20131012
setvar language-pack-gnome-ky		13.10+20131012
setvar language-pack-gnome-ky-base	13.10+20131012
setvar language-pack-la			12.10+20121009
setvar language-pack-la-base		12.10+20121009
setvar language-pack-gnome-la		12.10+20121009
setvar language-pack-gnome-la-base	12.10+20121009
setvar language-pack-lb			13.10+20131012
setvar language-pack-lb-base		13.10+20131012
setvar language-pack-gnome-lb		13.10+20131012
setvar language-pack-gnome-lb-base	13.10+20131012
setvar language-pack-lg			13.10+20131012
setvar language-pack-lg-base		13.10+20131012
setvar language-pack-gnome-lg		13.10+20131012
setvar language-pack-gnome-lg-base	13.10+20131012
setvar language-pack-li			13.10+20131012
setvar language-pack-li-base		13.10+20131012
setvar language-pack-gnome-li		13.10+20131012
setvar language-pack-gnome-li-base	13.10+20131012
setvar language-pack-lo			13.10+20131012
setvar language-pack-lo-base		13.10+20131012
setvar language-pack-gnome-lo		13.10+20131012
setvar language-pack-gnome-lo-base	13.10+20131012
setvar language-pack-lt			13.10+20131012
setvar language-pack-lt-base		13.10+20131012
setvar language-pack-gnome-lt		13.10+20131012
setvar language-pack-gnome-lt-base	13.10+20131012
setvar language-pack-lv			13.10+20131012
setvar language-pack-lv-base		13.10+20131012
setvar language-pack-gnome-lv		13.10+20131012
setvar language-pack-gnome-lv-base	13.10+20131012
setvar language-pack-mai		13.10+20131012
setvar language-pack-mai-base		13.10+20131012
setvar language-pack-gnome-mai		13.10+20131012
setvar language-pack-gnome-mai-base	13.10+20131012
setvar language-pack-mg			13.10+20131012
setvar language-pack-mg-base		13.10+20131012
setvar language-pack-gnome-mg		13.10+20131012
setvar language-pack-gnome-mg-base	13.10+20131012
setvar language-pack-mhr		13.10+20131012
setvar language-pack-mhr-base		13.10+20131012
setvar language-pack-gnome-mhr		13.10+20131012
setvar language-pack-gnome-mhr-base	13.10+20131012
setvar language-pack-mi			13.10+20131012
setvar language-pack-mi-base		13.10+20131012
setvar language-pack-gnome-mi		13.10+20131012
setvar language-pack-gnome-mi-base	13.10+20131012
setvar language-pack-mk			13.10+20131012
setvar language-pack-mk-base		13.10+20131012
setvar language-pack-gnome-mk		13.10+20131012
setvar language-pack-gnome-mk-base	13.10+20131012
setvar language-pack-ml			13.10+20131012
setvar language-pack-ml-base		13.10+20131012
setvar language-pack-gnome-ml		13.10+20131012
setvar language-pack-gnome-ml-base	13.10+20131012
setvar language-pack-mn			13.10+20131012
setvar language-pack-mn-base		13.10+20131012
setvar language-pack-gnome-mn		13.10+20131012
setvar language-pack-gnome-mn-base	13.10+20131012
setvar language-pack-mr			13.10+20131012
setvar language-pack-mr-base		13.10+20131012
setvar language-pack-gnome-mr		13.10+20131012
setvar language-pack-gnome-mr-base	13.10+20131012
setvar language-pack-ms			13.10+20131012
setvar language-pack-ms-base		13.10+20131012
setvar language-pack-gnome-ms		13.10+20131012
setvar language-pack-gnome-ms-base	13.10+20131012
setvar language-pack-mt			13.10+20131012
setvar language-pack-mt-base		13.10+20131012
setvar language-pack-gnome-mt		13.10+20131012
setvar language-pack-gnome-mt-base	13.10+20131012
setvar language-pack-my			13.10+20131012
setvar language-pack-my-base		13.10+20131012
setvar language-pack-gnome-my		13.10+20131012
setvar language-pack-gnome-my-base	13.10+20131012
setvar language-pack-nan		13.10+20131012
setvar language-pack-nan-base		13.10+20131012
setvar language-pack-gnome-nan		13.10+20131012
setvar language-pack-gnome-nan-base	13.10+20131012
setvar language-pack-nb			13.10+20131012
setvar language-pack-nb-base		13.10+20131012
setvar language-pack-gnome-nb		13.10+20131012
setvar language-pack-gnome-nb-base	13.10+20131012
setvar language-pack-nds		13.10+20131012
setvar language-pack-nds-base		13.10+20131012
setvar language-pack-gnome-nds		13.10+20131012
setvar language-pack-gnome-nds-base	13.10+20131012
setvar language-pack-ne			13.10+20131012
setvar language-pack-ne-base		13.10+20131012
setvar language-pack-gnome-ne		13.10+20131012
setvar language-pack-gnome-ne-base	13.10+20131012
setvar language-pack-nl			13.10+20131012
setvar language-pack-nl-base		13.10+20131012
setvar language-pack-gnome-nl		13.10+20131012
setvar language-pack-gnome-nl-base	13.10+20131012
setvar language-pack-nn			13.10+20131012
setvar language-pack-nn-base		13.10+20131012
setvar language-pack-gnome-nn		13.10+20131012
setvar language-pack-gnome-nn-base	13.10+20131012
setvar language-pack-nso		13.10+20131012
setvar language-pack-nso-base		13.10+20131012
setvar language-pack-gnome-nso		13.10+20131012
setvar language-pack-gnome-nso-base	13.10+20131012
setvar language-pack-oc			13.10+20131012
setvar language-pack-oc-base		13.10+20131012
setvar language-pack-gnome-oc		13.10+20131012
setvar language-pack-gnome-oc-base	13.10+20131012
setvar language-pack-om			13.10+20131012
setvar language-pack-om-base		13.10+20131012
setvar language-pack-gnome-om		13.10+20131012
setvar language-pack-gnome-om-base	13.10+20131012
setvar language-pack-or			13.10+20131012
setvar language-pack-or-base		13.10+20131012
setvar language-pack-gnome-or		13.10+20131012
setvar language-pack-gnome-or-base	13.10+20131012
setvar language-pack-os			13.10+20131012
setvar language-pack-os-base		13.10+20131012
setvar language-pack-gnome-os		13.10+20131012
setvar language-pack-gnome-os-base	13.10+20131012
setvar language-pack-pa			13.10+20131012
setvar language-pack-pa-base		13.10+20131012
setvar language-pack-gnome-pa		13.10+20131012
setvar language-pack-gnome-pa-base	13.10+20131012
setvar language-pack-pap		13.10+20131012
setvar language-pack-pap-base		13.10+20131012
setvar language-pack-gnome-pap		13.10+20131012
setvar language-pack-gnome-pap-base	13.10+20131012
setvar language-pack-pl			13.10+20131012
setvar language-pack-pl-base		13.10+20131012
setvar language-pack-gnome-pl		13.10+20131012
setvar language-pack-gnome-pl-base	13.10+20131012
setvar language-pack-ps			13.10+20131012
setvar language-pack-ps-base		13.10+20131012
setvar language-pack-gnome-ps		13.10+20131012
setvar language-pack-gnome-ps-base	13.10+20131012
setvar language-pack-pt			13.10+20131012
setvar language-pack-pt-base		13.10+20131012
setvar language-pack-gnome-pt		13.10+20131012
setvar language-pack-gnome-pt-base	13.10+20131012
setvar language-pack-ro			13.10+20131012
setvar language-pack-ro-base		13.10+20131012
setvar language-pack-gnome-ro		13.10+20131012
setvar language-pack-gnome-ro-base	13.10+20131012
setvar language-pack-ru			13.10+20131012
setvar language-pack-ru-base		13.10+20131012
setvar language-pack-gnome-ru		13.10+20131012
setvar language-pack-gnome-ru-base	13.10+20131012
setvar language-pack-rw			13.10+20131012
setvar language-pack-rw-base		13.10+20131012
setvar language-pack-gnome-rw		13.10+20131012
setvar language-pack-gnome-rw-base	13.10+20131012
setvar language-pack-sa			13.10+20131012
setvar language-pack-sa-base		13.10+20131012
setvar language-pack-gnome-sa		13.10+20131012
setvar language-pack-gnome-sa-base	13.10+20131012
setvar language-pack-sc			13.10+20131012
setvar language-pack-sc-base		13.10+20131012
setvar language-pack-gnome-sc		13.10+20131012
setvar language-pack-gnome-sc-base	13.10+20131012
setvar language-pack-sd			13.10+20131012
setvar language-pack-sd-base		13.10+20131012
setvar language-pack-gnome-sd		13.10+20131012
setvar language-pack-gnome-sd-base	13.10+20131012
setvar language-pack-se			13.10+20131012
setvar language-pack-se-base		13.10+20131012
setvar language-pack-gnome-se		13.10+20131012
setvar language-pack-gnome-se-base	13.10+20131012
setvar language-pack-shs		13.10+20131012
setvar language-pack-shs-base		13.10+20131012
setvar language-pack-gnome-shs		13.10+20131012
setvar language-pack-gnome-shs-base	13.10+20131012
setvar language-pack-si			13.10+20131012
setvar language-pack-si-base		13.10+20131012
setvar language-pack-gnome-si		13.10+20131012
setvar language-pack-gnome-si-base	13.10+20131012
setvar language-pack-sk			13.10+20131012
setvar language-pack-sk-base		13.10+20131012
setvar language-pack-gnome-sk		13.10+20131012
setvar language-pack-gnome-sk-base	13.10+20131012
setvar language-pack-sl			13.10+20131012
setvar language-pack-sl-base		13.10+20131012
setvar language-pack-gnome-sl		13.10+20131012
setvar language-pack-gnome-sl-base	13.10+20131012
setvar language-pack-so			13.04+20130418
setvar language-pack-so-base		13.04+20130418
setvar language-pack-gnome-so		13.04+20130418
setvar language-pack-gnome-so-base	13.04+20130418
setvar language-pack-sq			13.10+20131012
setvar language-pack-sq-base		13.10+20131012
setvar language-pack-gnome-sq		13.10+20131012
setvar language-pack-gnome-sq-base	13.10+20131012
setvar language-pack-sr			13.10+20131012
setvar language-pack-sr-base		13.10+20131012
setvar language-pack-gnome-sr		13.10+20131012
setvar language-pack-gnome-sr-base	13.10+20131012
setvar language-pack-st			13.10+20131012
setvar language-pack-st-base		13.10+20131012
setvar language-pack-gnome-st		13.10+20131012
setvar language-pack-gnome-st-base	13.10+20131012
setvar language-pack-sv			13.10+20131012
setvar language-pack-sv-base		13.10+20131012
setvar language-pack-gnome-sv		13.10+20131012
setvar language-pack-gnome-sv-base	13.10+20131012
setvar language-pack-sw			13.10+20131012
setvar language-pack-sw-base		13.10+20131012
setvar language-pack-gnome-sw		13.10+20131012
setvar language-pack-gnome-sw-base	13.10+20131012
setvar language-pack-ta			13.10+20131012
setvar language-pack-ta-base		13.10+20131012
setvar language-pack-gnome-ta		13.10+20131012
setvar language-pack-gnome-ta-base	13.10+20131012
setvar language-pack-te			13.10+20131012
setvar language-pack-te-base		13.10+20131012
setvar language-pack-gnome-te		13.10+20131012
setvar language-pack-gnome-te-base	13.10+20131012
setvar language-pack-tg			13.10+20131012
setvar language-pack-tg-base		13.10+20131012
setvar language-pack-gnome-tg		13.10+20131012
setvar language-pack-gnome-tg-base	13.10+20131012
setvar language-pack-th			13.10+20131012
setvar language-pack-th-base		13.10+20131012
setvar language-pack-gnome-th		13.10+20131012
setvar language-pack-gnome-th-base	13.10+20131012
setvar language-pack-ti			13.10+20131012
setvar language-pack-ti-base		13.10+20131012
setvar language-pack-gnome-ti		13.10+20131012
setvar language-pack-gnome-ti-base	13.10+20131012
setvar language-pack-tk			13.10+20131012
setvar language-pack-tk-base		13.10+20131012
setvar language-pack-gnome-tk		13.10+20131012
setvar language-pack-gnome-tk-base	13.10+20131012
setvar language-pack-tl			13.10+20131012
setvar language-pack-tl-base		13.10+20131012
setvar language-pack-gnome-tl		13.10+20131012
setvar language-pack-gnome-tl-base	13.10+20131012
setvar language-pack-tr			13.10+20131012
setvar language-pack-tr-base		13.10+20131012
setvar language-pack-gnome-tr		13.10+20131012
setvar language-pack-gnome-tr-base	13.10+20131012
setvar language-pack-ts			13.10+20131012
setvar language-pack-ts-base		13.10+20131012
setvar language-pack-gnome-ts		13.10+20131012
setvar language-pack-gnome-ts-base	13.10+20131012
setvar language-pack-tt			13.10+20131012
setvar language-pack-tt-base		13.10+20131012
setvar language-pack-gnome-tt		13.10+20131012
setvar language-pack-gnome-tt-base	13.10+20131012
setvar language-pack-ug			13.10+20131012
setvar language-pack-ug-base		13.10+20131012
setvar language-pack-gnome-ug		13.10+20131012
setvar language-pack-gnome-ug-base	13.10+20131012
setvar language-pack-uk			13.10+20131012
setvar language-pack-uk-base		13.10+20131012
setvar language-pack-gnome-uk		13.10+20131012
setvar language-pack-gnome-uk-base	13.10+20131012
setvar language-pack-ur			13.10+20131012
setvar language-pack-ur-base		13.10+20131012
setvar language-pack-gnome-ur		13.10+20131012
setvar language-pack-gnome-ur-base	13.10+20131012
setvar language-pack-uz			13.10+20131012
setvar language-pack-uz-base		13.10+20131012
setvar language-pack-gnome-uz		13.10+20131012
setvar language-pack-gnome-uz-base	13.10+20131012
setvar language-pack-ve			13.10+20131012
setvar language-pack-ve-base		13.10+20131012
setvar language-pack-gnome-ve		13.10+20131012
setvar language-pack-gnome-ve-base	13.10+20131012
setvar language-pack-vi			13.10+20131012
setvar language-pack-vi-base		13.10+20131012
setvar language-pack-gnome-vi		13.10+20131012
setvar language-pack-gnome-vi-base	13.10+20131012
setvar language-pack-wa			13.10+20131012
setvar language-pack-wa-base		13.10+20131012
setvar language-pack-gnome-wa		13.10+20131012
setvar language-pack-gnome-wa-base	13.10+20131012
setvar language-pack-wae		13.10+20131012
setvar language-pack-wae-base		13.10+20131012
setvar language-pack-gnome-wae		13.10+20131012
setvar language-pack-gnome-wae-base	13.10+20131012
setvar language-pack-wo			13.10+20131012
setvar language-pack-wo-base		13.10+20131012
setvar language-pack-gnome-wo		13.10+20131012
setvar language-pack-gnome-wo-base	13.10+20131012
setvar language-pack-xh			13.10+20131012
setvar language-pack-xh-base		13.10+20131012
setvar language-pack-gnome-xh		13.10+20131012
setvar language-pack-gnome-xh-base	13.10+20131012
setvar language-pack-yi			13.10+20131012
setvar language-pack-yi-base		13.10+20131012
setvar language-pack-gnome-yi		13.10+20131012
setvar language-pack-gnome-yi-base	13.10+20131012
setvar language-pack-yo			13.10+20131012
setvar language-pack-yo-base		13.10+20131012
setvar language-pack-gnome-yo		13.10+20131012
setvar language-pack-gnome-yo-base	13.10+20131012
setvar language-pack-zh			10.04+20091215
setvar language-pack-zh-base		10.04+20091212
setvar language-pack-gnome-zh		10.04+20091215
setvar language-pack-gnome-zh-base	10.04+20091212
setvar language-pack-zu			13.10+20131012
setvar language-pack-zu-base		13.10+20131012
setvar language-pack-gnome-zu		13.10+20131012
setvar language-pack-gnome-zu-base	13.10+20131012


## Only languages that are listed in /usr/portage/profiles/desc/linguas.desc are supported ##
IUSE_LINGUAS="aa af am an ar as ast az be be@latin bem ber
bg bn bo br bs ca ca@valencia crh cs csb cv cy da de dv dz el
en en_AU en_CA en_GB en@shaw en_US en_US@piglatin eo es et eu
fa fi fil fo fr fur fy ga gd gl gu gv ha he hi hr ht hu hy ia
id ig is it ja ka kk kl km kn ko ks ku kw ky la lb lg
li lo lt lv mai mg mhr mi mk ml mn mr ms mt my nan nb nds
nds@NFE ne nl nn nso oc om or os pa pap pl ps pt pt_BR
ro ru rw sa sc sd se shs si sk sl sn so sq sr sr@ije
sr@latin sr@Latn st sv sw ta te tg th ti tk tl tr ts tt ug uk
ur uz uz@cyrillic uz@Latn ve vi wa wae wo xh yi yo zh zu"

## Only languages that are listed in /usr/portage/profiles/desc/linguas.desc are supported ##
TARBALL_LANGS="aa af am an ar as ast az be bem ber bg bn bo
br bs ca crh cs csb cv cy da de dv dz el en eo es et eu fa fi
fil fo fr fur fy ga gd gl gu gv ha he hi hr ht hu hy ia id ig
is it ja ka kk kl km kn ko ks ku kw ky la lb lg li lo lt
lv mai mg mhr mi mk ml mn mr ms mt my nan nb nds ne nl nn
nso oc om or os pa pap pl ps pt ro ru rw sa sc sd se shs
si sk sl so sq sr st sv sw ta te tg th ti tk tl tr ts tt ug uk
ur uz ve vi wa wae wo xh yi yo zh zu"

for MY_LINGUA in ${IUSE_LINGUAS}; do
	IUSE+=" linguas_${MY_LINGUA}"
done
RESTRICT="mirror"

## CAUTION: Be sure to enable *all* LINGUAS in /etc/make.conf when creating Manifest ##
for TARBALL_LANG in ${TARBALL_LANGS}; do
	if has ${TARBALL_LANG} ${LINGUAS}; then
		for i in ${packages[@]}; do
			eval "_name=${i}; _ver=\${_ver_${i//-/_}}"
			if [[ ${_name} == *-${TARBALL_LANG}* ]]; then
				SRC_URI_array+=( linguas_${TARBALL_LANG}? \( ${UURL}/${_name}/${_name}_${_ver}.tar.gz \) )
			fi
		done
	fi
done
SRC_URI="${SRC_URI_array[@]}"
S="${WORKDIR}"

src_prepare() {
	if [ -z "${LINGUAS}" ]; then
		die "At least one LINGUA must be set in /etc/make.conf"
	fi
}

src_install() {
	einfo "Installing language files for the following LINGUAS: ${LINGUAS}"
	for TARBALL_LANG in ${TARBALL_LANGS}; do
		if has ${TARBALL_LANG} ${LINGUAS}; then
			for SUB_LANG in `find "${WORKDIR}/language-pack-gnome-${TARBALL_LANG}-base/data" -maxdepth 1 -type d | awk -Fdata/ '{print $NF}' | grep -v /data`; do
				# Remove all translations except those we need #
				find language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG} \
					-type f \! -iname '*activity-log-manager*' \
					-type f \! -iname '*compiz*' \
					-type f \! -iname '*ccsm*' \
					-type f \! -iname '*credentials-control-center*' \
					-type f \! -iname '*indicator-*' \
					-type f \! -iname '*libdbusmenu*' \
					-type f \! -iname '*signon*' \
					-type f \! -iname '*ubuntu-sso-client*' \
					-type f \! -iname '*unity*' \
						-delete || die

				if has ${SUB_LANG} ${LINGUAS}; then
					for pofile in `find "${WORKDIR}/language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG}/LC_MESSAGES/" -type f -name "*.po"`; do
						msgfmt -o ${pofile%%.po}.mo ${pofile}
						rm ${pofile}
					done
					insinto /usr/share/locale
					doins -r language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG}
				fi
			done
		fi
	done
}
