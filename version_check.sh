#!/bin/sh

## Script to compare upstream versions of packages with versions in overlay tree ##
# If run without any arguments it recurses through the overlay tree and compares versions for all packages #
# Or can be run on individual packages as 'version_check.sh category/package-version.ebuild' #

local_to_upstream_packnames() {
	## Overlay package names to upstream package names mapping ##
	if [ -n "`echo "${packbasename}" | grep 'appmenu-libreoffice'`" ]; then treepackname="${packname}"; packname="lo-menubar"
	elif [ -n "`echo "${packbasename}" | grep 'appmenu-thunderbird'`" ]; then treepackname="${packname}"; packname="thunderbird-globalmenu"
	elif [ -n "`echo "${packbasename}" | grep 'chromium-[0-9]'`" ]; then treepackname="${packname}"; packname="chromium-browser"
	elif [ -n "`echo "${packbasename}" | grep 'fixesproto'`" ]; then treepackname="${packname}"; packname="x11proto-fixes"
	elif [ -n "`echo "${packbasename}" | grep '^glib-[0-9]'`" ]; then treepackname="${packname}"; packname="glib2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gnome-desktop'`" ]; then treepackname="${packname}"; packname="gnome-desktop3"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-2'`" ]; then treepackname="${packname}"; packname="gtk+2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-3'`" ]; then treepackname="${packname}"; packname="gtk+3.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk-engines-unico'`" ]; then treepackname="${packname}"; packname="gtk3-engines-unico"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-classicmenu'`" ]; then treepackname="${packname}"; packname="classicmenu-indicator"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-evolution'`" ]; then treepackname="${packname}"; packname="evolution-indicator"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-psensor'`" ]; then treepackname="${packname}"; packname="psensor"
	elif [ -n "`echo "${packbasename}" | grep 'libupstart-[0-9]'`" ]; then treepackname="${packname}"; packname="upstart"
	elif [ -n "`echo "${packbasename}" | grep 'libupstart-app-launch'`" ]; then treepackname="${packname}"; packname="upstart-app-launch"
	elif [ -n "`echo "${packbasename}" | grep 'libXfixes'`" ]; then treepackname="${packname}"; packname="libxfixes"
	elif [ -n "`echo "${packbasename}" | grep 'libXi'`" ]; then treepackname="${packname}"; packname="libxi"
	elif [ -n "`echo "${packbasename}" | grep 'lazr-restfulclient'`" ]; then treepackname="${packname}"; packname="lazr.restfulclient"
	elif [ -n "`echo "${packbasename}" | grep 'mesa-mir'`" ]; then treepackname="${packname}"; packname="mesa"
	elif [ -n "`echo "${packbasename}" | grep 'nm-applet'`" ]; then treepackname="${packname}"; packname="network-manager-applet"
	elif [ -n "`echo "${packbasename}" | grep 'qtpim'`" ]; then treepackname="${packname}"; packname="libqt5organizer5"
	elif [ -n "`echo "${packbasename}" | grep 'telepathy-mission-control'`" ]; then treepackname="${packname}"; packname="telepathy-mission-control-5"
	elif [ -n "`echo "${packbasename}" | grep 'unity-webapps'`" ]; then treepackname="${packname}"; packname="libunity-webapps"
	elif [ -n "`echo "${packbasename}" | grep 'webapps-base'`" ]; then treepackname="${packname}"; packname="unity-webapps-common"
	elif [ -n "`echo "${packbasename}" | grep 'xf86-video-intel'`" ]; then treepackname="${packname}"; packname="xserver-xorg-video-intel"
	elif [ -n "`echo "${packbasename}"`" ]; then treepackname="${packname}"
	fi
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
	if [ -z "`grep UVER= ${pack}`" ]; then
		uver
	else
		UVER=`grep UVER= ${pack} | awk -F\" '{print $2}'`
	fi
	UVER_PREFIX=`grep UVER_PREFIX= ${pack} | awk -F\" '{print $2}'`
	UVER_SUFFIX=`grep UVER_SUFFIX= ${pack} | awk -F\" '{print $2}'`
	URELEASE=`grep URELEASE= ${pack} | awk -F\" '{print $2}'`
	if [ -n "${URELEASE}" ]; then
		if [ -n "${UVER}" ]; then
			current=`echo "${packbasename}${UVER_PREFIX}-${UVER}${UVER_SUFFIX}"`
		else
			current=`echo "${packbasename}" | sed 's:-r[0-9].*$::g'`
		fi
	fi
	packbasename="${packbasename_saved}"
}


