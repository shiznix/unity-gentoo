# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="zesty"
inherit ubuntu-versionator

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"

UURL="mirror://unity/pool/main/l"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="sys-devel/gettext"

setvar() {
	eval "${1//-/_}=(${2} ${3} ${4})"
}

#[fnc] [L10N]		[pack]         [pack-gnome]   [ubuntu tag]
setvar af		17.04+20170404 17.04+20170404
setvar am		17.04+20170404 17.04+20170404
setvar an		17.04+20170404 17.04+20170404
setvar ar		17.04+20170404 17.04+20170404
setvar as		17.04+20170404 17.04+20170404
setvar ast		17.04+20170404 17.04+20170404
setvar az		17.04+20170321 17.04+20170321
setvar be		17.04+20170404 17.04+20170404
setvar bg		17.04+20170404 17.04+20170404
setvar bn		17.04+20170404 17.04+20170404
setvar bo		14.10+20140909 14.10+20140909
setvar br		17.04+20170404 17.04+20170404
setvar bs		17.04+20170404 17.04+20170404
setvar ca		17.04+20170404 17.04+20170404
setvar ca-valencia	17.04+20170404 17.04+20170404 ca
setvar cs		17.04+20170404 17.04+20170404
setvar csb		14.04+20150804 14.04+20150804
setvar cy		17.04+20170404 17.04+20170404
setvar da		17.04+20170404 17.04+20170404
setvar de		17.04+20170404 17.04+20170404
setvar dz		17.04+20170404 17.04+20170404
setvar el		17.04+20170404 17.04+20170404
setvar en		17.04+20170404 17.04+20170404
setvar en-GB		17.04+20170404 17.04+20170404 en
setvar eo		17.04+20170404 17.04+20170404
setvar es		17.04+20170404 17.04+20170404
setvar et		17.04+20170404 17.04+20170404
setvar eu		17.04+20170404 17.04+20170404
setvar fa		17.04+20170404 17.04+20170404
setvar fi		17.04+20170404 17.04+20170404
setvar fil		14.04+20150804 14.04+20150804
setvar fo		14.04+20150804 14.04+20150804
setvar fr		17.04+20170404 17.04+20170404
setvar fy		14.04+20150804 14.04+20150804
setvar ga		17.04+20170404 17.04+20170404
setvar gd		17.04+20170404 17.04+20170404
setvar gl		17.04+20170404 17.04+20170404
setvar gu		17.04+20170404 17.04+20170404
setvar he		17.04+20170404 17.04+20170404
setvar hi		17.04+20170404 17.04+20170404
setvar hr		17.04+20170404 17.04+20170404
setvar hu		17.04+20170404 17.04+20170404
setvar hy		14.04+20150804 14.04+20150804
setvar ia		17.04+20170404 17.04+20170404
setvar id		17.04+20170404 17.04+20170404
setvar is		17.04+20170404 17.04+20170404
setvar it		17.04+20170404 17.04+20170404
setvar ja		17.04+20170404 17.04+20170404
setvar ka		17.04+20170321 17.04+20170321
setvar kk		17.04+20170404 17.04+20170404
setvar km		17.04+20170404 17.04+20170404
setvar kn		17.04+20170404 17.04+20170404
setvar ko		17.04+20170404 17.04+20170404
setvar ks		14.04+20150804 14.04+20150804
setvar ku		17.04+20170404 17.04+20170404
setvar ky		14.04+20150804 14.04+20150804
setvar la		12.04+20130128 12.04+20130128
setvar lb		14.04+20150804 14.04+20150804
setvar lo		14.04+20150804 14.04+20150804
setvar lt		17.04+20170404 17.04+20170404
setvar lv		17.04+20170404 17.04+20170404
setvar mai		17.04+20170404 17.04+20170404
setvar mi		14.04+20150804 14.04+20150804
setvar mk		17.04+20170404 17.04+20170404
setvar ml		17.04+20170404 17.04+20170404
setvar mn		16.04+20160214 16.04+20160214
setvar mr		17.04+20170404 17.04+20170404
setvar ms		17.04+20170404 17.04+20170404
setvar my		17.04+20170404 17.04+20170404
setvar nb		17.04+20170404 17.04+20170404
setvar nds		17.04+20170321 17.04+20170321
setvar ne		17.04+20170404 17.04+20170404
setvar nl		17.04+20170404 17.04+20170404
setvar nn		17.04+20170404 17.04+20170404
setvar nso		14.04+20150804 14.04+20150804
setvar oc		17.04+20170404 17.04+20170404
setvar om		14.04+20150804 14.04+20150804
setvar or		17.04+20170404 17.04+20170404
setvar pa		17.04+20170404 17.04+20170404
setvar pl		17.04+20170404 17.04+20170404
setvar pt		17.04+20170404 17.04+20170404
setvar pt-BR		17.04+20170404 17.04+20170404 pt
setvar ro		17.04+20170404 17.04+20170404
setvar ru		17.04+20170404 17.04+20170404
setvar rw		14.04+20150804 14.04+20150804
setvar sa		14.04+20150804 14.04+20150804
setvar sd		14.04+20150804 14.04+20150804
setvar se		14.04+20150804 14.04+20150804
setvar si		17.04+20170321 17.04+20170321
setvar sk		17.04+20170404 17.04+20170404
setvar sl		17.04+20170404 17.04+20170404
setvar sq		17.04+20170404 17.04+20170404
setvar sr		17.04+20170404 17.04+20170404
setvar sr-Latn		17.04+20170404 17.04+20170404 sr
setvar st		14.04+20150804 14.04+20150804
setvar sv		17.04+20170404 17.04+20170404
setvar sw		14.04+20150804 14.04+20150804
setvar ta		17.04+20170404 17.04+20170404
setvar te		17.04+20170404 17.04+20170404
setvar tg		17.04+20170404 17.04+20170404
setvar th		17.04+20170404 17.04+20170404
setvar tk		14.04+20150804 14.04+20150804
setvar tl		14.04+20150804 14.04+20150804
setvar tr		17.04+20170404 17.04+20170404
setvar ts		14.04+20150804 14.04+20150804
setvar tt		14.04+20150804 14.04+20150804
setvar ug		17.04+20170404 17.04+20170404
setvar uk		17.04+20170404 17.04+20170404
setvar ur-PK		14.04+20150804 14.04+20150804 ur
setvar uz		16.04+20160214 16.04+20160214
setvar uz-Cyrl		16.04+20160214 16.04+20160214 uz
setvar ve		14.04+20150804 14.04+20150804
setvar vi		17.04+20170404 17.04+20170404
setvar wa		14.04+20150804 14.04+20150804
setvar xh		17.04+20170321 17.04+20170321
setvar zh-CN		17.04+20170404 17.04+20170404 zh-hans
setvar zh-HK		17.04+20170404 17.04+20170404 zh-hant
setvar zh-TW		17.04+20170404 17.04+20170404 zh-hant
setvar zu		14.04+20150804 14.04+20150804

