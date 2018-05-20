# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="bionic"
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
setvar af		18.04+20180423 18.04+20180423
setvar am		18.04+20180423 18.04+20180423
setvar an		18.04+20180423 18.04+20180423
setvar ar		18.04+20180423 18.04+20180423
setvar as		18.04+20180423 18.04+20180423
setvar ast		18.04+20180423 18.04+20180423
setvar az		17.10+20171012 17.10+20171012
setvar be		18.04+20180423 18.04+20180423
setvar bg		18.04+20180423 18.04+20180423
setvar bn		18.04+20180423 18.04+20180423
setvar bo		14.10+20140909 14.10+20140909
setvar br		18.04+20180423 18.04+20180423
setvar bs		18.04+20180423 18.04+20180423
setvar ca		18.04+20180423 18.04+20180423
setvar ca-valencia	18.04+20180423 18.04+20180423 ca
setvar cs		18.04+20180423 18.04+20180423
setvar csb		14.04+20150804 14.04+20150804
setvar cy		18.04+20180423 18.04+20180423
setvar da		18.04+20180423 18.04+20180423
setvar de		18.04+20180423 18.04+20180423
setvar dz		18.04+20180423 18.04+20180423
setvar el		18.04+20180423 18.04+20180423
setvar en		18.04+20180423 18.04+20180423
setvar en-GB		18.04+20180423 18.04+20180423 en
setvar eo		18.04+20180423 18.04+20180423
setvar es		18.04+20180423 18.04+20180423
setvar et		18.04+20180423 18.04+20180423
setvar eu		18.04+20180423 18.04+20180423
setvar fa		18.04+20180423 18.04+20180423
setvar fi		18.04+20180423 18.04+20180423
setvar fil		14.04+20150804 14.04+20150804
setvar fo		14.04+20150804 14.04+20150804
setvar fr		18.04+20180423 18.04+20180423
setvar fy		14.04+20150804 14.04+20150804
setvar ga		18.04+20180423 18.04+20180423
setvar gd		18.04+20180423 18.04+20180423
setvar gl		18.04+20180423 18.04+20180423
setvar gu		18.04+20180423 18.04+20180423
setvar he		18.04+20180423 18.04+20180423
setvar hi		18.04+20180423 18.04+20180423
setvar hr		18.04+20180423 18.04+20180423
setvar hu		18.04+20180423 18.04+20180423
setvar hy		14.04+20150804 14.04+20150804
setvar ia		18.04+20180423 18.04+20180423
setvar id		18.04+20180423 18.04+20180423
setvar is		18.04+20180423 18.04+20180423
setvar it		18.04+20180423 18.04+20180423
setvar ja		18.04+20180423 18.04+20180423
setvar ka		17.10+20171012 17.10+20171012
setvar kk		18.04+20180423 18.04+20180423
setvar km		18.04+20180423 18.04+20180423
setvar kn		18.04+20180423 18.04+20180423
setvar ko		18.04+20180423 18.04+20180423
setvar ks		14.04+20150804 14.04+20150804
setvar ku		18.04+20180423 18.04+20180423
setvar ky		14.04+20150804 14.04+20150804
setvar la		12.04+20130128 12.04+20130128
setvar lb		14.04+20150804 14.04+20150804
setvar lo		14.04+20150804 14.04+20150804
setvar lt		18.04+20180423 18.04+20180423
setvar lv		18.04+20180423 18.04+20180423
setvar mai		18.04+20180423 18.04+20180423
setvar mi		14.04+20150804 14.04+20150804
setvar mk		18.04+20180423 18.04+20180423
setvar ml		18.04+20180423 18.04+20180423
setvar mn		16.04+20160214 16.04+20160214
setvar mr		18.04+20180423 18.04+20180423
setvar ms		18.04+20180423 18.04+20180423
setvar my		18.04+20180423 18.04+20180423
setvar nb		18.04+20180423 18.04+20180423
setvar nds		17.10+20171012 17.10+20171012
setvar ne		18.04+20180423 18.04+20180423
setvar nl		18.04+20180423 18.04+20180423
setvar nn		18.04+20180423 18.04+20180423
setvar nso		14.04+20150804 14.04+20150804
setvar oc		18.04+20180423 18.04+20180423
setvar om		14.04+20150804 14.04+20150804
setvar or		18.04+20180423 18.04+20180423
setvar pa		18.04+20180423 18.04+20180423
setvar pl		18.04+20180423 18.04+20180423
setvar pt		18.04+20180423 18.04+20180423
setvar pt-BR		18.04+20180423 18.04+20180423 pt
setvar ro		18.04+20180423 18.04+20180423
setvar ru		18.04+20180423 18.04+20180423
setvar rw		14.04+20150804 14.04+20150804
setvar sa		14.04+20150804 14.04+20150804
setvar sd		14.04+20150804 14.04+20150804
setvar se		14.04+20150804 14.04+20150804
setvar si		18.04+20180423 18.04+20180423
setvar sk		18.04+20180423 18.04+20180423
setvar sl		18.04+20180423 18.04+20180423
setvar sq		18.04+20180423 18.04+20180423
setvar sr		18.04+20180423 18.04+20180423
setvar sr-Latn		18.04+20180423 18.04+20180423 sr
setvar st		14.04+20150804 14.04+20150804
setvar sv		18.04+20180423 18.04+20180423
setvar sw		14.04+20150804 14.04+20150804
setvar ta		18.04+20180423 18.04+20180423
setvar te		18.04+20180423 18.04+20180423
setvar tg		18.04+20180423 18.04+20180423
setvar th		18.04+20180423 18.04+20180423
setvar tk		14.04+20150804 14.04+20150804
setvar tl		14.04+20150804 14.04+20150804
setvar tr		18.04+20180423 18.04+20180423
setvar ts		14.04+20150804 14.04+20150804
setvar tt		14.04+20150804 14.04+20150804
setvar ug		18.04+20180423 18.04+20180423
setvar uk		18.04+20180423 18.04+20180423
setvar ur-PK		14.04+20150804 14.04+20150804 ur
setvar uz		16.04+20160214 16.04+20160214
setvar uz-Cyrl		16.04+20160214 16.04+20160214 uz
setvar ve		14.04+20150804 14.04+20150804
setvar vi		18.04+20180423 18.04+20180423
setvar wa		14.04+20150804 14.04+20150804
setvar xh		17.10+20171012 17.10+20171012
setvar zh-CN		18.04+20180423 18.04+20180423 zh-hans
setvar zh-HK		18.04+20180423 18.04+20180423 zh-hant
setvar zh-TW		18.04+20180423 18.04+20180423 zh-hant
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
	[[ -z ${tag} ]] && tag=${use_flag}
	eval "ver=\${$use_flag[0]}"
	eval "ver_gnome=\${$use_flag[1]}"
	compress="xz"
	[[ ${ver//[!0-9]} -lt 161000000000 ]] \
		&& compress="gz"
	SRC_URI+=" l10n_${use_flag//_/-}? (
		${UURL}/language-pack-${tag}-base/language-pack-${tag}-base_${ver}.tar.${compress}
		${UURL}/language-pack-gnome-${tag}-base/language-pack-gnome-${tag}-base_${ver_gnome}.tar.${compress} )"
done

S="${WORKDIR}"

src_unpack() {
	[[ -n ${A} ]] \
		&& unpack ${A} \
		|| die "At least one L10N USE_EXPAND flag must be set!"
}

src_install() {
	# langselector panel msgids
	local -a msgids=(
		"Language Support"
		"Configure multiple and native language support on your system"
		"Login _Screen"
		"_Language"
		"_Formats"
		"Login settings are used by all users when logging into the system"
		"Your session needs to be restarted for changes to take effect"
		"Restart Now"
		"Formats"
		"_Done"
		"_Cancel"
		"Preview"
		"Dates"
		"Times"
		"Dates & Times"
		"Numbers"
		"Measurement"
		"Paper"
		"measurement format"
		"More…"
		"No languages found"
		"No regions found"
	)

	local \
		pofile msgid gcc_src ls_src \
		ucc_po="unity-control-center.po" \
		gcc_po="gnome-control-center-2.0.po" \
		ls_po="language-selector.po"

	# Remove all translations except those we need
	find "${S}" -type f \
		! -name ${gcc_po} \
		! -name ${ls_po} \
		! -name 'activity-log-manager.po' \
		! -name 'account-plugins.po' \
		! -name 'compiz.po' \
		! -name 'ccsm.po' \
		! -name 'credentials-control-center.po' \
		! -name 'hud.po' \
		! -name 'indicator-*' \
		! -name 'libdbusmenu.po' \
		! -name 'onboard.po' \
		! -name 'signon-ui.po' \
		! -name 'ubuntu-help.po' \
		! -name 'unity*' \
		! -name 'ureadahead.po' \
		! -name 'webbrowser-app.po' \
			-delete || die
	find "${S}" -mindepth 1 -type d -empty -delete || die

	for pofile in $( \
		find "${S}" -type f -name "*.po" \
			! -name "${gcc_po}" \
			! -name "${ls_po}" \
	); do
		# Add translations for langselector panel
		if [[ ${pofile##*/} == ${ucc_po} ]]; then
			gcc_src=${pofile/${ucc_po}/${gcc_po}}
			ls_src=${pofile/${ucc_po}/${ls_po}}
			ls_src=${ls_src/gnome-}
			for msgid in "${msgids[@]}"; do
				if ! grep -q "^\(msgid\|msgctxt\)\s\"${msgid}\"$" "${pofile}"; then
					echo "$(awk "/^(msgid|msgctxt)\s\"${msgid}\"\$/ { p = 1 } p { print } /^\$/ { p = 0 }" "${gcc_src}" "${ls_src}" 2>/dev/null)" \
						>> "${pofile}"
				fi
			done
			rm "${gcc_src}" "${ls_src}" 2>/dev/null
		fi

		msgfmt -o "${pofile%.po}.mo" "${pofile}"
		rm "${pofile}"
	done
	insinto /usr/share/locale
	doins -r "${S}"/language-pack-*-base/data/*
}
