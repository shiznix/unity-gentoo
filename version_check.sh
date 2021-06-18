#!/bin/bash

## Script to compare upstream versions of packages with versions in overlay tree ##
# If run without any arguments it recurses through the overlay tree and compares versions for all packages #
# Can be run on individual packages as 'version_check.sh category/package/package-version.ebuild' #
# Or 'cd category/package && ../../version_check.sh' #

local_to_upstream_packnames() {
	## Overlay package names to upstream package names mapping ##
	if [ -n "`echo "${packbasename}" | grep 'chromium-[0-9]'`" ]; then treepackname="${packname}"; packname="chromium-browser"
	elif [ -n "`echo "${packbasename}" | grep 'fixesproto'`" ]; then treepackname="${packname}"; packname="x11proto-fixes"
	elif [ -n "`echo "${packbasename}" | grep '^glib-[0-9]'`" ]; then treepackname="${packname}"; packname="glib2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gnome-desktop'`" ]; then treepackname="${packname}"; packname="gnome-desktop3"
	elif [ -n "`echo "${packbasename}" | grep 'gobject-introspection-common'`" ]; then treepackname="${packname}"; packname="gobject-introspection"
	elif [ -n "`echo "${packbasename}" | grep '^gtest'`" ]; then treepackname="${packname}"; packname="googletest"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-2'`" ]; then treepackname="${packname}"; packname="gtk+2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-3'`" ]; then treepackname="${packname}"; packname="gtk+3.0"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-classicmenu'`" ]; then treepackname="${packname}"; packname="classicmenu-indicator"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-evolution'`" ]; then treepackname="${packname}"; packname="evolution-indicator"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-psensor'`" ]; then treepackname="${packname}"; packname="psensor"
	elif [ -n "`echo "${packbasename}" | grep 'libXfixes'`" ]; then treepackname="${packname}"; packname="libxfixes"
	elif [ -n "`echo "${packbasename}" | grep 'libXi'`" ]; then treepackname="${packname}"; packname="libxi"
	elif [ -n "`echo "${packbasename}" | grep 'lttng-tools'`" ]; then treepackname="${packname}"; packname="ltt-control"
	elif [ -n "`echo "${packbasename}" | grep 'lttng-ust'`" ]; then treepackname="${packname}"; packname="ust"
	elif [ -n "`echo "${packbasename}" | grep 'nm-applet'`" ]; then treepackname="${packname}"; packname="network-manager-applet"
	elif [ -n "`echo "${packbasename}" | grep 'polkit-gnome'`" ]; then treepackname="${packname}"; packname="policykit-1-gnome"
	elif [ -n "`echo "${packbasename}" | grep 'qt3d'`" ]; then treepackname="${packname}"; packname="qt3d-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtcore'`" ]; then treepackname="${packname}"; packname="qtbase-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtdeclarative'`" ]; then treepackname="${packname}"; packname="qtdeclarative-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtfeedback'`" ]; then treepackname="${packname}"; packname="qtfeedback-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtgui'`" ]; then treepackname="${packname}"; packname="qtbase-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtmultimedia'`" ]; then treepackname="${packname}"; packname="qtmultimedia-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtpim'`" ]; then treepackname="${packname}"; packname="qtpim-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'qtwebkit'`" ]; then treepackname="${packname}"; packname="qtwebkit-opensource-src"
	elif [ -n "`echo "${packbasename}" | grep 'telepathy-mission-control'`" ]; then treepackname="${packname}"; packname="telepathy-mission-control-5"
	elif [ -n "`echo "${packbasename}" | grep 'ubuntu-sources'`" ]; then treepackname="${packname}"; packname="linux"
	elif [ -n "`echo "${packbasename}" | grep 'userspace-rcu'`" ]; then treepackname="${packname}"; packname="liburcu"
	elif [ -n "`echo "${packbasename}" | grep 'webapps-base'`" ]; then treepackname="${packname}"; packname="webapps-applications"
	elif [ -n "`echo "${packbasename}" | grep 'webapps-greasemonkey'`" ]; then treepackname="${packname}"; packname="webapps-greasemonkey"
	elif [ -n "`echo "${packbasename}" | grep '^webapps'`" ]; then treepackname="${packname}"; packname="webapps-applications"
	elif [ -n "`echo "${packbasename}" | grep 'xf86-video-ati'`" ]; then treepackname="${packname}"; packname="xserver-xorg-video-ati"
	elif [ -n "`echo "${packbasename}" | grep 'xf86-video-intel'`" ]; then treepackname="${packname}"; packname="xserver-xorg-video-intel"
	elif [ -n "`echo "${packbasename}" | grep 'xf86-video-nouveau'`" ]; then treepackname="${packname}"; packname="xserver-xorg-video-nouveau"
	elif [ -n "`echo "${packbasename}"`" ]; then treepackname="${packname}"
	fi
}

