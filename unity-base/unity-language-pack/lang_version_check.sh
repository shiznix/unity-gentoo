#!/bin/bash

version_check() {
	# get upstream version:
	upstream_ver=$(grep -A4 "Package: language-pack-${tag}-base" /tmp/Sources-main-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g')
	upstream_ver_gnome=$(grep -A4 "Package: language-pack-gnome-${tag}-base" /tmp/Sources-main-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g')

	# upstream version not found:
	if [[ -z ${upstream_ver} && -z ${upstream_ver_gnome} ]]; then
		# don't show when changes or bump given:
		[[ -n ${changes} || -n ${bump} ]] \
			&& return

		echo
		echo "${COLOR_CYAN}${lang}${COLOR_NORM}"
		if [[ -z ${local_ver} && -z ${local_ver_gnome} ]]; then
			if [[ ${tag} == *"_"* ]]; then
				echo "  ${COLOR_PURPLE}... language flag is not supported or manual"
				echo "  check is required because of its specific name,"
				echo "  files can be included in package with ${COLOR_CYAN}${tag%%_*}${COLOR_PURPLE} tag${COLOR_NORM}"
			else
				echo "  ${COLOR_PURPLE}... language flag is not supported${COLOR_NORM}"
		fi
		else
			echo "  Local version:    language-pack-${tag}-base-${COLOR_RED}${local_ver}${COLOR_NORM}"
			echo "  Local version:    language-pack-gnome-${tag}-base-${COLOR_RED}${local_ver_gnome}${COLOR_NORM}"
			echo "  ${COLOR_PURPLE}... support for this language flag has ended${COLOR_NORM}"
		fi
		return
	fi

	# version up-to-date:
	if [[ ${local_ver} == ${upstream_ver} && ${local_ver_gnome} == ${upstream_ver_gnome} ]]; then
		# don't show when changes or bump given:
		[[ -n ${changes} || -n ${bump} ]] \
			&& return

		echo
		echo "${COLOR_CYAN}${lang}${COLOR_NORM}"
		echo "  ${COLOR_GREEN}Local version:    language-pack-${tag}-base-${local_ver}"
		echo "  Upstream version: language-pack-${tag}-base-${upstream_ver}"
		echo "  Local version:    language-pack-gnome-${tag}-base-${local_ver_gnome}"
		echo "  Upstream version: language-pack-gnome-${tag}-base-${upstream_ver_gnome}${COLOR_NORM}"
	else # version update available:
		echo
		echo "${COLOR_CYAN}${lang}${COLOR_NORM}"
		if [[ ${local_ver} != ${upstream_ver} ]]; then
			echo "  Local version:    language-pack-${tag}-base-${COLOR_RED}${local_ver}${COLOR_NORM}"
			echo "  Upstream version: language-pack-${tag}-base-${COLOR_BLUE}${upstream_ver}${COLOR_NORM}"
		else
			echo "  Local version:    language-pack-${tag}-base-${local_ver}"
			echo "  Upstream version: language-pack-${tag}-base-${upstream_ver}"
		fi

		if [[ ${local_ver_gnome} != ${upstream_ver_gnome} ]]; then
			echo "  Local version:    language-pack-gnome-${tag}-base-${COLOR_RED}${local_ver_gnome}${COLOR_NORM}"
			echo "  Upstream version: language-pack-gnome-${tag}-base-${COLOR_BLUE}${upstream_ver_gnome}${COLOR_NORM}"
		else
			echo "  Local version:    language-pack-gnome-${tag}-base-${local_ver_gnome}"
			echo "  Upstream version: language-pack-gnome-${tag}-base-${upstream_ver_gnome}"
		fi
	fi

	# process when changes or bump given:
	if [[ ( -n ${bump} || -n ${changes} ) && -n ${local_ver} && -n ${upstream_ver} && ( ${local_ver} != ${upstream_ver} || ${local_ver_gnome} != ${upstream_ver_gnome} ) ]]; then
		changed_tags+="${tag} "
		if [[ -n ${bump} ]]; then
			sed -e "s/\(^setvar ${use_flag//_/-}.*\)${local_ver}.${local_ver_gnome}/\1${upstream_ver} ${upstream_ver_gnome}/" -i "${ebuild}"
			echo "  ${COLOR_YELLOW}... local version bumped${COLOR_NORM}"
		fi
	fi
}

# process positional parameters:
while (( "$#" )); do
	case $1 in
		--bump)
			[[ -z ${changes} ]] \
				&& bump=1
			shift;;
		--changes)
			[[ -z ${bump} ]] \
				&& changes=1
			shift;;
		--help)
			echo "Usage: lang_version_check.sh [<ebuild filename>] [--changes] [--bump]"
			exit;;
		*)
			ebuilds+=( "$1" ) && shift;;
	esac
