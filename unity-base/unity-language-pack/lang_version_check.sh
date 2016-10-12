#!/bin/sh

version_check() {
	if [ ! -f /tmp/Sources-main-${URELEASE} ]; then
		wget http://archive.ubuntu.com/ubuntu/dists/${URELEASE}/main/source/Sources.gz -O /tmp/Sources-main-${URELEASE}.gz
		gunzip /tmp/Sources-main-${URELEASE}.gz
	fi
	upstream_ver=`grep -A2 "Package: language-pack-${tag}-base" /tmp/Sources-main-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
	upstream_ver_gnome=`grep -A2 "Package: language-pack-gnome-${tag}-base" /tmp/Sources-main-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`

	if [ "${local_ver}" = "${upstream_ver}" -a "${local_ver_gnome}" = "${upstream_ver_gnome}" ] ; then

		[ "${changes}" ] && return

		echo -e "\n\033[0;36m${lang}\033[0m"
		[ "${tag}" = "${use_flag}" ] && if [ -z "${local_ver}" ]; then
			if [[ ${tag} == *"_"* ]]; then
				echo -e "\033[1;35m  ... language flag is not supported or manual"
				echo "  check is required because of its specific name,"
				echo -e "  files can be included in package using \033[0;36m${tag%%_*}\033[1;35m tag\033[0m"
			else
				echo -e "\033[1;35m  ... language flag is not supported\033[0m"
			fi
			continue;
		fi
		echo -e "  \033[0;32mLocal version:    language-pack-${tag}-base-${local_ver}"
		echo "  Upstream version: language-pack-${tag}-base-${upstream_ver}"
		echo "  Local version:    language-pack-gnome-${tag}-base-${local_ver_gnome}"
		echo -e "  Upstream version: language-pack-gnome-${tag}-base-${upstream_ver_gnome}\033[0m"
	else
		echo -e "\n\033[0;36m${lang}\033[0m"
		if [ "${local_ver}" != "${upstream_ver}" ]; then
			echo -e "  Local version:    language-pack-${tag}-base-\033[1;31m${local_ver}\033[0m"
			echo -e "  Upstream version: language-pack-${tag}-base-\033[1;34m${upstream_ver}\033[0m"
		else
			echo "  Local version:    language-pack-${tag}-base-${local_ver}"
			echo "  Upstream version: language-pack-${tag}-base-${upstream_ver}"
		fi
		if [ "${local_ver_gnome}" != "${upstream_ver_gnome}" ]; then
			echo -e "  Local version:    language-pack-gnome-${tag}-base-\033[1;31m${local_ver_gnome}\033[0m"
			echo -e "  Upstream version: language-gnome-pack-${tag}-base-\033[1;34m${upstream_ver_gnome}\033[0m"
			[ -z "${upstream_ver}" -a -z "${upstream_ver_gnome}" ] && \
				echo -e "\033[1;35m  ... seems support for this language flag has ended\033[0m"
		else
			echo "  Local version:    language-pack-gnome-${tag}-base-${local_ver_gnome}"
			echo "  Upstream version: language-pack-gnome-${tag}-base-${upstream_ver_gnome}"
		fi
	fi

	[ "${bump}" ] && [ -n "${local_ver}" -a -n "${upstream_ver}" ] && \
		if [ "${local_ver}" != "${upstream_ver}" -o "${local_ver_gnome}" != "${upstream_ver_gnome}" ]; then
			sed -e "s/\(${use_flag//_/-}.*\)${local_ver}.${local_ver_gnome}/\1${upstream_ver} ${upstream_ver_gnome}/g" -i "${ebuild}"
			echo -e "  \033[1;33m... local version bumped\033[0m"
			bumped_flags+=" ${use_flag//_/-}"
		fi
}

while (( "$#" )); do
	case $1 in
		--bump)
			bump=1 && shift;;
		--changes)
			changes=1 && shift;;
		*)
			ebuild="$1" && shift;;
	esac
done

for ebuild in *.ebuild; do
	IFS=$'\n' readarray -t L10N < /usr/portage/profiles/desc/l10n.desc
	source $(pwd)/${ebuild} 2> /dev/null
	echo -e "\n-----------------------------------------------------------------"
	echo -e "\nFile name:      \"${ebuild}\""
	echo "Ubuntu release: \"${URELEASE}\""
	echo "Checking ..."
	for lang in "${L10N[@]}"; do
		if [[ ${lang} == [a-z]* ]]; then
			use_flag=${lang% - [a-z,A-Z]*}
			use_flag=${use_flag//-/_}
			eval "tag=\${$use_flag[2]}"
			[ -z "${tag}" ] && tag=${use_flag}
			eval "local_ver=\${$use_flag[0]}"
			eval "local_ver_gnome=\${$use_flag[1]}"
			version_check
		fi
	done
	if [ -n "${bumped_flags}" ]; then
		ebuild_name+=( "${ebuild}" )
		release+=( "${URELEASE}" )
		bumped_all+=( "${bumped_flags}" )
		bumped_flags=""
	fi
done

# bump recap
if [ "${bump}" -a -n "${bumped_all}" ]; then
	let i=0
	echo -e "\n-----------------------------------------------------------------"
	for bumped in "${bumped_all[@]}"; do
		echo -e "\nFile name:      ${ebuild_name[$i]}"
		echo "Ubuntu release: ${release[$i]}"
		echo -e "\033[1;33mBumped flags:  ${bumped}\033[0m"
		let i+=1
	done
elif [ "${bump}" ]; then
	echo -e "\n-----------------------------------------------------------------"
	echo -e "\n\033[1;33mNone packages to bump\033[0m"
fi

# color hints
echo -e "\n-----------------------------------------------------------------"
echo -e "\n\033[0;36m[ L10N flag - Language ]\033[0m"
[ ! "${changes}" ] && echo -e "\033[0;32m[ Package is up to date ]\033[0m"
echo -e "\033[1;31m[ Old version of package ]\033[0m"
echo -e "\033[1;34m[ New version of package ]\033[0m"
echo -e "\033[1;35m[ Some notes ]\033[0m"
[ "${bump}" ] && echo -e "\033[1;33m[ Version bump ]\033[0m"
echo