RELEASES="hirsute hirsute-security hirsute-updates impish impish-security impish-updates"
SOURCES="main universe"

sources_download() {
	# Look for /tmp/Sources-* files older than 24 hours #
	#  If found then delete them ready for fresh ones to be fetched #
	#   Use 'find -mmin +1440' as 'find -mtime +1' has strange rounding where it won't return results until file is at least 2 days old #
	[[ -n $(find /tmp -type f -mmin +1440 2> /dev/null | grep Sources-) ]] && rm /tmp/Sources-* 2> /dev/null
	for get_release in ${RELEASES}; do
		for source in ${SOURCES}; do
			if [ ! -f /tmp/Sources-${source}-${get_release} ]; then
				echo
				wget http://archive.ubuntu.com/ubuntu/dists/${get_release}/${source}/source/Sources.gz -O /tmp/Sources-${source}-${get_release}.gz || exit 1
				gunzip -v /tmp/Sources-${source}-${get_release}.gz || exit 1
				touch /tmp/Sources-${source}-${get_release}
			fi
		done
	done
}

version_check() {
	local_to_upstream_packnames
	if [ -n "${stream_release}" ]; then
		version_check_other_releases
	else
		local_version_check
		upstream_version_check ${URELEASE}
		version_compare
	fi
}


local_version_check() {
	packbasename_saved="${packbasename}"    # Save off $packbasename for when uver() loops #
	. "${pack}" &> /dev/null
		uver
	. "${pack}" &> /dev/null
	if [ -n "${URELEASE}" ]; then
		if [ -n "${UVER}" ]; then
			packbasename=`echo "${packbasename}" | \
				sed -e 's:-r[0-9].*$::g' \
					-e 's:[a-z]$::'`	# Strip off trailing letter and revision suffixes from ${PV}
				current=`echo "${packbasename}${UVER_PREFIX}${UVER}${UVER_SUFFIX}"`
		else
			current=`echo "${packbasename}" | \
				sed -e 's:-r[0-9].*$::g' \
					-e 's:[a-z]$::'`	# Strip off trailing letter and revision suffixes from ${PV}
		fi
	fi
	packbasename="${packbasename_saved}"
	UVER=
	UVER_PREFIX=
	UVER_SUFFIX=
}


upstream_version_check() {
	upstream_version=
	if [ -n "$1" ]; then
		sources_download
		upstream_version=
		upstream_version=`grep -A6 "Package: ${packname}$" /tmp/Sources-main-$1 2> /dev/null | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
		[[ -z "${upstream_version}" ]] && upstream_version=`grep -A6 "Package: ${packname}$" /tmp/Sources-universe-$1 2> /dev/null | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
		[[ -z "${upstream_version}" ]] && upstream_version=`grep -A6 "Package: ${packname}$" /tmp/Sources-main-$1 2> /dev/null | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
		[[ -z "${upstream_version}" ]] && upstream_version=`grep -A6 "Package: ${packname}$" /tmp/Sources-universe-$1 2> /dev/null | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
		[ -n "${upstream_version}" ] && [ -z "${CHANGES}" ] && [ -z "${checkmsg_supress}" ] && \
			echo -e "\nChecking ${packname}  ::  $1"
	fi
}


