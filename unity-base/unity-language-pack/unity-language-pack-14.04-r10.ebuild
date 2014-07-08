# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit ubuntu-versionator

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l"	# Mirrors are too unpredictable #
UVER=
URELEASE="trusty"

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
setvar language-pack-aa			14.04+20140410
setvar language-pack-aa-base		14.04+20140410
setvar language-pack-gnome-aa		14.04+20140410
setvar language-pack-gnome-aa-base	14.04+20140410
setvar language-pack-af			14.04+20140410
setvar language-pack-af-base		14.04+20140410
setvar language-pack-gnome-af		14.04+20140410
setvar language-pack-gnome-af-base	14.04+20140410
setvar language-pack-am			14.04+20140410
setvar language-pack-am-base		14.04+20140410
setvar language-pack-gnome-am		14.04+20140410
setvar language-pack-gnome-am-base	14.04+20140410
setvar language-pack-an			14.04+20140410
setvar language-pack-an-base		14.04+20140410
setvar language-pack-gnome-an		14.04+20140410
setvar language-pack-gnome-an-base	14.04+20140410
setvar language-pack-ar			14.04+20140410
setvar language-pack-ar-base		14.04+20140410
setvar language-pack-gnome-ar		14.04+20140410
setvar language-pack-gnome-ar-base	14.04+20140410
setvar language-pack-as			14.04+20140410
setvar language-pack-as-base		14.04+20140410
setvar language-pack-gnome-as		14.04+20140410
setvar language-pack-gnome-as-base	14.04+20140410
setvar language-pack-ast		14.04+20140410
setvar language-pack-ast-base		14.04+20140410
setvar language-pack-gnome-ast		14.04+20140410
setvar language-pack-gnome-ast-base	14.04+20140410
setvar language-pack-az			14.04+20140410
setvar language-pack-az-base		14.04+20140410
setvar language-pack-gnome-az		14.04+20140410
setvar language-pack-gnome-az-base	14.04+20140410
setvar language-pack-be			14.04+20140410
setvar language-pack-be-base		14.04+20140410
setvar language-pack-gnome-be		14.04+20140410
setvar language-pack-gnome-be-base	14.04+20140410
setvar language-pack-bem		14.04+20140410
setvar language-pack-bem-base		14.04+20140410
setvar language-pack-gnome-bem		14.04+20140410
setvar language-pack-gnome-bem-base	14.04+20140410
setvar language-pack-ber		14.04+20140410
setvar language-pack-ber-base		14.04+20140410
setvar language-pack-gnome-ber		14.04+20140410
setvar language-pack-gnome-ber-base	14.04+20140410
setvar language-pack-bg			14.04+20140410
setvar language-pack-bg-base		14.04+20140410
setvar language-pack-gnome-bg		14.04+20140410
setvar language-pack-gnome-bg-base	14.04+20140410
setvar language-pack-bn			14.04+20140410
setvar language-pack-bn-base		14.04+20140410
setvar language-pack-gnome-bn		14.04+20140410
setvar language-pack-gnome-bn-base	14.04+20140410
setvar language-pack-bo			14.04+20140410
setvar language-pack-bo-base		14.04+20140410
setvar language-pack-gnome-bo		14.04+20140410
setvar language-pack-gnome-bo-base	14.04+20140410
setvar language-pack-br			14.04+20140410
setvar language-pack-br-base		14.04+20140410
setvar language-pack-gnome-br		14.04+20140410
setvar language-pack-gnome-br-base	14.04+20140410
setvar language-pack-bs			14.04+20140410
setvar language-pack-bs-base		14.04+20140410
setvar language-pack-gnome-bs		14.04+20140410
setvar language-pack-gnome-bs-base	14.04+20140410
setvar language-pack-ca			14.04+20140410
setvar language-pack-ca-base		14.04+20140410
setvar language-pack-gnome-ca		14.04+20140410
setvar language-pack-gnome-ca-base	14.04+20140410
setvar language-pack-crh		14.04+20140410
setvar language-pack-crh-base		14.04+20140410
setvar language-pack-gnome-crh		14.04+20140410
setvar language-pack-gnome-crh-base	14.04+20140410
setvar language-pack-cs			14.04+20140410
setvar language-pack-cs-base		14.04+20140410
setvar language-pack-gnome-cs		14.04+20140410
setvar language-pack-gnome-cs-base	14.04+20140410
setvar language-pack-csb		14.04+20140410
setvar language-pack-csb-base		14.04+20140410
setvar language-pack-gnome-csb		14.04+20140410
setvar language-pack-gnome-csb-base	14.04+20140410
setvar language-pack-cv			14.04+20140410
setvar language-pack-cv-base		14.04+20140410
setvar language-pack-gnome-cv		14.04+20140410
setvar language-pack-gnome-cv-base	14.04+20140410
setvar language-pack-cy			14.04+20140410
setvar language-pack-cy-base		14.04+20140410
setvar language-pack-gnome-cy		14.04+20140410
setvar language-pack-gnome-cy-base	14.04+20140410
setvar language-pack-da			14.04+20140410
setvar language-pack-da-base		14.04+20140410
setvar language-pack-gnome-da		14.04+20140410
setvar language-pack-gnome-da-base	14.04+20140410
setvar language-pack-de			14.04+20140410
setvar language-pack-de-base		14.04+20140410
setvar language-pack-gnome-de		14.04+20140410
setvar language-pack-gnome-de-base	14.04+20140410
setvar language-pack-dv			14.04+20140410
setvar language-pack-dv-base		14.04+20140410
setvar language-pack-gnome-dv		14.04+20140410
setvar language-pack-gnome-dv-base	14.04+20140410
setvar language-pack-dz			14.04+20140410
setvar language-pack-dz-base		14.04+20140410
setvar language-pack-gnome-dz		14.04+20140410
setvar language-pack-gnome-dz-base	14.04+20140410
setvar language-pack-el			14.04+20140410
setvar language-pack-el-base		14.04+20140410
setvar language-pack-gnome-el		14.04+20140410
setvar language-pack-gnome-el-base	14.04+20140410
setvar language-pack-en			14.04+20140410
setvar language-pack-en-base		14.04+20140410
setvar language-pack-gnome-en		14.04+20140410
setvar language-pack-gnome-en-base	14.04+20140410
setvar language-pack-eo			14.04+20140410
setvar language-pack-eo-base		14.04+20140410
setvar language-pack-gnome-eo		14.04+20140410
setvar language-pack-gnome-eo-base	14.04+20140410
setvar language-pack-es			14.04+20140410
setvar language-pack-es-base		14.04+20140410
setvar language-pack-gnome-es		14.04+20140410
setvar language-pack-gnome-es-base	14.04+20140410
setvar language-pack-et			14.04+20140410
setvar language-pack-et-base		14.04+20140410
setvar language-pack-gnome-et		14.04+20140410
setvar language-pack-gnome-et-base	14.04+20140410
setvar language-pack-eu			14.04+20140410
setvar language-pack-eu-base		14.04+20140410
setvar language-pack-gnome-eu		14.04+20140410
setvar language-pack-gnome-eu-base	14.04+20140410
setvar language-pack-fa			14.04+20140410
setvar language-pack-fa-base		14.04+20140410
setvar language-pack-gnome-fa		14.04+20140410
setvar language-pack-gnome-fa-base	14.04+20140410
setvar language-pack-fi			14.04+20140410
setvar language-pack-fi-base		14.04+20140410
setvar language-pack-gnome-fi		14.04+20140410
setvar language-pack-gnome-fi-base	14.04+20140410
setvar language-pack-fil		14.04+20140410
setvar language-pack-fil-base		14.04+20140410
setvar language-pack-gnome-fil		14.04+20140410
setvar language-pack-gnome-fil-base	14.04+20140410
setvar language-pack-fo			14.04+20140410
setvar language-pack-fo-base		14.04+20140410
setvar language-pack-gnome-fo		14.04+20140410
setvar language-pack-gnome-fo-base	14.04+20140410
setvar language-pack-fr			14.04+20140410
setvar language-pack-fr-base		14.04+20140410
setvar language-pack-gnome-fr		14.04+20140410
setvar language-pack-gnome-fr-base	14.04+20140410
setvar language-pack-fur		14.04+20140410
setvar language-pack-fur-base		14.04+20140410
setvar language-pack-gnome-fur		14.04+20140410
setvar language-pack-gnome-fur-base	14.04+20140410
setvar language-pack-fy			14.04+20140410
setvar language-pack-fy-base		14.04+20140410
setvar language-pack-gnome-fy		14.04+20140410
setvar language-pack-gnome-fy-base	14.04+20140410
setvar language-pack-ga			14.04+20140410
setvar language-pack-ga-base		14.04+20140410
setvar language-pack-gnome-ga		14.04+20140410
setvar language-pack-gnome-ga-base	14.04+20140410
setvar language-pack-gd			14.04+20140410
setvar language-pack-gd-base		14.04+20140410
setvar language-pack-gnome-gd		14.04+20140410
setvar language-pack-gnome-gd-base	14.04+20140410
setvar language-pack-gl			14.04+20140410
setvar language-pack-gl-base		14.04+20140410
setvar language-pack-gnome-gl		14.04+20140410
setvar language-pack-gnome-gl-base	14.04+20140410
setvar language-pack-gu			14.04+20140410
setvar language-pack-gu-base		14.04+20140410
setvar language-pack-gnome-gu		14.04+20140410
setvar language-pack-gnome-gu-base	14.04+20140410
setvar language-pack-gv			14.04+20140410
setvar language-pack-gv-base		14.04+20140410
setvar language-pack-gnome-gv		14.04+20140410
setvar language-pack-gnome-gv-base	14.04+20140410
setvar language-pack-ha			14.04+20140410
setvar language-pack-ha-base		14.04+20140410
setvar language-pack-gnome-ha		14.04+20140410
setvar language-pack-gnome-ha-base	14.04+20140410
setvar language-pack-he			14.04+20140410
setvar language-pack-he-base		14.04+20140410
setvar language-pack-gnome-he		14.04+20140410
setvar language-pack-gnome-he-base	14.04+20140410
setvar language-pack-hi			14.04+20140410
setvar language-pack-hi-base		14.04+20140410
setvar language-pack-gnome-hi		14.04+20140410
setvar language-pack-gnome-hi-base	14.04+20140410
setvar language-pack-hr			14.04+20140410
setvar language-pack-hr-base		14.04+20140410
setvar language-pack-gnome-hr		14.04+20140410
setvar language-pack-gnome-hr-base	14.04+20140410
setvar language-pack-ht			14.04+20140410
setvar language-pack-ht-base		14.04+20140410
setvar language-pack-gnome-ht		14.04+20140410
setvar language-pack-gnome-ht-base	14.04+20140410
setvar language-pack-hu			14.04+20140410
setvar language-pack-hu-base		14.04+20140410
setvar language-pack-gnome-hu		14.04+20140410
setvar language-pack-gnome-hu-base	14.04+20140410
setvar language-pack-hy			14.04+20140410
setvar language-pack-hy-base		14.04+20140410
setvar language-pack-gnome-hy		14.04+20140410
setvar language-pack-gnome-hy-base	14.04+20140410
setvar language-pack-ia			14.04+20140410
setvar language-pack-ia-base		14.04+20140410
setvar language-pack-gnome-ia		14.04+20140410
setvar language-pack-gnome-ia-base	14.04+20140410
setvar language-pack-id			14.04+20140410
setvar language-pack-id-base		14.04+20140410
setvar language-pack-gnome-id		14.04+20140410
setvar language-pack-gnome-id-base	14.04+20140410
setvar language-pack-ig			14.04+20140410
setvar language-pack-ig-base		14.04+20140410
setvar language-pack-gnome-ig		14.04+20140410
setvar language-pack-gnome-ig-base	14.04+20140410
setvar language-pack-is			14.04+20140410
setvar language-pack-is-base		14.04+20140410
setvar language-pack-gnome-is		14.04+20140410
setvar language-pack-gnome-is-base	14.04+20140410
setvar language-pack-it			14.04+20140410
setvar language-pack-it-base		14.04+20140410
setvar language-pack-gnome-it		14.04+20140410
setvar language-pack-gnome-it-base	14.04+20140410
setvar language-pack-ja			14.04+20140410
setvar language-pack-ja-base		14.04+20140410
setvar language-pack-gnome-ja		14.04+20140410
setvar language-pack-gnome-ja-base	14.04+20140410
setvar language-pack-ka			14.04+20140410
setvar language-pack-ka-base		14.04+20140410
setvar language-pack-gnome-ka		14.04+20140410
setvar language-pack-gnome-ka-base	14.04+20140410
setvar language-pack-kk			14.04+20140410
setvar language-pack-kk-base		14.04+20140410
setvar language-pack-gnome-kk		14.04+20140410
setvar language-pack-gnome-kk-base	14.04+20140410
setvar language-pack-kl			14.04+20140410
setvar language-pack-kl-base		14.04+20140410
setvar language-pack-gnome-kl		14.04+20140410
setvar language-pack-gnome-kl-base	14.04+20140410
setvar language-pack-km			14.04+20140410
setvar language-pack-km-base		14.04+20140410
setvar language-pack-gnome-km		14.04+20140410
setvar language-pack-gnome-km-base	14.04+20140410
setvar language-pack-kn			14.04+20140410
setvar language-pack-kn-base		14.04+20140410
setvar language-pack-gnome-kn		14.04+20140410
setvar language-pack-gnome-kn-base	14.04+20140410
setvar language-pack-ko			14.04+20140410
setvar language-pack-ko-base		14.04+20140410
setvar language-pack-gnome-ko		14.04+20140410
setvar language-pack-gnome-ko-base	14.04+20140410
setvar language-pack-ks			14.04+20140410
setvar language-pack-ks-base		14.04+20140410
setvar language-pack-gnome-ks		14.04+20140410
setvar language-pack-gnome-ks-base	14.04+20140410
setvar language-pack-ku			14.04+20140410
setvar language-pack-ku-base		14.04+20140410
setvar language-pack-gnome-ku		14.04+20140410
setvar language-pack-gnome-ku-base	14.04+20140410
setvar language-pack-kw			14.04+20140410
setvar language-pack-kw-base		14.04+20140410
setvar language-pack-gnome-kw		14.04+20140410
setvar language-pack-gnome-kw-base	14.04+20140410
setvar language-pack-ky			14.04+20140410
setvar language-pack-ky-base		14.04+20140410
setvar language-pack-gnome-ky		14.04+20140410
setvar language-pack-gnome-ky-base	14.04+20140410
setvar language-pack-la			12.10+20121009
setvar language-pack-la-base		12.10+20121009
setvar language-pack-gnome-la		12.10+20121009
setvar language-pack-gnome-la-base	12.10+20121009
setvar language-pack-lb			14.04+20140410
setvar language-pack-lb-base		14.04+20140410
setvar language-pack-gnome-lb		14.04+20140410
setvar language-pack-gnome-lb-base	14.04+20140410
setvar language-pack-lg			14.04+20140410
setvar language-pack-lg-base		14.04+20140410
setvar language-pack-gnome-lg		14.04+20140410
setvar language-pack-gnome-lg-base	14.04+20140410
setvar language-pack-li			14.04+20140410
setvar language-pack-li-base		14.04+20140410
setvar language-pack-gnome-li		14.04+20140410
setvar language-pack-gnome-li-base	14.04+20140410
setvar language-pack-lo			14.04+20140410
setvar language-pack-lo-base		14.04+20140410
setvar language-pack-gnome-lo		14.04+20140410
setvar language-pack-gnome-lo-base	14.04+20140410
setvar language-pack-lt			14.04+20140410
setvar language-pack-lt-base		14.04+20140410
setvar language-pack-gnome-lt		14.04+20140410
setvar language-pack-gnome-lt-base	14.04+20140410
setvar language-pack-lv			14.04+20140410
setvar language-pack-lv-base		14.04+20140410
setvar language-pack-gnome-lv		14.04+20140410
setvar language-pack-gnome-lv-base	14.04+20140410
setvar language-pack-mai		14.04+20140410
setvar language-pack-mai-base		14.04+20140410
setvar language-pack-gnome-mai		14.04+20140410
setvar language-pack-gnome-mai-base	14.04+20140410
setvar language-pack-mg			14.04+20140410
setvar language-pack-mg-base		14.04+20140410
setvar language-pack-gnome-mg		14.04+20140410
setvar language-pack-gnome-mg-base	14.04+20140410
setvar language-pack-mhr		14.04+20140410
setvar language-pack-mhr-base		14.04+20140410
setvar language-pack-gnome-mhr		14.04+20140410
setvar language-pack-gnome-mhr-base	14.04+20140410
setvar language-pack-mi			14.04+20140410
setvar language-pack-mi-base		14.04+20140410
setvar language-pack-gnome-mi		14.04+20140410
setvar language-pack-gnome-mi-base	14.04+20140410
setvar language-pack-mk			14.04+20140410
setvar language-pack-mk-base		14.04+20140410
setvar language-pack-gnome-mk		14.04+20140410
setvar language-pack-gnome-mk-base	14.04+20140410
setvar language-pack-ml			14.04+20140410
setvar language-pack-ml-base		14.04+20140410
setvar language-pack-gnome-ml		14.04+20140410
setvar language-pack-gnome-ml-base	14.04+20140410
setvar language-pack-mn			14.04+20140410
setvar language-pack-mn-base		14.04+20140410
setvar language-pack-gnome-mn		14.04+20140410
setvar language-pack-gnome-mn-base	14.04+20140410
setvar language-pack-mr			14.04+20140410
setvar language-pack-mr-base		14.04+20140410
setvar language-pack-gnome-mr		14.04+20140410
setvar language-pack-gnome-mr-base	14.04+20140410
setvar language-pack-ms			14.04+20140410
setvar language-pack-ms-base		14.04+20140410
setvar language-pack-gnome-ms		14.04+20140410
setvar language-pack-gnome-ms-base	14.04+20140410
setvar language-pack-mt			14.04+20140410
setvar language-pack-mt-base		14.04+20140410
setvar language-pack-gnome-mt		14.04+20140410
setvar language-pack-gnome-mt-base	14.04+20140410
setvar language-pack-my			14.04+20140410
setvar language-pack-my-base		14.04+20140410
setvar language-pack-gnome-my		14.04+20140410
setvar language-pack-gnome-my-base	14.04+20140410
setvar language-pack-nan		14.04+20140410
setvar language-pack-nan-base		14.04+20140410
setvar language-pack-gnome-nan		14.04+20140410
setvar language-pack-gnome-nan-base	14.04+20140410
setvar language-pack-nb			14.04+20140410
setvar language-pack-nb-base		14.04+20140410
setvar language-pack-gnome-nb		14.04+20140410
setvar language-pack-gnome-nb-base	14.04+20140410
setvar language-pack-nds		14.04+20140410
setvar language-pack-nds-base		14.04+20140410
setvar language-pack-gnome-nds		14.04+20140410
setvar language-pack-gnome-nds-base	14.04+20140410
setvar language-pack-ne			14.04+20140410
setvar language-pack-ne-base		14.04+20140410
setvar language-pack-gnome-ne		14.04+20140410
setvar language-pack-gnome-ne-base	14.04+20140410
setvar language-pack-nl			14.04+20140410
setvar language-pack-nl-base		14.04+20140410
setvar language-pack-gnome-nl		14.04+20140410
setvar language-pack-gnome-nl-base	14.04+20140410
setvar language-pack-nn			14.04+20140410
setvar language-pack-nn-base		14.04+20140410
setvar language-pack-gnome-nn		14.04+20140410
setvar language-pack-gnome-nn-base	14.04+20140410
setvar language-pack-nso		14.04+20140410
setvar language-pack-nso-base		14.04+20140410
setvar language-pack-gnome-nso		14.04+20140410
setvar language-pack-gnome-nso-base	14.04+20140410
setvar language-pack-oc			14.04+20140410
setvar language-pack-oc-base		14.04+20140410
setvar language-pack-gnome-oc		14.04+20140410
setvar language-pack-gnome-oc-base	14.04+20140410
setvar language-pack-om			14.04+20140410
setvar language-pack-om-base		14.04+20140410
setvar language-pack-gnome-om		14.04+20140410
setvar language-pack-gnome-om-base	14.04+20140410
setvar language-pack-or			14.04+20140410
setvar language-pack-or-base		14.04+20140410
setvar language-pack-gnome-or		14.04+20140410
setvar language-pack-gnome-or-base	14.04+20140410
setvar language-pack-os			14.04+20140410
setvar language-pack-os-base		14.04+20140410
setvar language-pack-gnome-os		14.04+20140410
setvar language-pack-gnome-os-base	14.04+20140410
setvar language-pack-pa			14.04+20140410
setvar language-pack-pa-base		14.04+20140410
setvar language-pack-gnome-pa		14.04+20140410
setvar language-pack-gnome-pa-base	14.04+20140410
setvar language-pack-pap		14.04+20140410
setvar language-pack-pap-base		14.04+20140410
setvar language-pack-gnome-pap		14.04+20140410
setvar language-pack-gnome-pap-base	14.04+20140410
setvar language-pack-pl			14.04+20140410
setvar language-pack-pl-base		14.04+20140410
setvar language-pack-gnome-pl		14.04+20140410
setvar language-pack-gnome-pl-base	14.04+20140410
setvar language-pack-ps			14.04+20140410
setvar language-pack-ps-base		14.04+20140410
setvar language-pack-gnome-ps		14.04+20140410
setvar language-pack-gnome-ps-base	14.04+20140410
setvar language-pack-pt			14.04+20140410
setvar language-pack-pt-base		14.04+20140410
setvar language-pack-gnome-pt		14.04+20140410
setvar language-pack-gnome-pt-base	14.04+20140410
setvar language-pack-ro			14.04+20140410
setvar language-pack-ro-base		14.04+20140410
setvar language-pack-gnome-ro		14.04+20140410
setvar language-pack-gnome-ro-base	14.04+20140410
setvar language-pack-ru			14.04+20140410
setvar language-pack-ru-base		14.04+20140410
setvar language-pack-gnome-ru		14.04+20140410
setvar language-pack-gnome-ru-base	14.04+20140410
setvar language-pack-rw			14.04+20140410
setvar language-pack-rw-base		14.04+20140410
setvar language-pack-gnome-rw		14.04+20140410
setvar language-pack-gnome-rw-base	14.04+20140410
setvar language-pack-sa			14.04+20140410
setvar language-pack-sa-base		14.04+20140410
setvar language-pack-gnome-sa		14.04+20140410
setvar language-pack-gnome-sa-base	14.04+20140410
setvar language-pack-sc			14.04+20140410
setvar language-pack-sc-base		14.04+20140410
setvar language-pack-gnome-sc		14.04+20140410
setvar language-pack-gnome-sc-base	14.04+20140410
setvar language-pack-sd			14.04+20140410
setvar language-pack-sd-base		14.04+20140410
setvar language-pack-gnome-sd		14.04+20140410
setvar language-pack-gnome-sd-base	14.04+20140410
setvar language-pack-se			14.04+20140410
setvar language-pack-se-base		14.04+20140410
setvar language-pack-gnome-se		14.04+20140410
setvar language-pack-gnome-se-base	14.04+20140410
setvar language-pack-shs		14.04+20140410
setvar language-pack-shs-base		14.04+20140410
setvar language-pack-gnome-shs		14.04+20140410
setvar language-pack-gnome-shs-base	14.04+20140410
setvar language-pack-si			14.04+20140410
setvar language-pack-si-base		14.04+20140410
setvar language-pack-gnome-si		14.04+20140410
setvar language-pack-gnome-si-base	14.04+20140410
setvar language-pack-sk			14.04+20140410
setvar language-pack-sk-base		14.04+20140410
setvar language-pack-gnome-sk		14.04+20140410
setvar language-pack-gnome-sk-base	14.04+20140410
setvar language-pack-sl			14.04+20140410
setvar language-pack-sl-base		14.04+20140410
setvar language-pack-gnome-sl		14.04+20140410
setvar language-pack-gnome-sl-base	14.04+20140410
setvar language-pack-so			13.04+20130418
setvar language-pack-so-base		13.04+20130418
setvar language-pack-gnome-so		13.04+20130418
setvar language-pack-gnome-so-base	13.04+20130418
setvar language-pack-sq			14.04+20140410
setvar language-pack-sq-base		14.04+20140410
setvar language-pack-gnome-sq		14.04+20140410
setvar language-pack-gnome-sq-base	14.04+20140410
setvar language-pack-sr			14.04+20140410
setvar language-pack-sr-base		14.04+20140410
setvar language-pack-gnome-sr		14.04+20140410
setvar language-pack-gnome-sr-base	14.04+20140410
setvar language-pack-st			14.04+20140410
setvar language-pack-st-base		14.04+20140410
setvar language-pack-gnome-st		14.04+20140410
setvar language-pack-gnome-st-base	14.04+20140410
setvar language-pack-sv			14.04+20140410
setvar language-pack-sv-base		14.04+20140410
setvar language-pack-gnome-sv		14.04+20140410
setvar language-pack-gnome-sv-base	14.04+20140410
setvar language-pack-sw			14.04+20140410
setvar language-pack-sw-base		14.04+20140410
setvar language-pack-gnome-sw		14.04+20140410
setvar language-pack-gnome-sw-base	14.04+20140410
setvar language-pack-ta			14.04+20140410
setvar language-pack-ta-base		14.04+20140410
setvar language-pack-gnome-ta		14.04+20140410
setvar language-pack-gnome-ta-base	14.04+20140410
setvar language-pack-te			14.04+20140410
setvar language-pack-te-base		14.04+20140410
setvar language-pack-gnome-te		14.04+20140410
setvar language-pack-gnome-te-base	14.04+20140410
setvar language-pack-tg			14.04+20140410
setvar language-pack-tg-base		14.04+20140410
setvar language-pack-gnome-tg		14.04+20140410
setvar language-pack-gnome-tg-base	14.04+20140410
setvar language-pack-th			14.04+20140410
setvar language-pack-th-base		14.04+20140410
setvar language-pack-gnome-th		14.04+20140410
setvar language-pack-gnome-th-base	14.04+20140410
setvar language-pack-ti			14.04+20140410
setvar language-pack-ti-base		14.04+20140410
setvar language-pack-gnome-ti		14.04+20140410
setvar language-pack-gnome-ti-base	14.04+20140410
setvar language-pack-tk			14.04+20140410
setvar language-pack-tk-base		14.04+20140410
setvar language-pack-gnome-tk		14.04+20140410
setvar language-pack-gnome-tk-base	14.04+20140410
setvar language-pack-tl			14.04+20140410
setvar language-pack-tl-base		14.04+20140410
setvar language-pack-gnome-tl		14.04+20140410
setvar language-pack-gnome-tl-base	14.04+20140410
setvar language-pack-tr			14.04+20140410
setvar language-pack-tr-base		14.04+20140410
setvar language-pack-gnome-tr		14.04+20140410
setvar language-pack-gnome-tr-base	14.04+20140410
setvar language-pack-ts			14.04+20140410
setvar language-pack-ts-base		14.04+20140410
setvar language-pack-gnome-ts		14.04+20140410
setvar language-pack-gnome-ts-base	14.04+20140410
setvar language-pack-tt			14.04+20140410
setvar language-pack-tt-base		14.04+20140410
setvar language-pack-gnome-tt		14.04+20140410
setvar language-pack-gnome-tt-base	14.04+20140410
setvar language-pack-ug			14.04+20140410
setvar language-pack-ug-base		14.04+20140410
setvar language-pack-gnome-ug		14.04+20140410
setvar language-pack-gnome-ug-base	14.04+20140410
setvar language-pack-uk			14.04+20140410
setvar language-pack-uk-base		14.04+20140410
setvar language-pack-gnome-uk		14.04+20140410
setvar language-pack-gnome-uk-base	14.04+20140410
setvar language-pack-ur			14.04+20140410
setvar language-pack-ur-base		14.04+20140410
setvar language-pack-gnome-ur		14.04+20140410
setvar language-pack-gnome-ur-base	14.04+20140410
setvar language-pack-uz			14.04+20140410
setvar language-pack-uz-base		14.04+20140410
setvar language-pack-gnome-uz		14.04+20140410
setvar language-pack-gnome-uz-base	14.04+20140410
setvar language-pack-ve			14.04+20140410
setvar language-pack-ve-base		14.04+20140410
setvar language-pack-gnome-ve		14.04+20140410
setvar language-pack-gnome-ve-base	14.04+20140410
setvar language-pack-vi			14.04+20140410
setvar language-pack-vi-base		14.04+20140410
setvar language-pack-gnome-vi		14.04+20140410
setvar language-pack-gnome-vi-base	14.04+20140410
setvar language-pack-wa			14.04+20140410
setvar language-pack-wa-base		14.04+20140410
setvar language-pack-gnome-wa		14.04+20140410
setvar language-pack-gnome-wa-base	14.04+20140410
setvar language-pack-wae		14.04+20140410
setvar language-pack-wae-base		14.04+20140410
setvar language-pack-gnome-wae		14.04+20140410
setvar language-pack-gnome-wae-base	14.04+20140410
setvar language-pack-wo			14.04+20140410
setvar language-pack-wo-base		14.04+20140410
setvar language-pack-gnome-wo		14.04+20140410
setvar language-pack-gnome-wo-base	14.04+20140410
setvar language-pack-xh			14.04+20140410
setvar language-pack-xh-base		14.04+20140410
setvar language-pack-gnome-xh		14.04+20140410
setvar language-pack-gnome-xh-base	14.04+20140410
setvar language-pack-yi			14.04+20140410
setvar language-pack-yi-base		14.04+20140410
setvar language-pack-gnome-yi		14.04+20140410
setvar language-pack-gnome-yi-base	14.04+20140410
setvar language-pack-yo			14.04+20140410
setvar language-pack-yo-base		14.04+20140410
setvar language-pack-gnome-yo		14.04+20140410
setvar language-pack-gnome-yo-base	14.04+20140410
setvar language-pack-zh			10.04+20091215
setvar language-pack-zh-base		10.04+20091212
setvar language-pack-gnome-zh		10.04+20091215
setvar language-pack-gnome-zh-base	10.04+20091212
setvar language-pack-zu			14.04+20140410
setvar language-pack-zu-base		14.04+20140410
setvar language-pack-gnome-zu		14.04+20140410
setvar language-pack-gnome-zu-base	14.04+20140410


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
				find "language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG}" \
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
