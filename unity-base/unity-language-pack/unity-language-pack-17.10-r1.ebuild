# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="artful"
inherit ubuntu-versionator

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"

UURL="mirror://unity/pool/main/l"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="sys-devel/gettext"

setvar() {
	eval "${1//-/_}=(${2} ${3} ${4})"
}

#[fnc] [L10N]		[pack]         [pack-gnome]   [ubuntu tag]
setvar af		17.10+20171012 17.10+20171012
setvar am		17.10+20171012 17.10+20171012
setvar an		17.10+20171012 17.10+20171012
setvar ar		17.10+20171012 17.10+20171012
setvar as		17.10+20171012 17.10+20171012
setvar ast		17.10+20171012 17.10+20171012
setvar az		17.10+20171012 17.10+20171012
setvar be		17.10+20171012 17.10+20171012
setvar bg		17.10+20171012 17.10+20171012
setvar bn		17.10+20171012 17.10+20171012
setvar bo		14.10+20140909 14.10+20140909
setvar br		17.10+20171012 17.10+20171012
setvar bs		17.10+20171012 17.10+20171012
setvar ca		17.10+20171012 17.10+20171012
setvar ca-valencia	17.10+20171012 17.10+20171012 ca
setvar cs		17.10+20171012 17.10+20171012
setvar csb		14.04+20150804 14.04+20150804
setvar cy		17.10+20171012 17.10+20171012
setvar da		17.10+20171012 17.10+20171012
setvar de		17.10+20171012 17.10+20171012
setvar dz		17.10+20171012 17.10+20171012
setvar el		17.10+20171012 17.10+20171012
setvar en		17.10+20171012 17.10+20171012
setvar en-GB		17.10+20171012 17.10+20171012 en
setvar eo		17.10+20171012 17.10+20171012
setvar es		17.10+20171012 17.10+20171012
setvar et		17.10+20171012 17.10+20171012
setvar eu		17.10+20171012 17.10+20171012
setvar fa		17.10+20171012 17.10+20171012
setvar fi		17.10+20171012 17.10+20171012
setvar fil		14.04+20150804 14.04+20150804
setvar fo		14.04+20150804 14.04+20150804
setvar fr		17.10+20171012 17.10+20171012
setvar fy		14.04+20150804 14.04+20150804
setvar ga		17.10+20171012 17.10+20171012
setvar gd		17.10+20171012 17.10+20171012
setvar gl		17.10+20171012 17.10+20171012
setvar gu		17.10+20171012 17.10+20171012
setvar he		17.10+20171012 17.10+20171012
setvar hi		17.10+20171012 17.10+20171012
setvar hr		17.10+20171012 17.10+20171012
setvar hu		17.10+20171012 17.10+20171012
setvar hy		14.04+20150804 14.04+20150804
setvar ia		17.10+20171012 17.10+20171012
setvar id		17.10+20171012 17.10+20171012
setvar is		17.10+20171012 17.10+20171012
setvar it		17.10+20171012 17.10+20171012
setvar ja		17.10+20171012 17.10+20171012
setvar ka		17.10+20171012 17.10+20171012
setvar kk		17.10+20171012 17.10+20171012
setvar km		17.10+20171012 17.10+20171012
setvar kn		17.10+20171012 17.10+20171012
setvar ko		17.10+20171012 17.10+20171012
setvar ks		14.04+20150804 14.04+20150804
setvar ku		17.10+20171012 17.10+20171012
setvar ky		14.04+20150804 14.04+20150804
setvar la		12.04+20130128 12.04+20130128
setvar lb		14.04+20150804 14.04+20150804
setvar lo		14.04+20150804 14.04+20150804
setvar lt		17.10+20171012 17.10+20171012
setvar lv		17.10+20171012 17.10+20171012
setvar mai		17.10+20171012 17.10+20171012
setvar mi		14.04+20150804 14.04+20150804
setvar mk		17.10+20171012 17.10+20171012
setvar ml		17.10+20171012 17.10+20171012
setvar mn		16.04+20160214 16.04+20160214
setvar mr		17.10+20171012 17.10+20171012
setvar ms		17.10+20171012 17.10+20171012
setvar my		17.10+20171012 17.10+20171012
setvar nb		17.10+20171012 17.10+20171012
setvar nds		17.10+20171012 17.10+20171012
setvar ne		17.10+20171012 17.10+20171012
setvar nl		17.10+20171012 17.10+20171012
setvar nn		17.10+20171012 17.10+20171012
setvar nso		14.04+20150804 14.04+20150804
setvar oc		17.10+20171012 17.10+20171012
setvar om		14.04+20150804 14.04+20150804
setvar or		17.10+20171012 17.10+20171012
setvar pa		17.10+20171012 17.10+20171012
setvar pl		17.10+20171012 17.10+20171012
setvar pt		17.10+20171012 17.10+20171012
setvar pt-BR		17.10+20171012 17.10+20171012 pt
setvar ro		17.10+20171012 17.10+20171012
setvar ru		17.10+20171012 17.10+20171012
setvar rw		14.04+20150804 14.04+20150804
setvar sa		14.04+20150804 14.04+20150804
setvar sd		14.04+20150804 14.04+20150804
setvar se		14.04+20150804 14.04+20150804
setvar si		17.10+20171012 17.10+20171012
setvar sk		17.10+20171012 17.10+20171012
setvar sl		17.10+20171012 17.10+20171012
setvar sq		17.10+20171012 17.10+20171012
setvar sr		17.10+20171012 17.10+20171012
setvar sr-Latn		17.10+20171012 17.10+20171012 sr
setvar st		14.04+20150804 14.04+20150804
setvar sv		17.10+20171012 17.10+20171012
setvar sw		14.04+20150804 14.04+20150804
setvar ta		17.10+20171012 17.10+20171012
setvar te		17.10+20171012 17.10+20171012
setvar tg		17.10+20171012 17.10+20171012
setvar th		17.10+20171012 17.10+20171012
setvar tk		14.04+20150804 14.04+20150804
setvar tl		14.04+20150804 14.04+20150804
setvar tr		17.10+20171012 17.10+20171012
setvar ts		14.04+20150804 14.04+20150804
setvar tt		14.04+20150804 14.04+20150804
setvar ug		17.10+20171012 17.10+20171012
setvar uk		17.10+20171012 17.10+20171012
setvar ur-PK		14.04+20150804 14.04+20150804 ur
setvar uz		16.04+20160214 16.04+20160214
setvar uz-Cyrl		16.04+20160214 16.04+20160214 uz
setvar ve		14.04+20150804 14.04+20150804
setvar vi		17.10+20171012 17.10+20171012
setvar wa		14.04+20150804 14.04+20150804
setvar xh		17.10+20171012 17.10+20171012
setvar zh-CN		17.10+20171012 17.10+20171012 zh-hans
setvar zh-HK		17.10+20171012 17.10+20171012 zh-hant
setvar zh-TW		17.10+20171012 17.10+20171012 zh-hant
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
