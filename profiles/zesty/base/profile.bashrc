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

## Mimic the function of epatch_user/eapply_user and /etc/portage/patches/
## so we can custom patch packages we don't need to maintain.
## Loosly based on /usr/portage/eclass/epatch.eclass
## and
## https://wiki.gentoo.org/wiki//etc/portage/patches#Enabling_.2Fetc.2Fportage.2Fpatches_for_all_ebuilds.

if [[ ${EBUILD_PHASE} == "prepare" ]]; then

local -a epatch_source_arr=()
local run_eautoreconf run_post_src_prepare set_valac

pre_src_prepare() {
	local value check file EPATCH_SOURCE CTARGET=${CTARGET:-${CHOST}}
	local REPO_ROOT=$(/usr/bin/portageq get_repo_path / unity-gentoo)
	local opt_dir=${EROOT%/}/etc/portage/unity-patches

	## Patches directories.
	local -a base=( ${REPO_ROOT}/profiles/${PROFILE_RELEASE}/patches ${opt_dir} )

	## Search for patches.
	## Naming priority order:
	## e.g. for app-arch/file-roller-3.22.3-r1:0::gentoo
	##   app-arch/file-roller-3.22.3-r1
	##   app-arch/file-roller-3.22.3
	##   app-arch/file-roller-3.22
	##   app-arch/file-roller
	## to append a SLOT to any of them, use '--' as delimiter:
	##   app-arch/file-roller-3.22.3-r1--0
	##   app-arch/file-roller--0
	for value in "${base[@]}"; do
		for check in ${CATEGORY}/{${P}-${PR},${P},${PN}-${PV%.*},${PN}}{,--${SLOT%/*}}; do
			EPATCH_SOURCE=${value}/${CTARGET}/${check}
			[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${value}/${CHOST}/${check}
			[[ -r ${EPATCH_SOURCE} ]] || EPATCH_SOURCE=${value}/${check}
			if [[ -d ${EPATCH_SOURCE} ]]; then
				## Look for 'enabled' file if we are in ${opt_dir}
				[[ ${value} != ${opt_dir} ]] || [[ -f ${EPATCH_SOURCE}/enabled ]] || break
				## At least one *.patch file is needed.
				for file in ${EPATCH_SOURCE}/*.patch; do
					[[ -f ${file} ]] && \
						epatch_source_arr+=( ${EPATCH_SOURCE} )
					break 2
				done
			fi
		done
	done

	## Set config triggers.
	for value in "${epatch_source_arr[@]}"; do
		[[ -f ${value}/eautoreconf ]] && run_eautoreconf="yes"
		[[ -f ${value}/post ]] && run_post_src_prepare="yes"
		[[ -f ${value}/valac ]] && set_valac="yes"
	done

	if [[ -n ${epatch_source_arr[@]} ]]; then
		## If there are some patches to be applied, define apply function.
		_apply_patches() {
			local value applied=${T}/epatch_user.log
			for value in "${epatch_source_arr[@]}"; do
				EPATCH_SOURCE=${value} \
				EPATCH_SUFFIX="patch" \
				EPATCH_FORCE="yes" \
				EPATCH_MULTI_MSG="Applying patches from ${value} ..." \
				epatch
				echo "${value}" >> "${applied}"
			done

			## Run eautoreconf if needed.
			if [[ ${run_eautoreconf} == "yes" ]]; then

				## Pull autotools.eclass functions if they are not available.
				if ! type eautoreconf > /dev/null 2>&1; then
					local eclass=${PORTDIR}/eclass/autotools.eclass
					[[ -f ${eclass} ]] || die "${eclass} not found"

					einfo "Pulling autotools functions from ${eclass} ..."
					local autotools_names="eautoreconf _at_uses_pkg _at_uses_autoheader _at_uses_automake _at_uses_gettext _at_uses_glibgettext _at_uses_intltool _at_uses_gtkdoc _at_uses_gnomedoc _at_uses_libtool _at_uses_libltdl eaclocal_amflags eaclocal _elibtoolize eautoheader eautoconf eautomake autotools_env_setup autotools_run_tool ALL_AUTOTOOLS_MACROS autotools_check_macro autotools_check_macro_val _autotools_m4dir_include autotools_m4dir_include autotools_m4sysdir_include"
					source <(awk "/^(\w|#)/ { p = 0 } /^(${autotools_names// /|})/ { p = 1 } p { print }" ${eclass})
					type eautoreconf > /dev/null 2>&1 \
						|| die "eautoreconf not found"
				fi

				## Don't use libtoolize if we are in post_src_prepare phase.
				[[ ${run_post_src_prepare} == "yes" ]] \
					&& AT_NOELIBTOOLIZE="yes" eautoreconf \
					|| eautoreconf

				for name in ${autotools_names}; do
					unset ${name}
				done
			fi
		} ## End of _apply_patches function.

		## Apply patches intended for pre_src_prepare phase
		[[ ${run_post_src_prepare} == "yes" ]] || _apply_patches
	fi
}

post_src_prepare() {
	## Apply patches intended for post_src_prepare phase
	[[ ${run_post_src_prepare} == "yes" ]] && _apply_patches
	unset -v epatch_source_arr run_eautoreconf run_post_src_prepare
	unset -f _apply_patches
}

fi ## End of prepare phase.

if [[ ${EBUILD_PHASE} == "configure" && ${set_valac} == "yes" ]]; then

## Configure real VALAC version in makefile
post_src_configure() {
	## Look for the makefile name
	local file="Makefile"
	[[ -f ${file} ]] || file="GNUmakefile"
	[[ -f ${file} ]] || file="makefile"
	[[ -f ${file} ]] || die "makefile not found"

	## Pull vala.eclass functions if they are not available.
	if ! type vala_best_api_version > /dev/null 2>&1; then
		local eclass=${PORTDIR}/eclass/vala.eclass
		[[ -f ${eclass} ]] || die "${eclass} not found"

		local vala_names="VALA_MIN_API_VERSION VALA_MAX_API_VERSION vala_api_versions vala_best_api_version"
		einfo "Pulling vala functions from ${eclass} ..."
		source <(awk "/^(\w|#)/ { p = 0 } /^(${vala_names// /|})/ { p = 1 } p { print }" ${eclass})
		type vala_best_api_version > /dev/null 2>&1 \
			|| die "vala_best_api_version not found"
	fi

	## Replace 'true' with real valac version
	local valaver=$(vala_best_api_version)
	local VALAC=$(type -p valac-${valaver})
	einfo "Reconfiguring valac... ${VALAC}"
	find ${PWD} -name ${file} -type f \
		-exec sed -i "\:VALAC:{s:$(type -P true):${VALAC}:g}" {} \;

	for name in ${vala_names}; do
		unset ${name}
	done
	unset -v set_valac
}

fi ## End of configure phase.

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
