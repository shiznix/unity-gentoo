if [[ ${EBUILD_PHASE} == "setup" ]] ; then
	CURRENT_PROFILE="$(readlink /etc/portage/make.profile)"
	if [ -z "$(echo ${CURRENT_PROFILE} | grep unity-gentoo)" ]; then
		die "Invalid profile detected, please select a 'unity-gentoo' profile for your architecture shown in 'eselect profile list'"
	else
		PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | awk -F/ '{print $(NF-1)}')
	fi
#	if [ "$(eval echo \${UNITY_DEVELOPMENT_${PROFILE_RELEASE}})" != "yes" ]; then
#		die "Oops! A development profile has been detected. Set 'UNITY_DEVELOPMENT_${PROFILE_RELEASE}=yes' in make.conf if you really know how broken this profile could be"
#	fi

	KEYWORD_STATE="${KEYWORD_STATE:=`grep ACCEPT_KEYWORDS /etc/portage/make.conf 2>/dev/null`}"
	KEYWORD_STATE="${KEYWORD_STATE:=`grep ACCEPT_KEYWORDS /etc/make.conf 2>/dev/null`}"
	if [ -n "$(echo ${KEYWORD_STATE} | grep \~)" ] && \
		[ "$(eval echo \${UNITY_GLOBAL_KEYWORD_UNMASK})" != "yes" ]; then
			eerror "Oops! Your system has been detected as having ~arch keywords globally unmasked (${KEYWORD_STATE})"
			eerror " To maintain build sanity for Unity it is highly recommended to *NOT* globally set your entire system to experimental"
			eerror " To override this error message, set 'UNITY_GLOBAL_KEYWORD_UNMASK=yes' in make.conf and accept that many packages may fail to build or run correctly"
			eerror
			die
	fi
fi

pre_src_prepare() {
	## Mimic the function of epatch_user/eapply_user and /etc/portage/patches/ so we can custom patch packages we don't need to maintain ##
	#    Most below taken from eutils.eclass #
	local REPO_ROOT="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	local EPATCH_SOURCE check base=${REPO_ROOT}/profiles/${PROFILE_RELEASE}/patches
	local applied="${T}/epatch_user.log"

	for check in ${CATEGORY}/{${P}-${PR},${PN}-${PV},${PN}}{,:${SLOT}}; do
		EPATCH_SOURCE=${base}/${CTARGET}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${CHOST}/${check}
		[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${base}/${check}
		if [[ -d ${EPATCH_SOURCE} ]] ; then
			EPATCH_SOURCE=${EPATCH_SOURCE} \
			EPATCH_SUFFIX="patch" \
			EPATCH_FORCE="yes" \
			EPATCH_MULTI_MSG="Applying user patches from ${EPATCH_SOURCE} ..." \
			epatch
			echo "${EPATCH_SOURCE}" > "${applied}"
			return 0
		fi
	done
}

post_src_install() {
	## Look for existence of profiles/${PROFILE_RELEASE}/ebuild_hooks/${CATEGORY}/${P}/post_src_install.sh and run it to perform hook ##
	local REPO_ROOT="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	local HOOK_SOURCE check base=${REPO_ROOT}/profiles/${PROFILE_RELEASE}/ebuild_hooks
	for check in ${CATEGORY}/{${P}-${PR},${PN}-${PV},${PN}}{,:${SLOT}}; do
		HOOK_SOURCE=${base}/${CTARGET}/${check}
		[[ -r ${HOOK_SOURCE} ]] || HOOK_SOURCE=${base}/${CHOST}/${check}
		[[ -r ${HOOK_SOURCE} ]] || HOOK_SOURCE=${base}/${check}
		if [[ -f ${HOOK_SOURCE}/post_src_install.sh ]]; then
			einfo "Applying ebuild_hooks script ${HOOK_SOURCE}/post_src_install.sh"
			export HOOK_SOURCE="${HOOK_SOURCE}"
			${HOOK_SOURCE}/post_src_install.sh
			return 0
		fi
	done
}