done

# create cosmetic variables:
for (( i = 0; i < 67; i++ )); do
	SEPARATOR+="-"
done
COLOR_NORM=$(tput sgr0)
COLOR_BOLD=$(tput bold)
COLOR_RED=$(tput bold; tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput bold; tput setaf 3)
COLOR_BLUE=$(tput bold; tput setaf 4)
COLOR_PURPLE=$(tput bold; tput setaf 5)
COLOR_CYAN=$(tput setaf 6)

# process ebuilds:
[[ -z ${ebuilds[@]} ]] \
	&& ebuilds=( *.ebuild )
for ebuild in "${ebuilds[@]}"; do
	# read all available languages from portage:
	IFS=$'\n' readarray -t L10N < /usr/portage/profiles/desc/l10n.desc

	# ebuild not found:
	if [[ ! -f ${ebuild} ]]; then
		echo "${ebuild}: file not found"
		continue
	fi

	source "$(pwd)/${ebuild}" 2>/dev/null
	# URELEASE not found:
	if [[ -z ${URELEASE} ]]; then
		echo "URELEASE: variable not found"
		continue
	fi

	echo
	echo "Processing ${COLOR_BOLD}${ebuild}${COLOR_NORM} ..."

	# download Ubuntu sources if not available:
	if [[ ! -f /tmp/Sources-main-${URELEASE} ]]; then
		wget http://archive.ubuntu.com/ubuntu/dists/${URELEASE}/main/source/Sources.gz -O /tmp/Sources-main-${URELEASE}.gz 2>/dev/null
		gunzip /tmp/Sources-main-${URELEASE}.gz 2>/dev/null
		if [[ ! -f /tmp/Sources-main-${URELEASE} ]]; then
			echo "http://archive.ubuntu.com/ubuntu/dists/${URELEASE}/main/source/Sources.gz: link not found"
			continue
		fi
	fi

	# process all languages:
	for lang in "${L10N[@]}"; do
		if [[ ${lang} == [a-z]* ]]; then
			use_flag="${lang% - [a-z,A-Z]*}"
			use_flag="${use_flag//-/_}"

			eval "tag=\${$use_flag[2]}"
			[[ -z ${tag} ]] \
				&& tag="${use_flag}"

			eval "local_ver=\${$use_flag[0]}"
			eval "local_ver_gnome=\${$use_flag[1]}"

			version_check
			showhints=1
		fi
	done

	# create recap variables:
	ebuild_name+=( "${ebuild}" )
	release+=( "${URELEASE}" )
	all_tags+=( "${changed_tags% }" )
	changed_tags=
done

# show changes or bump recap:
if [[ ( -n ${bump} || -n ${changes} ) && -n ${showhints} ]]; then
	showhints=
	echo
	echo "${SEPARATOR}"
	for (( i = 0; i < ${#ebuild_name[@]}; i++ )); do
		echo
		echo "File name:      ${ebuild_name[${i}]}"
		echo "Ubuntu release: ${release[${i}]}"
		if [[ -n ${all_tags[i]} ]]; then
			showhints=1
			[[ -n ${changes} ]] \
				&& echo "Changed tags:   ${COLOR_BLUE}${all_tags[i]}${COLOR_NORM}" \
				|| echo "Bumped tags:    ${COLOR_YELLOW}${all_tags[i]}${COLOR_NORM}"
		else
			[[ -n ${changes} ]] \
				&& echo "${COLOR_BOLD}No changes${COLOR_NORM}" \
				|| echo "${COLOR_BOLD}No bumps${COLOR_NORM}"
		fi
	done
fi

# show color hints:
if [[ -n ${showhints} ]]; then
	echo
	echo "${SEPARATOR}"
	echo
	echo "${COLOR_CYAN}[ L10N flag - Language ]${COLOR_NORM}"
	[[ -z ${bump} && -z ${changes} ]] \
		&& echo "${COLOR_GREEN}[ Up to date ]${COLOR_NORM}"
	echo "${COLOR_RED}[ Old version ]${COLOR_NORM}"
	echo "${COLOR_BLUE}[ New version ]${COLOR_NORM}"
	[[ -z ${bump} && -z ${changes} ]] \
		&& 	echo "${COLOR_PURPLE}[ Notes ]${COLOR_NORM}"
	[[ -n ${bump} ]] \
		&& echo "${COLOR_YELLOW}[ Version bump ]${COLOR_NORM}"
fi

echo