version_compare() {
	current_version=`echo "${current}" | sed "s/^\${treepackname}-//"`
	if [ "${current_version}" = "${upstream_version}" ]; then
		[ -n "${CHANGES}" ] && return
		if [ -n "${stream_release}" ]; then
			if [ -n "`grep "${stream_release}-updates" ${pack}`" ]; then
				echo "  Local version: ${current}  ::  ${stream_release}"
				echo "  Upstream version: ${packname}-${upstream_version}  ::  ${stream_release}"
			else
				echo "  Local version: ${current}  ::  ${stream_release}"
				echo "  Upstream version: ${packname}-${upstream_version}  ::  ${stream_release}"
			fi
		else
			echo "  Local version: ${current}  ::  ${URELEASE}"
			echo "  Upstream version: ${packname}-${upstream_version}  ::  ${URELEASE}"
		fi
	else
		if [ -n "${upstream_version}" ]; then
			echo "  Local version: ${current}  ::  ${URELEASE}"
			echo -e "  Upstream version: \033[1;31m${packname}-${upstream_version}\033[0m  ::  ${URELEASE}"
		fi
	fi
}


version_check_other_releases() {
	if [ -n "${stream_release}" ]; then
		if [ "${stream_release}" = all ]; then
			sources_download
			echo "Checking ${catpack}"
			echo "  Local versions:"
			for ebuild in $(find $(pwd) -name "*.ebuild" 2> /dev/null | grep /"${catpack}"/); do
				URELEASE=
				pack="${ebuild}"
				packbasename=$(basename ${pack} | awk -F.ebuild '{print $1}')
				packname=$(echo ${catpack} | awk -F/ '{print $2}')
				local_version_check
				if [ -z "${current}" ]; then
					echo "    ${packbasename}"
				else
					local_versions+=( "	${current}  :: ${URELEASE}" )
				fi
			done
			local_versions_output=$(IFS=$'\n'; echo "${local_versions[*]}" | sort -k3)
			echo "${local_versions_output}"

			if [ -n "${URELEASE}" ]; then
				echo "  Upstream versions:"
			else
				echo "  No URELEASE found in ebuild, not tracking upstream versions!"
			fi
			for release in ${RELEASES}; do
				for ebuild in $(find $(pwd) -name "*.ebuild" 2> /dev/null | grep /"${catpack}"/ | sort); do
					pack="${ebuild}"
					packbasename=$(basename ${pack} | awk -F.ebuild '{print $1}')
					packname=$(echo ${catpack} | awk -F/ '{print $2}')
					local_to_upstream_packnames
					checkmsg_supress=1
					upstream_version_check ${release}
					checkmsg_supress=
					if [ -n "${upstream_version}" ]; then
						if [ -z "$(echo "${upstream_versions[@]}" | grep "${packname}-${upstream_version}")" ]; then
							# Only add new release element if not already present
							upstream_versions+=( "	${packname}-${upstream_version}  ::  ${release}" )
						fi
					else
						if [ -z "$(echo "${upstream_versions[@]}" | grep "${release}"$)" ] && \
							[ -n "${URELEASE}" ]; then
							upstream_versions+=( "		(none available)  ::  ${release}" )
						fi
					fi
				done
			done
			index=0
			while [ "$index" -lt ${#upstream_versions[@]} ]; do
				upstream_versions_namespace_stripped=$(echo ${upstream_versions[$index]} | awk 'match($0, /-([0-9].*)/, a) {print a[1]}' | sed 's/[	]//g')
				local_versions_whitespace_stripped=$(echo ${local_versions[@]} | sed 's/[	]//g')
				compare_versions_stripped=$(echo ${local_versions_whitespace_stripped} | grep "${upstream_versions_namespace_stripped}")
				upstream_release=$(echo ${upstream_versions[$index]} | awk '{print $3}')
				if [ -n "${compare_versions_stripped}" ] || [ -n "$(echo ${upstream_versions[$index]} | grep "none available")" ]; then
					echo -e "${upstream_versions[$index]}"
				elif [ -n "${URELEASE}" ]; then
					echo -e "\033[1;31m${upstream_versions[$index]}\033[0m"
				fi
				((index++))
			done
			unset local_versions
			unset upstream_versions
			index=
			current=
			release=
			echo
		else
			if [ -z "`grep ${stream_release} ${pack} | grep URELEASE`" ]; then	# Skip over packages that don't contain the queried release #
				return
			else
				local_version_check
				upstream_version_check ${URELEASE}
	                	version_compare
			fi
		fi
	fi
}


uver() {
	[[ "${URELEASE}" == *trusty* ]] && UVER_RELEASE="14.04"
	[[ "${URELEASE}" == *utopic* ]] && UVER_RELEASE="14.10"
	[[ "${URELEASE}" == *vivid* ]] && UVER_RELEASE="15.04"
	[[ "${URELEASE}" == *wily* ]] && UVER_RELEASE="15.10"
	[[ "${URELEASE}" == *xenial* ]] && UVER_RELEASE="16.04"
	[[ "${URELEASE}" == *yakkety* ]] && UVER_RELEASE="16.10"
	[[ "${URELEASE}" == *zesty* ]] && UVER_RELEASE="17.04"
	[[ "${URELEASE}" == *artful* ]] && UVER_RELEASE="17.10"
	[[ "${URELEASE}" == *bionic* ]] && UVER_RELEASE="18.04"
	[[ "${URELEASE}" == *cosmic* ]] && UVER_RELEASE="18.10"
	[[ "${URELEASE}" == *disco* ]] && UVER_RELEASE="19.04"
	[[ "${URELEASE}" == *eoan* ]] && UVER_RELEASE="19.10"
	[[ "${URELEASE}" == *focal* ]] && UVER_RELEASE="20.04"
	[[ "${URELEASE}" == *groovy* ]] && UVER_RELEASE="20.10"
	[[ "${URELEASE}" == *hirsute* ]] && UVER_RELEASE="21.04"
	[[ "${URELEASE}" == *impish* ]] && UVER_RELEASE="21.10"
	PVR=`echo "${packbasename}" | sed -e 's/.*-\([0-9]\)/\1/' -e 's:-r[0-9].*$::g'`
	PVR="_${PVR#*_}"

	packbasename=`echo "${packbasename}" | sed "s/${PVR}//"`
	packbasename=`echo "${packbasename}" | sed "s/[a-z]$//"`
	OIFS=${IFS}
	IFS=p; read -ra PVR_ARRAY <<< "${PVR}"
	IFS=${OIFS}

	## Micro version field ##
	PVR_PL_MICRO="${PVR_ARRAY[1]}"
	PVR_PL_MICRO="${PVR_PL_MICRO%*_}"
	if [ -n "${PVR_PL_MICRO}" ]; then
		[[ -n "${strarray[@]}" ]] && unset 'strarray[@]'
		char=2
		index=1
		strlength="${#PVR_PL_MICRO}"
		while [ "${PVR_PL_MICRO}" != "" ]; do
			strtmp="${PVR_PL_MICRO:0:$char}"
			if [ "${strlength}" -ge 10 ]; then      # Last field can be a floating point so strip off leading zero and add decimal point #
				if [ "${index}" = 5 ]; then
					strtmp=".${strtmp#0}"
				fi
			fi
			strarray+=( "${strtmp}" )
			PVR_PL_MICRO="${PVR_PL_MICRO:$char}"
			((index++))
		done
		PVR_PL_MICRO_tmp="${strarray[@]}"
		PVR_MICRO="${PVR_PL_MICRO_tmp// /}"     # Value gets sourced later from UVER variable in .ebuild #
	fi

	## Major version field ##
	PVR_PL_MAJOR="${PVR_ARRAY[2]}"
	PVR_PL_MAJOR="${PVR_PL_MAJOR%*_}"
	# Support floating point version numbers in major version field (eg. libnih-1.0.3_p0403_p01.ebuild becomes libnih-1.0.3-4.3ubuntu1)
	if [ "${#PVR_PL_MAJOR}" -gt 1 ]; then
		PVR_PL_MAJOR="${PVR_PL_MAJOR%%-r*}"	# Strip revision strings
		char=2
		index=1
		strlength="${#PVR_PL_MAJOR}"
		while [ "${PVR_PL_MAJOR}" != "" ]; do	# Iterate through all chars loading every 2 chars into an array element
			strtmp="${PVR_PL_MAJOR:0:$char}"
			strtmp="${strtmp#0}"
			strarray+=( "${strtmp}" )
			PVR_PL_MAJOR="${PVR_PL_MAJOR:$char}"
			((index++))
		done
		PVR_PL_MAJOR_tmp="${strarray[@]}"
		PVR_PL_MAJOR="${PVR_PL_MAJOR_tmp// /.}"
	fi

	## Minor version field ##
	PVR_PL_MINOR="${PVR_ARRAY[3]}"
	PVR_PL_MINOR="${PVR_PL_MINOR%*_}"
	[[ -n "${strarray[@]}" ]] && unset 'strarray[@]'
	char=2
	index=1
	strlength="${#PVR_PL_MINOR}"
	while [ "${PVR_PL_MINOR}" != "" ]; do
		strtmp="${PVR_PL_MINOR:0:$char}"
		if [ "${strlength}" -ge 6 ]; then       # Don't strip zeros from 3rd number field, this is the Ubuntu OS release #
			if [ "${index}" != 3 ]; then
				strtmp="${strtmp#0}"
			fi
		else
			strtmp="${strtmp#0}"
		fi
		strarray+=( "${strtmp}" )
		PVR_PL_MINOR="${PVR_PL_MINOR:$char}"
		((index++))
	done
	PVR_PL_MINOR_tmp="${strarray[@]}"
	PVR_PL_MINOR="${PVR_PL_MINOR_tmp// /.}"

	if [ "${packname}" = "linux" ]; then
		UVER="${PVR_PL_MAJOR}.${PVR_PL_MINOR}"
	else
		[[ -z ${UVER} ]] && \
			UVER="-${PVR_PL_MAJOR}ubuntu${PVR_PL_MINOR}"
	fi
	[[ -n "${strarray[@]}" ]] && unset 'strarray[@]'
}

while (( "$#" )); do
	case $1 in
		--changes)
			CHANGES=1 && shift;;
		--release=*)
			stream_release=`echo "$1" | sed 's/--release=/ /' | sed 's/^[ \t]*//'` && shift;;
		--help|-h)
			echo -e "$0 (--release=<release>|all) (--changes) (category/package/package-version.ebuild)"; exit 0;;
		*)
			pack="$1" && shift;;
	esac
