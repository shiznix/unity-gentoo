if [[ ${EBUILD_PHASE} == "setup" ]] ; then
	CURRENT_PROFILE="$(readlink /etc/portage/make.profile)"
	if [ -z "$(echo ${CURRENT_PROFILE} | grep unity-gentoo)" ]; then
		die "Invalid profile detected, please select a 'unity-gentoo' profile for your architecture shown in 'eselect profile list'"
	else
		PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | awk -F/ '{print $(NF-1)}')
	fi
	if [ "$(eval echo \${UNITY_DEVELOPMENT_${PROFILE_RELEASE}})" != "yes" ]; then
		die "Oops! A development profile has been detected. Set 'UNITY_DEVELOPMENT_${PROFILE_RELEASE}=yes' in make.conf if you really know how broken this profile could be"
	fi

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

## Mimic the function of epatch_user/eapply_user
##   and /etc/portage/patches/ so we can custom patch packages
##   we don't need to maintain. Loosly based on eapply_user function
##   from /usr/lib/portage/python*/phase-helpers.sh and
##   https://wiki.gentoo.org/wiki//etc/portage/patches#Enabling_.2Fetc.2Fportage.2Fpatches_for_all_ebuilds.
if [[ ${EBUILD_PHASE} == "prepare" ]]; then

local eapply_source run_post_src_prepare run_eautoreconf

pre_src_prepare() {
	local repodir="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	local optdir=${PORTAGE_CONFIGROOT%/}/etc/portage/unity-patches
	local -a basearr=(${repodir}/profiles/${PROFILE_RELEASE}/patches ${optdir})
	local basedir d

	local prev_shopt=$(shopt -p nullglob)
	shopt -s nullglob

	## Basedir priority order:
	##   1) unity-gentoo profile #repodir
	##   2) /etc/portage/unity-patches #optdir
	## Packagedir priority order:
	## e.g. for app-arch/file-roller-3.22.3-r1:0::gentoo
	##   1) app-arch/file-roller-3.22.3-r1
	##   2) app-arch/file-roller-3.22.3
	##   3) app-arch/file-roller-3.22
	##   3) app-arch/file-roller-3
	##   4) app-arch/file-roller
	## all of the above may be optionally followed by a slot:
	##   app-arch/file-roller-3.22.3-r1:0
	##   app-arch/file-roller:0
	## Possible file extensions:
	##   *.diff or *.patch
	for basedir in "${basearr[@]}"; do
		for d in "${basedir}"/${CATEGORY}/{${P}-${PR},${P},${PN}{-${PV%.*},-${PV%.*.*},}}{,:${SLOT%/*}}; do
			if [[ -n $(echo "${d}"/*.diff) || -n $(echo "${d}"/*.patch) ]]; then
				## Look for 'enabled' file in 'optdir'.
				[[ ${basedir} != ${optdir} ]] \
					|| [[ -f ${d}/enabled ]] \
					|| break 2

				## Set patches source.
				eapply_source=${d}

				## Set config triggers.
				[[ -f ${d}/eautoreconf ]] \
					&& run_eautoreconf=1
				[[ -f ${d}/post_prepare ]] \
					&& run_post_src_prepare=1

				break 2
			fi
		done
	done

	${prev_shopt}

	## If there are some patches to be applied
	##   define function to apply them.
	if [[ -n ${eapply_source} ]]; then

	_apply_unity-gentoo_patches() {
		## Pull eapply function if it is not available.
		if ! type eapply > /dev/null 2>&1; then
			local sh_script=${EROOT%/}/usr/lib/portage/${PYTHON_SINGLE_TARGET/_/.}/phase-helpers.sh
			[[ -f ${sh_script} ]] \
				|| die "${sh_script} not found"

			einfo "Pulling eapply function from ${sh_script} ..."
			source <(awk "/^(\w|#)/ { p = 0 } /^(\t|)eapply\() {\$/ { p = 1 } p { print }" ${sh_script})
			type eapply > /dev/null 2>&1 \
				|| die "eapply not found"
		fi

		eapply "${eapply_source}"
		einfo "User patches applied."

		[[ -n ${sh_script} ]] && unset -f eapply

		## Run eautoreconf if needed.
		if [[ -n ${run_eautoreconf} ]]; then
			## Pull autotools.eclass functions
			##   if they are not available.
			if ! type eautoreconf > /dev/null 2>&1; then
				local eclass=${PORTDIR}/eclass/autotools.eclass
				[[ -f ${eclass} ]] \
					|| die "${eclass} not found"

				einfo "Pulling autotools functions from ${eclass} ..."
				local autotools_names="eautoreconf _at_uses_pkg _at_uses_autoheader _at_uses_automake _at_uses_gettext _at_uses_glibgettext _at_uses_intltool _at_uses_gtkdoc _at_uses_gnomedoc _at_uses_libtool _at_uses_libltdl eaclocal_amflags eaclocal _elibtoolize eautoheader eautoconf eautomake autotools_env_setup autotools_run_tool ALL_AUTOTOOLS_MACROS autotools_check_macro autotools_check_macro_val _autotools_m4dir_include autotools_m4dir_include autotools_m4sysdir_include"
				source <(awk "/^(\w|#)/ { p = 0 } /^(${autotools_names// /|})/ { p = 1 } p { print }" ${eclass})
				type eautoreconf > /dev/null 2>&1 \
					|| die "eautoreconf not found"
			fi

			## Don't use elibtoolize
			##   in post_src_prepare phase.
			[[ -n ${run_post_src_prepare} ]] \
				&& AT_NOELIBTOOLIZE="yes" eautoreconf \
				|| eautoreconf

			local name
			for name in ${autotools_names}; do
				unset ${name}
			done
		fi
	} ## End of _apply_unity-gentoo_patches function.

	## Apply patches intended for pre_src_prepare phase.
	[[ -n ${run_post_src_prepare} ]] || _apply_unity-gentoo_patches

	fi
}

post_src_prepare() {
	## Apply patches intended for post_src_prepare phase.
	[[ -n ${run_post_src_prepare} ]] && _apply_unity-gentoo_patches

	unset -v eapply_source run_post_src_prepare run_eautoreconf
	unset -f _apply_unity-gentoo_patches
}

fi ## End of 'prepare' phase.

post_src_install() {
	## Look for existence of
	##   profiles/${PROFILE_RELEASE}/ebuild_hooks/${CATEGORY}/${P}/post_src_install.sh
	##   and run it to perform hook.
	local repodir="$(/usr/bin/portageq get_repo_path / unity-gentoo)"
	local basedir=${repodir}/profiles/${PROFILE_RELEASE}/ebuild_hooks
	local d

	for d in "${basedir}"/${CATEGORY}/{${P}-${PR},${P},${PN}-${PV%.*},${PN}}{,:${SLOT%/*}}; do
		if [[ -x "${d}"/post_src_install.sh ]]; then
			einfo "Applying ebuild_hooks script ${d}/post_src_install.sh"
			export HOOK_SOURCE="${d}"
			${HOOK_SOURCE}/post_src_install.sh
			return 0
		fi
	done
}
