if [[ ${EBUILD_PHASE} == "setup" ]] ; then
	if [ "${I_KNOW_WHAT_I_AM_DOING}" != "yes" ]; then
		die "Oops! A development profile has been detected. Set 'I_KNOW_WHAT_I_AM_DOING=yes' in make.conf if you really know how broken this profile could be"
	fi
fi
