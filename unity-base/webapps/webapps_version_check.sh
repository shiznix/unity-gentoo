#!/bin/sh

version_check() {
	upstream_version=unity-webapps-`wget -q "http://packages.ubuntu.com/${URELEASE}/source/unity-webapps-${_name}" -O - | sed -n "s/.*${_name} (\(.*\)).*/${_name}-\1/p" | sed 's/1://g'`
	[ -z ${upstream_version} ] && upstream_version=unity-webapps-`wget -q "http://packages.ubuntu.com/${URELEASE}/unity-webapps-${_name}" -O - | sed -n "s/.*${_name} (\(.*\)).*/${_name} (\(.*\)).*/${_name}-\1/p" | sed 's/1://g'`
	if [ "${local_version}" = "${upstream_version}" ]; then
		echo
		echo "  Local version: ${local_version}  ::  ${URELEASE}"
		echo "  Upstream version: ${upstream_version}  ::  ${URELEASE}"
	else
		echo
		echo "  Local version: ${local_version}  ::  ${URELEASE}"
		echo -e "  Upstream version: \033[5m\033[1;31m${upstream_version}\033[0m  ::  ${URELEASE}"
	fi
}

for ebuild in $(grep packages *.ebuild | awk -F: '{print $1}' | uniq); do
echo "Checking ${ebuild}"
	source $(pwd)/${ebuild} 2> /dev/null
	for i in ${packages[@]}; do
		unset _rel
		eval "_name=${i}; _ver=\${_ver_${i/-/_}}; _rel=\${_rel_${i/-/_}}"
		if [ ! -z "${_rel}" ]; then
			local_version="unity-webapps-${_name}-${_ver}-${_rel}"
		else
			local_version="unity-webapps-${_name}-${_ver}"
		fi
		version_check
	done
done