done

if [ "${stream_release}" = "all" ]; then
	for catpack in `find $(pwd) -name "*.ebuild" | awk -F/ '{print ( $(NF-2) )"/"( $(NF-1) )}' 2> /dev/null | sort -du | grep -Ev "eclass|metadata|profiles"`; do
		packname=`echo ${catpack} | awk -F/ '{print $2}'`
		version_check
	done
elif [ -n "${pack}" ]; then
	packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
	packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}' | sed 's:-[0-9].*::g'`
	version_check
else
	for pack in `find $(pwd) -name "*.ebuild" 2> /dev/null`; do
		packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
		packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
		version_check
	done
	if [ -z "${stream_release}" ]; then
		## Check versions in meta type ebuilds that install from multiple sources ##
		if [ -d "$(pwd)/unity-base/unity-language-pack" ]; then
			pushd $(pwd)/unity-base/unity-language-pack
				[ -n "${CHANGES}" ] && \
					./lang_version_check.sh --changes || \
						./lang_version_check.sh
			popd
		fi
		if [ -d "$(pwd)/unity-base/webapps" ]; then
			pushd $(pwd)/unity-base/webapps
				[ -n "${CHANGES}" ] && \
					./webapps_version_check.sh --changes || \
						./webapps_version_check.sh
			popd
		fi
		if [ -d "$(pwd)/unity-scopes/smart-scopes" ]; then
			pushd $(pwd)/unity-scopes/smart-scopes
				[ -n "${CHANGES}" ] && \
					./scopes_version_check.sh --changes || \
						./scopes_version_check.sh
			popd
		fi
	fi
fi
