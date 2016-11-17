# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety"
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
setvar af		16.10+20161009 16.10+20161009
setvar am		16.10+20161009 16.10+20161009
setvar an		16.10+20161009 16.10+20161009
setvar ar		16.10+20161009 16.10+20161009
setvar as		16.10+20161009 16.10+20161009
setvar ast		16.10+20161009 16.10+20161009
setvar az		16.10+20161009 16.10+20161009
setvar be		16.10+20161009 16.10+20161009
setvar bg		16.10+20161009 16.10+20161009
setvar bn		16.10+20161009 16.10+20161009
setvar bo		14.10+20140909 14.10+20140909
setvar br		16.10+20161009 16.10+20161009
setvar bs		16.10+20161009 16.10+20161009
setvar ca		16.10+20161009 16.10+20161009
setvar ca-valencia	16.10+20161009 16.10+20161009 ca
setvar cs		16.10+20161009 16.10+20161009
setvar csb		14.04+20150804 14.04+20150804
setvar cy		16.10+20161009 16.10+20161009
setvar da		16.10+20161009 16.10+20161009
setvar de		16.10+20161009 16.10+20161009
setvar dz		16.10+20161009 16.10+20161009
setvar el		16.10+20161009 16.10+20161009
setvar en		16.10+20161009 16.10+20161009
setvar en-GB		16.10+20161009 16.10+20161009 en
setvar eo		16.10+20161009 16.10+20161009
setvar es		16.10+20161009 16.10+20161009
setvar et		16.10+20161009 16.10+20161009
setvar eu		16.10+20161009 16.10+20161009
setvar fa		16.10+20161009 16.10+20161009
setvar fi		16.10+20161009 16.10+20161009
setvar fil		14.04+20150804 14.04+20150804
setvar fo		14.04+20150804 14.04+20150804
setvar fr		16.10+20161009 16.10+20161009
setvar fy		14.04+20150804 14.04+20150804
setvar ga		16.10+20161009 16.10+20161009
setvar gd		16.10+20161009 16.10+20161009
setvar gl		16.10+20161009 16.10+20161009
setvar gu		16.10+20161009 16.10+20161009
setvar he		16.10+20161009 16.10+20161009
setvar hi		16.10+20161009 16.10+20161009
setvar hr		16.10+20161009 16.10+20161009
setvar hu		16.10+20161009 16.10+20161009
setvar hy		14.04+20150804 14.04+20150804
setvar ia		16.10+20161009 16.10+20161009
setvar id		16.10+20161009 16.10+20161009
setvar is		16.10+20161009 16.10+20161009
setvar it		16.10+20161009 16.10+20161009
setvar ja		16.10+20161009 16.10+20161009
setvar ka		16.10+20161009 16.10+20161009
setvar kk		16.10+20161009 16.10+20161009
setvar km		16.10+20161009 16.10+20161009
setvar kn		16.10+20161009 16.10+20161009
setvar ko		16.10+20161009 16.10+20161009
setvar ks		14.04+20150804 14.04+20150804
setvar ku		16.10+20161009 16.10+20161009
setvar ky		14.04+20150804 14.04+20150804
setvar la		12.04+20130128 12.04+20130128
setvar lb		14.04+20150804 14.04+20150804
setvar lo		14.04+20150804 14.04+20150804
setvar lt		16.10+20161009 16.10+20161009
setvar lv		16.10+20161009 16.10+20161009
setvar mai		16.10+20161009 16.10+20161009
setvar mi		14.04+20150804 14.04+20150804
setvar mk		16.10+20161009 16.10+20161009
setvar ml		16.10+20161009 16.10+20161009
setvar mn		16.04+20160214 16.04+20160214
setvar mr		16.10+20161009 16.10+20161009
setvar ms		16.10+20161009 16.10+20161009
setvar my		16.10+20161009 16.10+20161009
setvar nb		16.10+20161009 16.10+20161009
setvar nds		16.10+20161009 16.10+20161009
setvar ne		16.10+20161009 16.10+20161009
setvar nl		16.10+20161009 16.10+20161009
setvar nn		16.10+20161009 16.10+20161009
setvar nso		14.04+20150804 14.04+20150804
setvar oc		16.10+20161009 16.10+20161009
setvar om		14.04+20150804 14.04+20150804
setvar or		16.10+20161009 16.10+20161009
setvar pa		16.10+20161009 16.10+20161009
setvar pl		16.10+20161009 16.10+20161009
setvar pt		16.10+20161009 16.10+20161009
setvar pt-BR		16.10+20161009 16.10+20161009 pt
setvar ro		16.10+20161009 16.10+20161009
setvar ru		16.10+20161009 16.10+20161009
setvar rw		14.04+20150804 14.04+20150804
setvar sa		14.04+20150804 14.04+20150804
setvar sd		14.04+20150804 14.04+20150804
setvar se		14.04+20150804 14.04+20150804
setvar si		16.10+20161009 16.10+20161009
setvar sk		16.10+20161009 16.10+20161009
setvar sl		16.10+20161009 16.10+20161009
setvar sq		16.10+20161009 16.10+20161009
setvar sr		16.10+20161009 16.10+20161009
setvar sr-Latn		16.10+20161009 16.10+20161009 sr
setvar st		14.04+20150804 14.04+20150804
setvar sv		16.10+20161009 16.10+20161009
setvar sw		14.04+20150804 14.04+20150804
setvar ta		16.10+20161009 16.10+20161009
setvar te		16.10+20161009 16.10+20161009
setvar tg		16.10+20161009 16.10+20161009
setvar th		16.10+20161009 16.10+20161009
setvar tk		14.04+20150804 14.04+20150804
setvar tl		14.04+20150804 14.04+20150804
setvar tr		16.10+20161009 16.10+20161009
setvar ts		14.04+20150804 14.04+20150804
setvar tt		14.04+20150804 14.04+20150804
setvar ug		16.10+20161009 16.10+20161009
setvar uk		16.10+20161009 16.10+20161009
setvar ur-PK		14.04+20150804 14.04+20150804 ur
setvar uz		16.04+20160214 16.04+20160214
setvar uz-Cyrl		16.04+20160214 16.04+20160214 uz
setvar ve		14.04+20150804 14.04+20150804
setvar vi		16.10+20161009 16.10+20161009
setvar wa		14.04+20150804 14.04+20150804
setvar xh		16.10+20161009 16.10+20161009
setvar zh-CN		16.10+20161009 16.10+20161009 zh-hans
setvar zh-HK		16.10+20161009 16.10+20161009 zh-hant
setvar zh-TW		16.10+20161009 16.10+20161009 zh-hant
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