# Only valid IETF language tags that are listed in
#  /usr/portage/profiles/desc/l10n.desc are supported:
IUSE_L10N="af am an ar as ast az be bg bn bo br bs ca ca-valencia cs csb
cy da de dz el en en-GB eo es et eu fa fi fil fo fr fy ga gd gl gu he hi
hr hu hy ia id is it ja ka kk km kn ko ks ku ky la lb lo lt lv mai mi mk
ml mn mr ms my nb nds ne nl nn nso oc om or pa pl pt pt-BR ro ru rw sa
sd se si sk sl sq sr sr-Latn st sv sw ta te tg th tk tl tr ts tt ug uk
ur-PK uz uz-Cyrl ve vi wa xh zh-CN zh-HK zh-TW zu"

# IUSE and SRC_URI generator:
for use_flag in ${IUSE_L10N}; do
	IUSE+=" l10n_${use_flag}"
	use_flag=${use_flag//-/_}
	eval "tag=\${$use_flag[2]}"
	[ -z ${tag} ] && tag=${use_flag}
	eval "ver=\${$use_flag[0]}"
	eval "ver_gnome=\${$use_flag[1]}"
	compress="xz"; [[ ( ${ver//[!0-9]} < 161000000000 ) ]] && compress="gz"
	SRC_URI_array+=( "l10n_${use_flag//_/-}?" \(
		${UURL}/language-pack-${tag}-base/language-pack-${tag}-base_${ver}.tar.${compress}
		${UURL}/language-pack-gnome-${tag}-base/language-pack-gnome-${tag}-base_${ver_gnome}.tar.${compress} \) )
done
SRC_URI="${SRC_URI_array[@]}"

S="${WORKDIR}"

src_unpack() {
	if [ "${A}" != "" ]; then
		unpack ${A}
	else
		die "At least one L10N USE_EXPAND flag must be set!"
	fi
}

src_install() {
	# Remove all translations except those we need
	find "${S}" \
		-type f \! -name 'activity-log-manager.po' \
		-type f \! -name 'account-plugins.po' \
		-type f \! -name 'compiz.po' \
		-type f \! -name 'ccsm.po' \
		-type f \! -name 'credentials-control-center.po' \
		-type f \! -name 'hud.po' \
		-type f \! -name 'indicator-*' \
		-type f \! -name 'libdbusmenu.po' \
		-type f \! -name 'onboard.po' \
		-type f \! -name 'signon-ui.po' \
		-type f \! -name 'ubuntu-help.po' \
		-type f \! -name 'unity*' \
		-type f \! -name 'ureadahead.po' \
		-type f \! -name 'webbrowser-app.po' \
			-delete || die
	find "${S}" -mindepth 1 -type d -empty -delete || die
	for pofile in `find "${S}" -type f -name "*.po"`; do
		msgfmt -o ${pofile%%.po}.mo ${pofile}
		rm ${pofile}
	done
	insinto /usr/share/locale
	doins -r "${S}"/language-pack-*-base/data/*
}
