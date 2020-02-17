# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit ubuntu-versionator

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l"

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="sys-devel/gettext"

setvar() {
	eval "${1//-/_}=(${2} ${3} ${4})"
}

#[fnc] [L10N]		[pack]         [pack-gnome]   [ubuntu tag]
setvar af		18.10+20181011 18.10+20181011
setvar am		18.10+20181011 18.10+20181011
setvar an		18.10+20181011 18.10+20181011
setvar ar		18.10+20181011 18.10+20181011
setvar as		18.10+20181011 18.10+20181011
setvar ast		18.10+20181011 18.10+20181011
setvar az		17.10+20171012 17.10+20171012
setvar be		18.10+20181011 18.10+20181011
setvar bg		18.10+20181011 18.10+20181011
setvar bn		18.10+20181011 18.10+20181011
setvar bo		14.10+20140909 14.10+20140909
setvar br		18.10+20181011 18.10+20181011
setvar bs		18.10+20181011 18.10+20181011
setvar ca		18.10+20181011 18.10+20181011
setvar ca-valencia	18.10+20181011 18.10+20181011 ca
setvar cs		18.10+20181011 18.10+20181011
setvar csb		14.04+20150804 14.04+20150804
setvar cy		18.10+20181011 18.10+20181011
setvar da		18.10+20181011 18.10+20181011
setvar de		18.10+20181011 18.10+20181011
setvar dz		18.10+20181011 18.10+20181011
setvar el		18.10+20181011 18.10+20181011
setvar en		18.10+20181011 18.10+20181011
setvar en-GB		18.10+20181011 18.10+20181011 en
setvar eo		18.10+20181011 18.10+20181011
setvar es		18.10+20181011 18.10+20181011
setvar et		18.10+20181011 18.10+20181011
setvar eu		18.10+20181011 18.10+20181011
setvar fa		18.10+20181011 18.10+20181011
setvar fi		18.10+20181011 18.10+20181011
setvar fil		14.04+20150804 14.04+20150804
setvar fo		14.04+20150804 14.04+20150804
setvar fr		18.10+20181011 18.10+20181011
setvar fy		14.04+20150804 14.04+20150804
setvar ga		18.10+20181011 18.10+20181011
setvar gd		18.10+20181011 18.10+20181011
setvar gl		18.10+20181011 18.10+20181011
setvar gu		18.10+20181011 18.10+20181011
setvar he		18.10+20181011 18.10+20181011
setvar hi		18.10+20181011 18.10+20181011
setvar hr		18.10+20181011 18.10+20181011
setvar hu		18.10+20181011 18.10+20181011
setvar hy		14.04+20150804 14.04+20150804
setvar ia		18.10+20181011 18.10+20181011
setvar id		18.10+20181011 18.10+20181011
setvar is		18.10+20181011 18.10+20181011
setvar it		18.10+20181011 18.10+20181011
setvar ja		18.10+20181011 18.10+20181011
setvar ka		17.10+20171012 17.10+20171012
setvar kk		18.10+20181011 18.10+20181011
setvar km		18.10+20181011 18.10+20181011
setvar kn		18.10+20181011 18.10+20181011
setvar ko		18.10+20181011 18.10+20181011
setvar ks		14.04+20150804 14.04+20150804
setvar ku		18.10+20181011 18.10+20181011
setvar ky		14.04+20150804 14.04+20150804
setvar la		12.04+20130128 12.04+20130128
setvar lb		14.04+20150804 14.04+20150804
setvar lo		14.04+20150804 14.04+20150804
setvar lt		18.10+20181011 18.10+20181011
setvar lv		18.10+20181011 18.10+20181011
setvar mai		18.04+20180423 18.04+20180423
setvar mi		14.04+20150804 14.04+20150804
setvar mk		18.10+20181011 18.10+20181011
setvar ml		18.10+20181011 18.10+20181011
setvar mn		16.04+20160214 16.04+20160214
setvar mr		18.10+20181011 18.10+20181011
setvar ms		18.10+20181011 18.10+20181011
setvar my		18.10+20181011 18.10+20181011
setvar nb		18.10+20181011 18.10+20181011
setvar nds		17.10+20171012 17.10+20171012
setvar ne		18.10+20181011 18.10+20181011
setvar nl		18.10+20181011 18.10+20181011
setvar nn		18.10+20181011 18.10+20181011
setvar nso		14.04+20150804 14.04+20150804
setvar oc		18.10+20181011 18.10+20181011
setvar om		14.04+20150804 14.04+20150804
setvar or		18.10+20181011 18.10+20181011
setvar pa		18.10+20181011 18.10+20181011
setvar pl		18.10+20181011 18.10+20181011
setvar pt		18.10+20181011 18.10+20181011
setvar pt-BR		18.10+20181011 18.10+20181011 pt
setvar ro		18.10+20181011 18.10+20181011
setvar ru		18.10+20181011 18.10+20181011
setvar rw		14.04+20150804 14.04+20150804
setvar sa		14.04+20150804 14.04+20150804
setvar sd		14.04+20150804 14.04+20150804
setvar se		14.04+20150804 14.04+20150804
setvar si		18.10+20180731 18.10+20180731
setvar sk		18.10+20181011 18.10+20181011
setvar sl		18.10+20181011 18.10+20181011
setvar sq		18.10+20181011 18.10+20181011
setvar sr		18.10+20181011 18.10+20181011
setvar sr-Latn		18.10+20181011 18.10+20181011 sr
setvar st		14.04+20150804 14.04+20150804
setvar sv		18.10+20181011 18.10+20181011
setvar sw		14.04+20150804 14.04+20150804
setvar ta		18.10+20181011 18.10+20181011
setvar te		18.10+20181011 18.10+20181011
setvar tg		18.10+20181011 18.10+20181011
setvar th		18.10+20181011 18.10+20181011
setvar tk		14.04+20150804 14.04+20150804
setvar tl		14.04+20150804 14.04+20150804
setvar tr		18.10+20181011 18.10+20181011
setvar ts		14.04+20150804 14.04+20150804
setvar tt		14.04+20150804 14.04+20150804
setvar ug		18.10+20181011 18.10+20181011
setvar uk		18.10+20181011 18.10+20181011
setvar ur-PK		14.04+20150804 14.04+20150804 ur
setvar uz		16.04+20160214 16.04+20160214
setvar uz-Cyrl		16.04+20160214 16.04+20160214 uz
setvar ve		14.04+20150804 14.04+20150804
setvar vi		18.10+20181011 18.10+20181011
setvar wa		14.04+20150804 14.04+20150804
setvar xh		17.10+20171012 17.10+20171012
setvar zh-CN		18.10+20181011 18.10+20181011 zh-hans
setvar zh-HK		18.10+20181011 18.10+20181011 zh-hant
setvar zh-TW		18.10+20181011 18.10+20181011 zh-hant
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

