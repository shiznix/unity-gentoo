# @ECLASS: ubuntu-versionator.eclass
# @MAINTAINER:
# Rick Harris <rickfharris@yahoo.com.au>
# @BLURB: Eclass to turn the example of package-version_p0_p0302 into 0ubuntu3.2
# @DESCRIPTION:
# This eclass simplifies manipulating $PVR for the purpose of creating
#  <patchlevel>ubuntu<revision> strings for Ubuntu based SRC_URIs

## Naming convention examples ##
# 0ubuntu0.12.10.3		= package-3.6.0_p_p0_p00121003
# 0ubuntu0.13.04.3		= package-3.6.0_p_p0_p00130403
# 0ubuntu3.2			= package-3.6.0_p_p0_p0302
# 1ubuntu5			= package-3.6.0_p_p1_p05
# 0ubuntu6			= package-3.6.0_p_p0_p06
# +14.10.20140915-1ubuntu2.2	= package-3.6.0_p20140915_p1_p0202 (14.10 is the Ubuntu release version taken from URELEASE)
#
## When upgrading <revision> from a floating point to a whole number, portage will see the upgrade as a downgrade ##
# Example: package-3.6.0_p_p0_p0101 (0ubuntu1.1) to package-3.6.0_p_p0_p02 (0ubuntu2)
# If this occurs, the ebuild should be named package-3.6.0a_p0_p02


inherit toolchain-funcs
EXPORT_FUNCTIONS pkg_setup pkg_postinst

#---------------------------------------------------------------------------------------------------------------------------------#
### GLOBAL ECLASS INHERIT DEFAULTS ##

## vala.eclass ##
# Set base sane vala version for all packages requiring vala, override in ebuild if or when specific higher versions are needed #
export VALA_MIN_API_VERSION=${VALA_MIN_API_VERSION:=0.32}	# Needs to be >=${minimal_supported_minor_version} from vala.eclass
export VALA_MAX_API_VERSION=${VALA_MAX_API_VERSION:=0.32}
export VALA_USE_DEPEND="vapigen"
#---------------------------------------------------------------------------------------------------------------------------------#

[[ "${URELEASE}" == *trusty* ]] && UVER_RELEASE="14.04"
[[ "${URELEASE}" == *utopic* ]] && UVER_RELEASE="14.10"
[[ "${URELEASE}" == *vivid* ]] && UVER_RELEASE="15.04"
[[ "${URELEASE}" == *wily* ]] && UVER_RELEASE="15.10"
[[ "${URELEASE}" == *xenial* ]] && UVER_RELEASE="16.04"
[[ "${URELEASE}" == *yakkety* ]] && UVER_RELEASE="16.10"
[[ "${URELEASE}" == *zesty* ]] && UVER_RELEASE="17.04"

PV="${PV%%[a-z]_p*}"	# For package-3.6.0a_p0_p02
PV="${PV%%[a-z]*}"	# For package-3.6.0a
PV="${PV%%_p*}"		# For package-3.6.0_p0_p02
PV="${PV%%_*}"		# For package-3.6.0_p_p02

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

OIFS="${IFS}"
IFS=p; read -ra PVR_ARRAY <<< "${PVR}"
IFS="${OIFS}"

## Micro version field ##
PVR_PL_MICRO="${PVR_ARRAY[1]}"
PVR_PL_MICRO="${PVR_PL_MICRO%*_}"
PVR_PL_MICRO="${PVR_PL_MICRO%%-r*}"     # Strip revision strings
	[[ -n "${strarray[@]}" ]] && unset 'strarray[@]'
		char=2
		index=1
		strlength="${#PVR_PL_MICRO}"
	while [ "${PVR_PL_MICRO}" != "" ]; do
		strtmp="${PVR_PL_MICRO:0:$char}"
		if [ "${strlength}" -ge 10 ]; then      # Last field can be a floating point so strip off leading zero and add decimal point #
			if [ "${index}" = 5 ]; then
				strtmp=".${strtmp#0}"
			fi
		fi
		strarray+=( "${strtmp}" )
		PVR_PL_MICRO="${PVR_PL_MICRO:$char}"
		((index++))
	done
PVR_PL_MICRO_tmp="${strarray[@]}"
PVR_MICRO="${PVR_PL_MICRO_tmp// /}"

