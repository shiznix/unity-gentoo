#!/bin/sh

for pack in `find $(pwd) -name "*.ebuild"`; do
	packbasename=`basename ${pack} | awk -F.ebuild '{print $1}'`
	packname=`echo ${pack} | awk -F/ '{print ( $(NF-1) )}'`
	. ${pack} &> /dev/null
	if [ -n "${UVER}" ]; then
		current="${packbasename}-${UVER}"
		upstream=`wget -q "http://packages.ubuntu.com/${URELEASE}/source/${packname}" -O - | sed -n "s/.*${packname} (\(.*\)).*/${packname}-\1/p"`
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