upstream_version_check() {
		upstream_version=
		if [ -n "$1" ]; then
			## Try version lookup from the Sources.bz2 tarball first as this is faster, but fallback to web scrape request when it fails ##
			##  Don't use tarball method if script is run as ./version_check.sh <pathto>/something-1.2.ebuild ##
			if [ -n "${nopack}" ]; then
				if [ ! -f /tmp/Sources-$1 ]; then
					echo
					wget http://archive.ubuntu.com/ubuntu/dists/$1/main/source/Sources.bz2 -O /tmp/Sources-$1.bz2
					bunzip2 /tmp/Sources-$1.bz2
				fi
				upstream_version=`grep -A2 "Package: ${packname}$" /tmp/Sources-$1 | sed -n 's/^Version: \(.*\)/\1/p' | sed 's/[0-9]://g'`
				[ -n "${upstream_version}" ] && [ -z "${CHANGES}" ] && echo -e "\nChecking ${packname}  ::  $1"
			fi

			if [ -z "${upstream_version}" ]; then
				upstream_version_scraped=`wget -q "http://packages.ubuntu.com/$1/source/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed "s/).*//g" | sed 's/1://g'`
				if [ -z "${upstream_version_scraped}" ]; then
					[ "${stream_release}" != all ] && [ -z "${CHANGES}" ] && echo -e "\nChecking http://packages.ubuntu.com/$1/${packname}"
					upstream_version_scraped=`wget -q "http://packages.ubuntu.com/$1/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed "s/).*//g" | sed 's/1://g'`
				else
					[ "${stream_release}" != all ] && [ -z "${CHANGES}" ] && echo -e "\nChecking http://packages.ubuntu.com/$1/source/${packname}"
				fi
				upstream_version=`echo "${upstream_version_scraped}" | sed "s/^\${packname}-//" | sed 's/[0-9]://g'`
			fi
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
			echo -e "  Upstream version: \033[5m\033[1;31m${packname}-${upstream_version}\033[0m  ::  ${URELEASE}"
		fi
	fi
}


version_check_other_releases() {
	ALL_RELEASES_TO_CHECK="saucy saucy-updates trusty"
	if [ -n "${stream_release}" ]; then
		if [ "${stream_release}" = all ]; then
			echo "Checking ${catpack}"
			echo "  Local versions:"
			for ebuild in `find $(pwd) -name "*.ebuild" | grep /"${catpack}"/`; do
				pack="${ebuild}"
				packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
				local_version_check
				if [ -z "${current}" ]; then
					echo "    ${packbasename}"
				else
					echo "    ${current}  :: ${URELEASE}"
				fi
			done
			echo "  Upstream versions:"
			local_to_upstream_packnames
			for release in ${ALL_RELEASES_TO_CHECK}; do
				upstream_version_check ${release}
				echo "    ${upstream_version_scraped}  ::  ${release}"
			done
			current=
			upstream_version_scraped=
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
	PVR=`echo "${packbasename}" | awk -F_p '{print "_p"$(NF-1)"_p"$NF }'`
	packbasename=`echo "${packbasename}" | sed "s/${PVR}//"`
	packbasename=`echo "${packbasename}" | sed "s/[a-z]$//"`
	PVR_PL_MAJOR="${PVR#*_p}"
	PVR_PL_MAJOR="${PVR_PL_MAJOR%_p*}"
	PVR_PL="${PVR##*_p}"
	PVR_PL="${PVR_PL%%-r*}"
	char=2
	index=1
	strlength="${#PVR_PL}"
	while [ "${PVR_PL}" != "" ]; do
		strtmp="${PVR_PL:0:$char}"
		if [ "${strlength}" -ge 6 ]; then       # Don't strip zeros from 3rd number field, this is the Ubuntu OS release #
			if [ "${index}" != 3 ]; then
				strtmp="${strtmp#0}"
			fi
		else
			strtmp="${strtmp#0}"
		fi
		strarray+=( "${strtmp}" )
		PVR_PL="${PVR_PL:$char}"
		((index++))
	done
	PVR_PL_MINOR="${strarray[@]}"
	PVR_PL_MINOR="${PVR_PL_MINOR// /.}"	# Convert spaces in array to decimal points
	UVER="${PVR_PL_MAJOR}ubuntu${PVR_PL_MINOR}"
	unset strarray[@]
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
	for catpack in `find $(pwd) -name "*.ebuild" | awk -F/ '{print ( $(NF-2) )"/"( $(NF-1) )}' | sort -du | grep -Ev "eclass|metadata|profiles"`; do
		packname=`echo ${catpack} | awk -F/ '{print $2}'`
		version_check
	done
elif [ -n "${pack}" ]; then
	packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
	packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
	version_check
else
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
	nopack=1
	for pack in `find $(pwd) -name "*.ebuild"`; do
		packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
		packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
		version_check
	done
fi

# Tidy up #
rm /tmp/Sources-* 2> /dev/null
