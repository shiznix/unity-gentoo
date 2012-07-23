#!/bin/sh

for pack in `find $(pwd) -name "*.ebuild"`; do
	packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
	packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
	if [ -n "`echo "${packbasename}" | grep 'ccsm'`" ]; then packname="compizconfig-settings-manager"
	elif [ -n "`echo "${packbasename}" | grep 'fixesproto'`" ]; then packname="x11proto-fixes"
	elif [ -n "`echo "${packbasename}" | grep 'glib'`" ]; then packname="glib2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-99.2'`" ]; then packname="gtk+2.0"
	elif [ -n "`echo "${packbasename}" | grep 'gtk+-99.3'`" ]; then packname="gtk+3.0"
	elif [ -n "`echo "${packbasename}" | grep 'libXfixes'`" ]; then packname="libxfixes"
	elif [ -n "`echo "${packbasename}" | grep 'lazr-restfulclient'`" ]; then packname="lazr.restfulclient"
	elif [ -n "`echo "${packbasename}" | grep 'nm-applet'`" ]; then packname="network-manager-applet"
	elif [ -n "`echo "${packbasename}" | grep 'unity2d'`" ]; then packname="unity-2d"
	fi
	. ${pack} &> /dev/null
	if [ -n "${UVER}" ]; then
		current=`echo "${packbasename}-${UVER}" | sed 's/99.//g'`
		upstream=`wget -q "http://packages.ubuntu.com/${URELEASE}/source/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p" | sed 's/1://g'`
		echo
		echo "Checking http://packages.ubuntu.com/${URELEASE}/source/${packname}"
		echo "Current version:  ${current}"
		if [ "${current}" != "${upstream}" ]; then
			echo -e "Upstream version: \033[5m\033[1m${upstream}\033[0m"
		else
			echo "Upstream version: ${upstream}"
		fi
		echo
	fi
	UVER=
	upstream=
done
