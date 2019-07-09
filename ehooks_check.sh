#!/bin/bash

color_norm=$(tput sgr0)
color_bold=$(tput bold)
color_green=$(tput setaf 2)
color_blue=$(tput setaf 4)
color_cyan=$(tput setaf 6)

[[ -z $1 || $# -gt 1 ]] && set -- "-h"

case $1 in
	-c|--check)
		true
		;;
	-r|--reset)
		reset="yes"
		;;
	*)
		echo "${color_blue}${color_bold}NAME${color_norm}"
		echo "	ehooks - generate emerge command needed to apply ebuild hooks changes"
		echo
		echo "${color_blue}${color_bold}SYNOPSIS${color_norm}"
		echo "	${color_blue}${color_bold}ehooks${color_norm} [${color_cyan}OPTION${color_norm}]"
		echo
		echo "${color_blue}${color_bold}DESCRIPTION${color_norm}"
		echo "	/usr/bin/${color_blue}${color_bold}ehooks${color_norm} is a symlink to /var/lib/layman/unity-gentoo/ehooks_check.sh script. It looks for ebuild hooks changes and generates emerge command needed to apply the changes."
		echo
		echo "${color_blue}${color_bold}OPTIONS${color_norm}"
		echo "	${color_blue}${color_bold}-c${color_norm}, ${color_blue}${color_bold}--check${color_norm}"
		echo "		Generate emerge command when changes found."
		echo
		echo "	${color_blue}${color_bold}-r${color_norm}, ${color_blue}${color_bold}--reset${color_norm}"
		echo "		Set ebuild hooks changes as applied."
		echo
		exit 1
esac

count=0

## Progress indicator.
indicator() {
	local -a arr=( "|" "/" "-" "\\" )

	[[ ${count} -eq 4 ]] && count=0
	printf "\b\b %s" "${arr[${count}]}"
	count=$((count + 1))
}

printf "%s  " "Looking for ebuild hooks changes"

arr=( "nzero" )
wcard="*/*/"

while [[ -n ${arr[@]} ]]; do
	indicator

	prev_shopt=$(shopt -p nullglob)
	shopt -s nullglob
	arr=( "$(/usr/bin/portageq get_repo_path / unity-gentoo)"/profiles/releases/"$(readlink /etc/portage/make.profile | awk -F/ '{print $(NF-0)}')"/ehooks/${wcard} )
	${prev_shopt}

	dirs+=( "${arr[@]}" )
	wcard+="*/"
done

sys_db="/var/db/pkg/"

EHOOK_UPDATE=()

for x in "${dirs[@]}"; do
	indicator

	## Get CATEGORY/PACKAGE.
	m=${x%%/files/*}
	m=${m%/}
	m=${m#*/ehooks/}
	## Get package SLOT.
	[[ ${m} == *":"+([0-9,.]) ]] && slot="${m#*:}" || slot=""
	m="${m%:*}"

	## Search for installed package(s).
	prev_shopt=$(shopt -p nullglob)
	shopt -s nullglob
	pkg=( "${sys_db}${m}-"[0-9]*/ )
	${prev_shopt}

	for n in "${pkg[@]}"; do
		## Compare modification time.
		sys_date=$(date -r "${n}" "+%s")
		if [[ $(date -r "${x}" "+%s") -gt ${sys_date} ]]; then
			## Try another package if slots differ.
			[[ -z ${slot} ]] || fgrep -qsx "${slot}" "${n}/SLOT" || continue

			## Try another package if ehook_require USE-flag is not declared.
			req=$(egrep -hos -m 1 "ehook_require\s[A-Za-z0-9+_@-]+" "${x%%/files/*}/"*.ehook)
			[[ -z ${req} ]] || portageq has_version / unity-extra/ehooks["${req/ehook_require }"] || continue

			## Change ebuild hooks modification time when --reset given.
			[[ -n ${reset} ]] && touch -m -t $(date -d @"${sys_date}" +%Y%m%d%H%M.%S) "${x}" && continue

			## Get =CATEGORY/PACKAGE-VERSION.
			n="${n%/}"
			n="${n#${sys_db}}"
			EHOOK_UPDATE+=( "=${n}" )
		fi
	done
done

# Remove duplicates.
EHOOK_UPDATE=( $(printf "%s\n" "${EHOOK_UPDATE[@]}" | sort -u) )

printf "\b\b%s\n" "... done!"

ewarn() {
	local color_yellow=$(tput setaf 3)

	echo " ${color_yellow}${color_bold}*${color_norm} $*"
}

echo
if [[ -n ${EHOOK_UPDATE[@]} ]]; then
	ewarn "Rebuild packages affected by the ebuild hooks changes:"
	ewarn "emerge -1 ${EHOOK_UPDATE[@]}"
else
	echo " ${color_green}${color_bold}*${color_norm} No rebuild needed"
fi
echo
