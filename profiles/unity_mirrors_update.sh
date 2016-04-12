#!/bin/bash
# This script is needed as Ubuntu mirrors in Gentoo are unmaintained at present (refer b.g.o #494882)

## Usage: ./unity_mirrors_update.sh > thirdpartymirrors

# Grab list of working mirrors #
lynx -width 500 -dump https://launchpad.net/ubuntu/+archivemirrors | sed 's/^ *//g' > /tmp/ubuntu_mirrors.txt || exit 1
# Extract link IDs and load into '${http_linkid_array[@]}'
for each in $(grep -i "up to date" /tmp/ubuntu_mirrors.txt | sed 's/.*\[\([^]]*\)\]http.*/\1/g' | grep ^[0-9]); do
	http_linkid_array+=( "${each}" )
done
# Grep for link IDs and load matching URLs into '${http_link_array[@]}'
for each in $(echo "${http_linkid_array[@]}"); do
	http_link_array+=( $(grep "^${each}\\." /tmp/ubuntu_mirrors.txt | awk '{print $2}') )
done
# Final output #
echo "unity	${http_link_array[@]}"