REQUIRED_USE="|| ( ${IUSE} )"
IUSE="${IUSE/l10n_en/+l10n_en}"

S="${WORKDIR}"

_progress_counter=0
_progress_indicator() {
	local -a arr=( "|" "/" "-" "\\" )

	[[ ${_progress_counter} -eq 4 ]] && _progress_counter=0
	printf "\b\b %s" "${arr[${_progress_counter}]}"
	_progress_counter=$((_progress_counter + 1))
}

src_install() {
	# sharing panel msgids
	local -a sh_msgids=(
		"No networks selected for sharing"
		"service is enabled"
		"service is disabled"
		"service is enabled"
		"service is active"
		"Choose a Folder"
		"File Sharing allows you to share your Public folder with others on your "
		"When remote login is enabled, remote users can connect using the Secure "
		"Screen sharing allows remote users to view or control your screen by "
		"Copy"
		"Sharing"
		"_Computer Name"
		"_File Sharing"
		"_Screen Sharing"
		"_Media Sharing"
		"_Remote Login"
		"Some services are disabled because of no network access."
		"File Sharing"
		"_Require Password"
		"Remote Login"
		"Screen Sharing"
		"_Allow connections to control the screen"
		"_Password:"
		"_Show Password"
		"Access Options"
		"_New connections must ask for access"
		"_Require a password"
		"Media Sharing"
		"Share music, photos and videos over the network."
		"Folders"
		"Control what you want to share with others"
		"preferences-system-sharing"
		"share;sharing;ssh;host;name;remote;desktop;media;audio;video;pictures;photos;"
		"Networks"
		"Enable or disable remote login"
		"Authentication is required to enable or disable remote login"
	)

	# langselector panel msgids
	local -a ls_msgids=(
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

	# online-accounts desktop launcher msgids
	local -a oa_msgids=(
		"Online Accounts"
		"Connect to your online accounts and decide what to use them for"
	)

	# Unity help desktop launcher msgids
	local -a is_msgids=(
		"Unity Help"
		"Get help with Unity"
	)

	local \
		lng flg pofile msgid gcc_src ls_src ylp_src \
		ucc_po="unity-control-center.po" \
		gcc_po="gnome-control-center-2.0.po" \
		ls_po="language-selector.po" \
		is_po="indicator-session.po" \
		ylp_po="yelp.po" \
		newline=$'\n'

	# Remove all translations except those we need
	find "${S}" -type f \
		! -name ${gcc_po} \
		! -name ${ls_po} \
		! -name 'indicator-*' \
		! -name 'libdbusmenu.po' \
		! -name 'session-shortcuts.po' \
		! -name 'ubuntu-help.po' \
		! -name 'unity*' \
		! -name ${ylp_po} \
			-delete || die
	find "${S}" -mindepth 1 -type d -empty -delete || die

	# Add translations for session-shortcuts
	local -a langs=( "${S}"/language-pack-gnome-*-base/data/* )
	unpack "${FILESDIR}"/session-shortcuts-translations-artful.tar.xz

	printf "%s  " "Processing translation files"
	_progress_indicator

	for lng in "${langs[@]}"; do
		flg=${lng##*data/}
		cp "${S}"/po/"${flg}".po "${lng}"/LC_MESSAGES/session-shortcuts.po 2>/dev/null
	done
	rm -r "${S}"/po

	for pofile in $( \
		find "${S}" -type f -name "*.po" \
			! -name "${gcc_po}" \
			! -name "${ls_po}" \
			! -name "${ylp_po}" \
	); do
		if [[ ${pofile##*/} == ${ucc_po} ]]; then
			_progress_indicator

			# Add translations for sharing panel and online-accounts desktop launcher
			sed -i -e "/\"Sharing\"/,+1 d" "${pofile}" # remove old identical msgid
			gcc_src=${pofile/${ucc_po}/${gcc_po}}
			for msgid in "${sh_msgids[@]}" "${oa_msgids[@]}"; do
				if ! grep -q "^\(msgid\|msgctxt\)\s\"${msgid}\"$" "${pofile}"; then
					msgid="$(awk "/^(msgid\s|msgctxt\s|)\"${msgid}\"\$/ { p = 1 } p { print } /^\$/ { p = 0 }" "${gcc_src}" 2>/dev/null)"
					case ${msgid:0:1} in
						m)
							echo "${msgid}" >> "${pofile}"
							;;
						\")
							echo "msgid \"\"${newline}${msgid}" >> "${pofile}"
							;;
					esac
				fi
			done

			_progress_indicator

			# Add translations for langselector panel
			ls_src=${pofile/${ucc_po}/${ls_po}}
			ls_src=${ls_src/gnome-}
			for msgid in "${ls_msgids[@]}"; do
				if ! grep -q "^\(msgid\|msgctxt\)\s\"${msgid}\"$" "${pofile}"; then
					echo "$(awk "/^(msgid|msgctxt)\s\"${msgid}\"\$/ { p = 1 } p { print } /^\$/ { p = 0 }" "${gcc_src}" "${ls_src}" 2>/dev/null)" \
						>> "${pofile}"
				fi
			done
			rm "${gcc_src}" "${ls_src}" 2>/dev/null
		fi

		# Add translations for Unity help desktop launcher
		if [[ ${pofile##*/} == ${is_po} ]]; then
			_progress_indicator

			ylp_src=${pofile/${is_po}/${ylp_po}}
			for msgid in "${is_msgids[@]}"; do
				sed -i -e "s/GNOME/Unity/g" "${ylp_src}"
				if ! grep -q "^\(msgid\|msgctxt\)\s\"${msgid}\"$" "${pofile}"; then
					echo "$(awk "/^(msgid|msgctxt)\s\"${msgid}\"\$/ { p = 1 } p { print } /^\$/ { p = 0 }" "${ylp_src}" 2>/dev/null)" \
						>> "${pofile}"
				fi
			done
			rm "${ylp_src}" 2>/dev/null
		fi

		msgfmt -o "${pofile%.po}.mo" "${pofile}"
		rm "${pofile}"
	done

	insinto /usr/share/locale
	doins -r "${S}"/language-pack-*-base/data/*

	printf "\b\b%s\n" "... done!"
}
