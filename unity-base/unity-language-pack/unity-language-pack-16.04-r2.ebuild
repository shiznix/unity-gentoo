# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="xenial"
inherit ubuntu-versionator

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"

UURL="mirror://unity/pool/main/l"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="sys-devel/gettext
	!!<app-accessibility/onboard-1.2.0_p0_p05-r1
	!!<app-backup/deja-dup-34.2_p0_p01-r2
	!!<gnome-base/nautilus-3.18.4_p0_p05-r1
	!!<gnome-extra/nm-applet-1.2.0_p0_p00160404-r1
	!!<gnome-extra/polkit-gnome-0.105_p2_p02-r1
	!!<media-gfx/shotwell-0.22.0_p0_p01_p20160108-r1
	!!<media-sound/pulseaudio-8.0_p0_p3-r1
	!!<net-libs/gnome-online-accounts-3.18.3_p1_p02-r1
	!!<www-client/webbrowser-app-0.23_p0_p01_p20160413-r1
	!!<x11-libs/gtk+-2.24.30_p1_p01-r1:2
	!!<x11-libs/gtk+-3.18.9_p1_p0301-r1:3
	!!<x11-misc/lightdm-1.18.2_p0_p02-r1"

# Pass array of standard language tags function:
set_arr() {
	for tag in "${!1}"; do
		eval "${tag/-/_}=(\${!2})"
	done
}

# Pass specific language tag function:
set_spec() {
	eval "${1/-/_}=(\${!2} ${3})"
}

# tag_[code name]=(
#	[language tags])
tag_precise=(
	la)
# ver_[code name]=(
#	[version of language-pack-base]
#	[version of language-pack-gnome-base])
# NOTE: Versions are usually the same
ver_precise=(
	12.04+20130128
	12.04+20130128)

tag_trusty=(
	csb fil fo fy hy ks ky lb lo mi nso om rw sa sd se st sw tk tl
	ts tt ve wa zu)
ver_trusty=(
	14.04+20150804
	14.04+20150804)

tag_utopic=(
	bo)
ver_utopic=(
	14.10+20140909
	14.10+20140909)

tag_xenial_1=(
	mn uz)
ver_xenial_1=(
	16.04+20160214
	16.04+20160214)

tag_xenial_2=(
	af am an ar as ast az be bg bn br bs ca cs cy da de dz el en eo
	es et eu fa fi fr ga gd gl gu he hi hr hu ia id is it ja ka kk
	km kn ko ku lt lv mai mk ml mr ms my nb nds ne nl nn oc or pa pl
	pt ro ru si sk sl sq sr sv ta te tg th tr ug uk vi xh)
ver_xenial_2=(
	16.04+20160627
	16.04+20160627)

# [func]	[array of tags]		[array of versions]
set_arr		"tag_precise[@]"	"ver_precise[@]"
set_arr		"tag_trusty[@]"		"ver_trusty[@]"
set_arr		"tag_utopic[@]"		"ver_utopic[@]"
set_arr		"tag_xenial_1[@]"	"ver_xenial_1[@]"
set_arr		"tag_xenial_2[@]"	"ver_xenial_2[@]"

# CAUTION: If language tag differs from Ubuntu tag, DON'T include it
#  in array of tags and use set_spec() function instead, see below:
# [func]	[specific tag]	[array of versions]	[ubuntu tag]
set_spec	en-GB		"ver_xenial_2[@]"	en
set_spec	en-US		"ver_xenial_2[@]"	en
set_spec	pt-BR		"ver_xenial_2[@]"	pt
set_spec	sr-Latn		"ver_xenial_2[@]"	sr
set_spec	ur-PK		"ver_trusty[@]"		ur
set_spec	zh-CN		"ver_xenial_2[@]"	zh-hans
set_spec	zh-HK		"ver_xenial_2[@]"	zh-hant
set_spec	zh-TW		"ver_xenial_2[@]"	zh-hant

# CAUTION: Be sure to enable *all available* L10N USE_EXPAND flags
#  in /etc/make.conf when creating Manifest

# Only valid IETF language tags that are listed in
#  /usr/portage/profiles/desc/l10n.desc are supported:
IUSE_L10N="af am an ar as ast az be bg bn bo br bs ca cs csb cy da de dz
el en en-GB en-US eo es et eu fa fi fil fo fr fy ga gd gl gu he hi hr hu
hy ia id is it ja ka kk km kn ko ks ku ky la lb lo lt lv mai mi mk ml mn
mr ms my nb nds ne nl nn nso oc om or pa pl pt pt-BR ro ru rw sa sd se
si sk sl sq sr sr-Latn st sv sw ta te tg th tk tl tr ts tt ug uk ur-PK
uz ve vi wa xh zh-CN zh-HK zh-TW zu"

# IUSE and SRC_URI generator:
for use_flag in ${IUSE_L10N}; do
	IUSE+=" l10n_${use_flag}"
	if has ${use_flag} ${L10N}; then
		use_flag=${use_flag/-/_}
		eval "tag=\${$use_flag[2]}"
		if [ -z ${tag} ]; then
			tag=${use_flag}
		fi
		eval "ver=\${$use_flag[0]}"
		eval "ver_gnome=\${$use_flag[1]}"
		SRC_URI_array+=( "l10n_${use_flag/_/-}?" \(
			${UURL}/language-pack-${tag}-base/language-pack-${tag}-base_${ver}.tar.gz
			${UURL}/language-pack-gnome-${tag}-base/language-pack-gnome-${tag}-base_${ver_gnome}.tar.gz \) )
	fi
done
SRC_URI="${SRC_URI_array[@]}"

S="${WORKDIR}"

src_prepare() {
	for use_flag in ${L10N}; do
		if has ${use_flag} ${IUSE_L10N}; then
			tags+=" ${use_flag}"
		fi
	done
	if [ -z ${tags} ]; then
		die "At least one L10N USE_EXPAND flag must be set!"
	fi
	ubuntu-versionator_src_prepare
}

src_install() {
	for use_flag in ${L10N}; do
		if has ${use_flag} ${IUSE_L10N}; then
			# Remove all translations except those we need
			find "${S}" \
				-type f \! -name 'activity-log-manager.po' \
				-type f \! -name 'account-plugins.po' \
				-type f \! -name 'compiz.po' \
				-type f \! -name 'ccsm.po' \
				-type f \! -name 'credentials-control-center.po' \
				-type f \! -name 'deja-dup.po' \
				-type f \! -name 'gnome-online-accounts.po' \
				-type f \! -name 'gtk20.po' \
				-type f \! -name 'gtk20-properties.po' \
				-type f \! -name 'gtk30.po' \
				-type f \! -name 'gtk30-properties.po' \
				-type f \! -name 'hud.po' \
				-type f \! -name 'indicator-*' \
				-type f \! -name 'language-selector.po' \
				-type f \! -name 'libdbusmenu.po' \
				-type f \! -name 'lightdm.po' \
				-type f \! -name 'nautilus.po' \
				-type f \! -name 'nm-applet.po' \
				-type f \! -name 'onboard.po' \
				-type f \! -name 'polkit-gnome-1.po' \
				-type f \! -name 'pulseaudio.po' \
				-type f \! -name 'rhythmbox.po' \
				-type f \! -name 'shotwell.po' \
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
		fi
	done
}