## Major version field ##
PVR_PL_MAJOR="${PVR_ARRAY[2]}"
PVR_PL_MAJOR="${PVR_PL_MAJOR%*_}"
# Support floating point version numbers in major version field (eg. libnih-1.0.3_p0403_p01.ebuild becomes libnih-1.0.3-4.3ubuntu1)
if [ "${#PVR_PL_MAJOR}" -gt 1 ]; then
	PVR_PL_MAJOR="${PVR_PL_MAJOR%%-r*}"     # Strip revision strings
		char=2
		index=1
		strlength="${#PVR_PL_MAJOR}"
		while [ "${PVR_PL_MAJOR}" != "" ]; do   # Iterate through all chars loading every 2 chars into an array element
			strtmp="${PVR_PL_MAJOR:0:$char}"
			strtmp="${strtmp#0}"
			strarray+=( "${strtmp}" )
			PVR_PL_MAJOR="${PVR_PL_MAJOR:$char}"
			((index++))
		done
	PVR_PL_MAJOR_tmp="${strarray[@]}"
	PVR_PL_MAJOR="${PVR_PL_MAJOR_tmp// /.}"
fi

## Minor version field ##
PVR_PL_MINOR="${PVR_ARRAY[3]}"
PVR_PL_MINOR="${PVR_PL_MINOR%*_}"
PVR_PL_MINOR="${PVR_PL_MINOR%%-r*}"	# Strip revision strings
	[[ -n "${strarray[@]}" ]] && unset 'strarray[@]'
	char=2
	index=1
	strlength="${#PVR_PL_MINOR}"
	while [ "${PVR_PL_MINOR}" != "" ]; do	# Iterate through all chars loading every 2 chars into an array element
		strtmp="${PVR_PL_MINOR:0:$char}"
		if [ "${strlength}" -ge 6 ]; then	# Don't strip zeros from 3rd number field, this is the Ubuntu OS release #
			if [ "${index}" != 3 ]; then
				strtmp="${strtmp#0}"
			fi
		else
			strtmp="${strtmp#0}"
		fi
		strarray+=( "${strtmp}" )
		PVR_PL_MINOR="${PVR_PL_MINOR:$char}"
		((index++))
	done
PVR_PL_MINOR_tmp="${strarray[@]}"
PVR_PL_MINOR="${PVR_PL_MINOR_tmp// /.}"

if [ "${PN}" = "ubuntu-sources" ]; then
	UVER="${PVR_PL_MAJOR}.${PVR_PL_MINOR}"
else
	UVER="${PVR_PL_MAJOR}ubuntu${PVR_PL_MINOR}"
fi

