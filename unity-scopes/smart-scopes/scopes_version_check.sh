#!/bin/sh

version_check() {
	if [ ! -f /tmp/Sources-${URELEASE} ]; then
		echo
		wget http://archive.ubuntu.com/ubuntu/dists/${URELEASE}/main/source/Sources.bz2 -O /tmp/Sources-${URELEASE}.bz2
		bunzip2 /tmp/Sources-${URELEASE}.bz2
	fi
	upstream_version=`grep -A2 "Package: unity-scope-${_name}$" /tmp/Sources-${URELEASE} | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
 
	if [ -z "${upstream_version}" ]; then
		upstream_version=`wget -q "http://packages.ubuntu.com/${URELEASE}/source/unity-scope-${_name}" -O - | sed -n "s/.*${_name} (\(.*\)).*/\1/p" | sed "s/).*//g" | sed 's/1://g'`
		[ -z ${upstream_version} ] && upstream_version=`wget -q "http://packages.ubuntu.com/${URELEASE}/unity-scope-${_name}" -O - | sed -n "s/.*${_name} (\(.*\)).*/\1/p" | sed "s/).*//g" | sed 's/1://g'`
	fi

	if [ "${local_version}" = "${upstream_version}" ]; then
		echo
		echo "  Local version: unity-scope-${_name}-${local_version}  ::  ${URELEASE}"
		echo "  Upstream version: unity-scope-${_name}-${upstream_version}  ::  ${URELEASE}"
	else
		echo
		echo "  Local version: unity-scope-${_name}-${local_version}  ::  ${URELEASE}"
		echo -e "  Upstream version: \033[5m\033[1;31munity-scope-${_name}-${upstream_version}\033[0m  ::  ${URELEASE}"
	fi

	if [ "${bump}" = "1" ]; then
		if [ -n "${local_version}" ] && [ -n "${upstream_version}" ]; then
			if [ "${local_version}" != "${upstream_version}" ]; then
				local_release=`echo ${local_version} | sed 's/.*\([0-9]ubuntu[0-9]\)/\1/'`
				local_version=`echo ${local_version} | sed 's/-[0-9]ubuntu[0-9]//'`
				upstream_release=`echo ${upstream_version} | sed 's/.*\([0-9]ubuntu[0-9]\)/\1/'`
				upstream_version=`echo ${upstream_version} | sed 's/-[0-9]ubuntu[0-9]//'`
				sed -e "s/\(${_name}    .*\).*${local_version}/\1${upstream_version}/" \
					-e "s/\(${_name}.*${local_version}      .*\).*${_rel}/\1${upstream_release}/" \
						-i "${ebuild}"
				echo "  Bumped local version to ${upstream_version}"
			fi
		fi
	fi
}

while (( "$#" )); do
	case $1 in
		--bump)
			bump=1 && shift;;
		*)
			ebuild="$1" && shift;;
	esac
done

if [ "${bump}" = "1" ]; then
        source $(pwd)/${ebuild} 2> /dev/null
        for i in ${packages[@]}; do
                eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
                local_version="${_ver}-${_rel}"
                version_check
        done
else
	for ebuild in *.ebuild; do
		echo "Checking ${ebuild}"
		source $(pwd)/${ebuild} 2> /dev/null
		for i in ${packages[@]}; do
			unset _rel
			eval "_name=${i}; _ver=\${_ver_${i//-/_}}; _rel=\${_rel_${i//-/_}}"
			if [ ! -z "${_rel}" ]; then
				local_version="${_ver}-${_rel}"
			else
				local_version="${_ver}"
			fi
			version_check
		done
	done
fi
