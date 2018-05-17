if [[ ${EBUILD_PHASE} == "setup" ]] ; then
	CURRENT_PROFILE="$(readlink /etc/portage/make.profile)"
	PROFILE_DESC="/etc/portage/${CURRENT_PROFILE%%profiles*}/profiles/profiles.desc"
	PROFILE_NAME="${CURRENT_PROFILE#*profiles}"
	PROFILE_NAME="${PROFILE_NAME#"/"}"

	if [ -z "$(echo ${CURRENT_PROFILE} | grep unity-gentoo)" ]; then
		die "Invalid profile detected, please select a 'unity-gentoo' profile for your architecture shown in 'eselect profile list'"
	else
		PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | awk -F/ '{print $(NF-0)}')
	fi

	while read -r line; do
	        [[ "$line" =~ ^#.*$ ]] && continue
		[[ -z "$line" ]] && continue

		name=$(echo "${line}" | awk -F' ' '{print $(NF-1)}')
		edition=$(echo "${line}" | awk -F' ' '{print $(NF-0)}')
		if [[ "${PROFILE_NAME}" == "${name}" ]]; then
			if [[ "${edition}" == "dev" ]]; then
				if [ "$(eval echo \${UNITY_DEVELOPMENT_${PROFILE_RELEASE}})" != "yes" ]; then
					die "Oops! A development profile has been detected. Set 'UNITY_DEVELOPMENT_${PROFILE_RELEASE}=yes' in make.conf if you really know how broken this profile could be"
				fi
			fi
			if [[ "${edition}" == "exp" ]]; then
					if [ "$(eval echo \${UNITY_EXPERIMENTAL_PROFILE_${PROFILE_RELEASE}})" != "yes" ]; then
						die "Oops! A experimental profile has been detected. Set 'UNITY_EXPERIMENTAL_PROFILE_${PROFILE_RELEASE}=yes' in make.conf if you really know what you are doing!\nHave also a look at: https://www.gentoo.org/support/news-items/2017-12-26-experimental-amd64-17-1-profiles.html"
					fi
			fi
		fi
	done < "$PROFILE_DESC"

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

	## Look for existence of {pre,post}_${EBUILD_PHASE_FUNC}.ehook
	##   and run it to perform ebuild hook. Mimic the function
	##   of eapply_user and /etc/portage/patches/ so we can custom
	##   patch packages we don't need to maintain. Loosly based
	##   on eapply_user function from
	##   /usr/lib/portage/python*/phase-helpers.sh and
	##   https://wiki.gentoo.org/wiki//etc/portage/patches#Enabling_.2Fetc.2Fportage.2Fpatches_for_all_ebuilds.

	local -a EHOOK_SOURCE=()

	## Define function to look for ebuild hooks in setup phase.
	pre_pkg_setup() {

	local \
		basedir pkg \
		repodir=$(/usr/bin/portageq get_repo_path / unity-gentoo) \
		optdir=${PORTAGE_CONFIGROOT%/}/etc/portage/ehooks
	local -a basedirs=(
		"${repodir}"/profiles/releases/${PROFILE_RELEASE}/ehooks
		"${optdir}"
	)

	for pkg in ${CATEGORY}/{${P}-${PR},${P},${P%.*},${P%.*.*},${PN}}{,:${SLOT%/*}}; do
		for basedir in "${basedirs[@]}"; do
			if [[ -d ${basedir}/${pkg} ]]; then
				## Skip if source from ${optdir} not enabled.
				if [[ ${basedir} == ${optdir} ]]; then
					[[ -e ${optdir}/conf.d/${pkg%/*}@${pkg##*/} ]] \
						|| break 2
				fi

				local prev_shopt=$(shopt -p nullglob)

				shopt -s nullglob
				EHOOK_SOURCE=( "${basedir}/${pkg}"/*.ehook )
				${prev_shopt}
				break 2
			fi
		done
	done

	## Process EHOOK_SOURCE.
	if [[ -n ${EHOOK_SOURCE[@]} ]]; then

	declare -F apply_ehook 1>/dev/null \
		&& die "apply_ehook: function name collision"

	## Define function to apply ebuild hook.
	apply_ehook() {
		local \
			x \
			log="${T}/ehook.log" \
			COLOR_NORM=$(tput sgr0) \
			COLOR_BOLD=$(tput bold)

		declare -F ebuild_hook 1>/dev/null \
			&& die "ebuild_hook: function name collision"
		for x in "${EHOOK_SOURCE[@]}"; do
			[[ ${x} == *"${FUNCNAME[1]}.ehook" ]] && break
		done
		echo "${COLOR_BOLD}>>> Loading unity-gentoo ebuild hook${COLOR_NORM} from ${x%/*} ..."
		source "${x}" 2>"${log}"
		[[ -s ${log} ]] \
			&& die "$(<${log})"
		declare -F ebuild_hook 1>/dev/null \
			|| die "ebuild_hook: function not found"
		einfo "Processing ${x##*/} ..."

		local EHOOK_FILESDIR=${x%/*}/files

		## Check for eapply and eautoreconf.
		if [[ ${EBUILD_PHASE} == prepare ]]; then

		if declare -f ebuild_hook | grep -q "eapply"; then
			if [[ ${EAPI} -lt 6 ]]; then
				x=${PORTAGE_BIN_PATH%/}/phase-helpers.sh
				[[ -f ${x} ]] \
					|| die "${x}: file not found"
				source <(awk "/^(\t|)eapply\() {\$/ { p = 1 } p { print } /^(\t|)}\$/ { p = 0 }" ${x} 2>/dev/null)
				declare -F eapply 1>/dev/null \
					|| die "eapply: function not found"
			fi
		fi

		if declare -f ebuild_hook | grep -q "eautoreconf"; then
			if ! declare -F eautoreconf 1>/dev/null; then
				x=${PORTDIR%/}/eclass/autotools.eclass
				[[ -f ${x} ]] \
					|| die "${x}: file not found"

				local eautoreconf_names="eautoreconf _at_uses_pkg _at_uses_autoheader _at_uses_automake _at_uses_gettext _at_uses_glibgettext _at_uses_intltool _at_uses_gtkdoc _at_uses_gnomedoc _at_uses_libtool _at_uses_libltdl eaclocal_amflags eaclocal _elibtoolize eautoheader eautoconf eautomake autotools_env_setup autotools_run_tool ALL_AUTOTOOLS_MACROS autotools_check_macro autotools_check_macro_val _autotools_m4dir_include autotools_m4dir_include autotools_m4sysdir_include"

				source <(awk "/^(${eautoreconf_names// /|})(\(\)|=\(\$)/ { p = 1 } p { print } /(^(}|\))|; })\$/ { p = 0 }" ${x} 2>/dev/null)
				declare -F eautoreconf 1>/dev/null \
					|| die "eautoreconf: function not found"
			fi

		fi

		fi ## End of checking for eapply and eautoreconf.

		## Append bug information to 'die' command.
		local \
			bugapnd="eerror \"S: '\${S}'\"" \
			bugmsg="eerror \"${COLOR_BOLD}Please submit ehook bug at ${COLOR_NORM}'https://github.com/shiznix/unity-gentoo/issues'.\"" \
			buglog="eerror \"${COLOR_BOLD}The ehook log is located at ${COLOR_NORM}'${log}'.\""

		source <(declare -f die | sed -e "/${bugapnd}/a ${bugmsg}" -e "/${bugapnd}/a ${buglog}")

		## Output information messages to fd 3 instead of stderr (issue #193).
		local msgfunc_names="einfo einfon ewarn ebegin __eend"

		for x in ${msgfunc_names}; do
			source <(declare -f ${x} | sed "s/\(1>&\)2/\13/")
		done

		## Log errors to screen and logfile via fd 3.
		exec 3>&1
		ebuild_hook 2>&1 >&3 | tee "${log}"

		[[ -s ${log} ]] \
			&& die "$(<${log})"

		## Sanitize.
		exec 3>&-
		source <(declare -f die | sed "/ehook/d")
		for x in ${msgfunc_names}; do
			source <(declare -f ${x} | sed "s/\(1>&\)3/\12/")
		done
		unset -f ebuild_hook
		[[ ${EAPI} -lt 6 ]] && unset -f eapply
		if [[ -n ${eautoreconf_names} ]]; then
			for x in ${eautoreconf_names}; do
				unset ${x}
			done
		fi

		echo "${COLOR_BOLD}>>> Done.${COLOR_NORM}"
	} ## End of apply_ehook function.

	## Apply ebuild hook intended for setup phase.
	[[ ${EHOOK_SOURCE[@]} == *"pre_pkg_setup"* ]] \
		&& apply_ehook
	[[ ${EHOOK_SOURCE[@]} == *"post_pkg_setup"* ]] \
		&& post_pkg_setup() {
			apply_ehook
		}

	fi ## End of processing EHOOK_SOURCE.

	} ## End of pre_pkg_setup function.

fi ## End of setup phase.

## Define appropriate ebuild function to apply ebuild hook.
case ${EBUILD_PHASE} in
	unpack)
		[[ ${EHOOK_SOURCE[@]} == *"pre_src_unpack"* ]] \
			&& pre_src_unpack() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_src_unpack"* ]] \
			&& post_src_unpack() {
				apply_ehook
			}
		;;
	prepare)
		[[ ${EHOOK_SOURCE[@]} == *"pre_src_prepare"* ]] \
			&& pre_src_prepare() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_src_prepare"* ]] \
			&& post_src_prepare() {
				apply_ehook
			}
		;;
	configure)
		[[ ${EHOOK_SOURCE[@]} == *"pre_src_configure"* ]] \
			&& pre_src_configure() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_src_configure"* ]] \
			&& post_src_configure() {
				apply_ehook
			}
		;;
	compile)
		[[ ${EHOOK_SOURCE[@]} == *"pre_src_compile"* ]] \
			&& pre_src_compile() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_src_compile"* ]] \
			&& post_src_compile() {
				apply_ehook
			}
		;;
	install)
		[[ ${EHOOK_SOURCE[@]} == *"pre_src_install"* ]] \
			&& pre_src_install() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_src_install"* ]] \
			&& post_src_install() {
				apply_ehook
			}
		;;
	preinst)
		[[ ${EHOOK_SOURCE[@]} == *"pre_pkg_preinst"* ]] \
			&& pre_pkg_preinst() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_pkg_preinst"* ]] \
			&& post_pkg_preinst() {
				apply_ehook
			}
		;;
	postinst)
		[[ ${EHOOK_SOURCE[@]} == *"pre_pkg_postinst"* ]] \
			&& pre_pkg_postinst() {
				apply_ehook
			}
		[[ ${EHOOK_SOURCE[@]} == *"post_pkg_postinst"* ]] \
			&& post_pkg_postinst() {
				apply_ehook
			}
		;;
esac
