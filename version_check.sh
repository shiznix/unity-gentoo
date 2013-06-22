#!/bin/sh

## Script to compare upstream versions of packages with versions in overlay tree ##
# If run without any arguments it recurses through the overlay tree and compares versions for all packages #
# Or can be run on individual packages as 'version_check.sh category/package-version.ebuild' #

local_to_upstream_packnames() {
	## Overlay package names to upstream package names mapping ##
	if [ -n "`echo "${packbasename}" | grep 'appmenu-firefox'`" ]; then treepackname="${packname}"; packname="firefox-globalmenu"
	elif [ -n "`echo "${packbasename}" | grep 'appmenu-libreoffice'`" ]; then treepackname="${packname}"; packname="lo-menubar"
	elif [ -n "`echo "${packbasename}" | grep 'appmenu-thunderbird'`" ]; then treepackname="${packname}"; packname="thunderbird-globalmenu"
	elif [ -n "`echo "${packbasename}" | grep 'chromium-[0-9]'`" ]; then treepackname="${packname}"; packname="chromium-browser"
	elif [ -n "`echo "${packbasename}" | grep 'fixesproto'`" ]; then treepackname="${packname}"; packname="x11proto-fixes"
	elif [ -n "`echo "${packbasename}" | grep '^glib-[0-9]'`" ]; then treepackname="${packname}"; packname="glib2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-2'`" ]; then treepackname="${packname}"; packname="gtk+2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-3'`" ]; then treepackname="${packname}"; packname="gtk+3.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk-engines-unico'`" ]; then treepackname="${packname}"; packname="gtk3-engines-unico"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-evolution'`" ]; then treepackname="${packname}"; packname="evolution-indicator"
	elif [ -n "`echo "${packbasename}" | grep 'indicator-psensor'`" ]; then treepackname="${packname}"; packname="psensor"
	elif [ -n "`echo "${packbasename}" | grep 'libXfixes'`" ]; then treepackname="${packname}"; packname="libxfixes"
	elif [ -n "`echo "${packbasename}" | grep 'libXi'`" ]; then treepackname="${packname}"; packname="libxi"
	elif [ -n "`echo "${packbasename}" | grep 'lazr-restfulclient'`" ]; then treepackname="${packname}"; packname="lazr.restfulclient"
	elif [ -n "`echo "${packbasename}" | grep 'nm-applet'`" ]; then treepackname="${packname}"; packname="network-manager-applet"
	elif [ -n "`echo "${packbasename}" | grep 'unity-language-pack'`" ]; then treepackname="${packname}"; packname="language-pack-gnome-en"
	elif [ -n "`echo "${packbasename}" | grep 'unity-webapps'`" ]; then treepackname="${packname}"; packname="libunity-webapps"
	elif [ -n "`echo "${packbasename}" | grep '^webapps-[0-9]'`" ]; then treepackname="${packname}"; packname="unity-webapps-common"
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
	upstream_version_scraped=`wget -q "http://packages.ubuntu.com/$1/source/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
	if [ -z "${upstream_version_scraped}" ]; then
		[ "${stream_release}" != all ] && echo -e "\nChecking http://packages.ubuntu.com/$1/${packname}"
		upstream_version_scraped=`wget -q "http://packages.ubuntu.com/$1/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
	else
		[ "${stream_release}" != all ] && echo -e "\nChecking http://packages.ubuntu.com/$1/source/${packname}"
	fi
	upstream_version=`echo "${upstream_version_scraped}" | sed "s/^\${packname}-//"`
}


version_compare() {
	current_version=`echo "${current}" | sed "s/^\${treepackname}-//"`
	if [ "${current_version}" = "${upstream_version}" ]; then
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
			echo -e "  Local version: \033[5m\033[1m${current}\033[0m  ::  ${URELEASE}"
			echo "  Upstream version: ${packname}-${upstream_version}  ::  ${URELEASE}"
		fi
	fi
}


version_check_other_releases() {
	ALL_RELEASES_TO_CHECK="raring raring-updates saucy"
	if [ -n "${stream_release}" ]; then
		if [ "${stream_release}" = all ]; then
			echo "Checking ${catpack}"
			echo "  Local versions:"
			for ebuild in `ls -1 ${catpack}/*.ebuild`; do
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
				upstream_version_check ${stream_release}
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
	while [ "${PVR_PL}" != "" ]; do
		strtmp="${PVR_PL:0:$char}"
		strtmp="${strtmp#0}"
		strarray+=( "${strtmp}" )
		PVR_PL="${PVR_PL:$char}"
	done
	PVR_PL_MINOR="${strarray[@]}"
	PVR_PL_MINOR="${PVR_PL_MINOR// /.}"	# Convert spaces in array to decimal points
	UVER="${PVR_PL_MAJOR}ubuntu${PVR_PL_MINOR}"
	unset strarray[@]
}


while (( "$#" )); do
	case $1 in
		--release=*)
			stream_release=`echo "$1" | sed 's/--release=/ /' | sed 's/^[ \t]*//'` && shift;;
		--help|-h)
			echo -e "$0 (--release=<release>|all) (category/package/package-version.ebuild)"; exit 0;;
		*)
			pack="$1" && shift;;
	esac
done

if [ "${stream_release}" = "all" ]; then
	for catpack in `dirname */*/* | sort -du | grep -Ev "eclass|metadata|profiles"`; do
		packname=`echo ${catpack} | awk -F/ '{print $2}'`
		version_check
	done
elif [ -n "${pack}" ]; then
	packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
	packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
	version_check
else
	for pack in `find $(pwd) -name "*.ebuild"`; do
		packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
		packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
		version_check
	done
fi
