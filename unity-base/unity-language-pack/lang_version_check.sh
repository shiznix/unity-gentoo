#!/bin/sh

version_check() {
	if [ ! -f /tmp/Sources-${URELEASE} ]; then
		echo
		wget http://archive.ubuntu.com/ubuntu/dists/${URELEASE}/main/source/Sources.bz2 -O /tmp/Sources-${URELEASE}.bz2
		bunzip2 /tmp/Sources-${URELEASE}.bz2
	fi
	upstream_version=`grep -A2 "Package: ${_name}$" /tmp/Sources-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`

	if [ "${local_version}" = "${upstream_version}" ]; then
		echo
		echo "  Local version: ${_name}-${local_version}  ::  ${URELEASE}"
		echo "  Upstream version: ${_name}-${upstream_version}  ::  ${URELEASE}"
	else
		echo
		echo "  Local version: ${_name}-${local_version}  ::  ${URELEASE}"
		echo -e "  Upstream version: \033[5m\033[1;31m${_name}-${upstream_version}\033[0m  ::  ${URELEASE}"
	fi
}

for ebuild in *.ebuild; do
echo "Checking ${ebuild}"
	source $(pwd)/${ebuild} 2> /dev/null
	for i in ${packages[@]}; do
		eval "_name=${i}; _ver=\${_ver_${i//-/_}}"
		local_version="${_ver}"
		version_check
	done
done
