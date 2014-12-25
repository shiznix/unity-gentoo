#!/bin/sh

version_check() {
	if [ ! -f /tmp/Sources-main-${URELEASE} ]; then
		echo
		wget http://archive.ubuntu.com/ubuntu/dists/${URELEASE}/main/source/Sources.bz2 -O /tmp/Sources-main-${URELEASE}.bz2
		bunzip2 /tmp/Sources-main-${URELEASE}.bz2
	fi
	upstream_version=`grep -A2 "Package: ${_name}$" /tmp/Sources-main-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`

	if [ "${local_version}" = "${upstream_version}" ]; then
		[ -n "${CHANGES}" ] && return
		echo
		echo "  Local version: ${_name}-${local_version}  ::  ${URELEASE}"
		echo "  Upstream version: ${_name}-${upstream_version}  ::  ${URELEASE}"
	else
		echo
		echo "  Local version: ${_name}-${local_version}  ::  ${URELEASE}"
		echo -e "  Upstream version: \033[1;31m${_name}-${upstream_version}\033[0m  ::  ${URELEASE}"
	fi

	if [ "${bump}" = "1" ]; then
		if [ -n "${local_version}" ] && [ -n "${upstream_version}" ]; then
			if [ "${local_version}" != "${upstream_version}" ]; then
				sed -e "s/\(${_name}	.*\).*${local_version}/\1${upstream_version}/" -i "${ebuild}"
				echo "  Bumped local version to ${upstream_version}"
			fi
		fi
	fi
}

while (( "$#" )); do
	case $1 in
		--bump)
			bump=1 && shift;;
		--changes)
			CHANGES=1 && shift;;
		*)
			ebuild="$1" && shift;;
	esac
done

if [ "${bump}" = "1" ]; then
	source $(pwd)/${ebuild} 2> /dev/null
	for i in ${packages[@]}; do
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}"
		local_version="${_ver}"
		version_check
	done
	echo -e "\n Versions bumped in ${ebuild}, don't forget to first uninstall unity-base/unity-language-pack, then enable *all* LINGUAS in make.conf before creating Manifest digests"
else
	for ebuild in *.ebuild; do
		echo -e "\nChecking ${ebuild}"
		unset packages
		source $(pwd)/${ebuild} 2> /dev/null
		for i in ${packages[@]}; do
			eval "_name=${i}; _ver=\${_ver_${i//-/_}}"
			local_version="${_ver}"
			version_check
		done
	done
fi