# @FUNCTION: ubuntu-versionator_pkg_setup
# @DESCRIPTION:
# Check we have a valid profile set and the correct
# masking in place for the overlay to work
ubuntu-versionator_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

        # Use a profile to set things like make.defaults and use.mask only, and to fill $SUBSLOT for unity-base/unity-build-env:0/${SUBSLOT}
        # unity-base/unity-build-env creates symlinks in /etc/portage/package.{keywords,mask,use}/unity-portage.{keywords,mask,use}
	#	pointing to overlay's profiles/<release>/unity-portage.{keywords,mask,use}
        #   This allows masking category/package::gentoo and overriding IUSE in /etc/portage/make.conf, which cannot be done in profiles/
        #   Using profiles/ also sets a sane base set of USE flags by all profiles inheriting the Gentoo 'desktop' profile

        if [ -z "${UNITY_BUILD_OK}" ]; then     # Creates a oneshot so it only checks on the 1st package in the emerge list
		CURRENT_PROFILE=$(readlink /etc/portage/make.profile)

                if [ -z "$(echo ${CURRENT_PROFILE} | grep unity-gentoo)" ]; then
                        die "Invalid profile detected, please select a 'unity-gentoo' profile for your architecture shown in 'eselect profile list'"
                else
			PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | awk -F/ '{print $(NF-1)}')
                fi

                has_version unity-base/unity-build-env:0/${PROFILE_RELEASE} || \
			die "'${PROFILE_RELEASE}' profile detected, please run 'emerge unity-base/unity-build-env:0/${PROFILE_RELEASE}' to setup package masking"
                export UNITY_BUILD_OK=1
        fi

	# Minimum system-wide GCC version required #
	[[ "${PROFILE_RELEASE}" == utopic ]] && GCC_MINIMUM="4.8.5"
	[[ "${PROFILE_RELEASE}" == vivid ]] && GCC_MINIMUM="4.9.4"
	[[ "${PROFILE_RELEASE}" == wily ]] && GCC_MINIMUM="5.4.0"
	[[ "${PROFILE_RELEASE}" == xenial ]] && GCC_MINIMUM="5.4.0"
	[[ "${PROFILE_RELEASE}" == yakkety ]] && GCC_MINIMUM="5.4.0"
	[[ "${PROFILE_RELEASE}" == zesty ]] && GCC_MINIMUM="6.3.0"
	GCC_CURRENT=$(gcc-fullversion)

	[[ ${GCC_CURRENT//./} -lt ${GCC_MINIMUM//./} ]] \
		&& die "The selected '${PROFILE_RELEASE}' profile requires your system be built using >=sys-devel/gcc:${GCC_MINIMUM}, please consult the output of 'gcc-config -l'"

	# Disable ld.gold linker if selected as it causes undefined reference linking failures (see net-libs/ubuntu-download-manager linking with sys-libs/libnih) #
	#	This type of build failure is intended by upstream (see https://sourceware.org/bugzilla/show_bug.cgi?id=10238)
	[[ "$(ld -v | grep gold)" ]] && \
		die "The selected 'ld' library linker must be set to 'ld.bfd' due to link failures using other experimental linkers, as root do 'binutils-config --linker ld.bfd'"
}

# @FUNCTION: ubuntu-versionator_src_prepare
# @DESCRIPTION:
# Apply common src_prepare tasks such as patching
ubuntu-versionator_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	# Apply Ubuntu patchset if one is present #
	[[ -f "${WORKDIR}/debian/patches/series" ]] && UPATCH_DIR="${WORKDIR}/debian/patches"
	[[ -f "debian/patches/series" ]] && UPATCH_DIR="debian/patches"
	if [ -d "${UPATCH_DIR}" ]; then
		for patch in $(grep -v \# "${UPATCH_DIR}/series"); do
			UBUNTU_PATCHES+=( "${UPATCH_DIR}/${patch}" )
		done
		[[ ${UBUNTU_PATCHES[@]} ]] && einfo "  <-- Ubuntu patchset -->"
	fi
	# Many eclasses (cmake-utils,distutils-r1,qt5-build,xdg) apply their own 'default' command for EAPI=6 or 'epatch ${PATCHES[@]}' command for EAPI <6 so let them #
	#	'declare' checks to see if any of those functions are set/inherited and only apply 'default' if they are not
	if [ "${EAPI}" -ge 6 ]; then
		[[ ${UBUNTU_PATCHES[@]} ]] && eapply "${UBUNTU_PATCHES[@]}"
		[[ $(declare -Ff cmake-utils_src_prepare) ]] || \
		[[ $(declare -Ff distutils-r1_src_prepare) ]] || \
		[[ $(declare -Ff qt5-build_src_prepare) ]] || \
		[[ $(declare -Ff xdg_src_prepare) ]] || \
			default
	else
		[[ ${UBUNTU_PATCHES[@]} ]] && epatch "${UBUNTU_PATCHES[@]}"
		# Only apply base_src_prepare if EAPI<6 and have inherited base.eclass #
		# 	(use 'base' eclass while 'autotools-{multilib,utils}','gnome2','kde-4','qt4-r2','readme.gentoo','xorg-2(autotools-utils)' block EAPI6 upgrade) #
		[[ $(declare -Ff base_src_prepare) ]] && \
			base_src_prepare
	fi
}

# @FUNCTION: ubuntu-versionator_pkg_postinst
# @DESCRIPTION:
# Re-create bamf.index and trigger re-profile of ureadahead if installed
ubuntu-versionator_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	## Create a new bamf-2.index file at postinst stage of every package to capture all *.desktop files ##
	if [[ -x /usr/bin/bamf-index-create ]]; then
		einfo "Checking bamf-2.index"
			/usr/bin/bamf-index-create triggered
	fi

	## If sys-apps/ureadahead is installed, force re-profiling of ureadahead's database at next boot ##
	if [[ -n "$(systemctl list-unit-files --no-pager | grep ureadahead)" ]] && \
		[[ "$(systemctl is-enabled ureadahead-collect.service)" = "enabled" ]]; then
			if [[ -w /var/lib/ureadahead/pack ]] && \
				[[ -d "${ED}etc" ]]; then
					elog "Ureadahead will be reprofiled on next reboot"
						rm -f /var/lib/ureadahead/pack /var/lib/ureadahead/*.pack 2> /dev/null
			fi
	fi
}
