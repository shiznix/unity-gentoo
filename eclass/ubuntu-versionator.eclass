# @ECLASS: ubuntu-versionator.eclass
# @MAINTAINER:
# Rick Harris <rickfharris@yahoo.com.au>
# @BLURB: Eclass to turn the example of package-version_p0_p0302 into 0ubuntu3.2
# @DESCRIPTION:
# This eclass simplifies manipulating $PVR for the purpose of creating
#  <patchlevel>ubuntu<revision> strings for Ubuntu based SRC_URIs

## Naming convention examples ##
# 0ubuntu0.12.10.3		= package-3.6.0_p0_p00121003
# 0ubuntu0.13.04.3		= package-3.6.0_p0_p00130403
# 0ubuntu3.2			= package-3.6.0_p0_p0302
# 1ubuntu5			= package-3.6.0_p1_p05
# 0ubuntu6			= package-3.6.0_p0_p06
# +14.10.20140915-1ubuntu2.2	= package-3.6.0_p1_p0202_p20140915 (14.10 is the Ubuntu release version taken from URELEASE)
#
## When upgrading <revision> from a floating point to a whole number, portage will see the upgrade as a downgrade ##
# Example: package-3.6.0_p0_p0101 (0ubuntu1.1) to package-3.6.0_p0_p02 (0ubuntu2)
# If this occurs, the ebuild should be named package-3.6.0a_p0_p02


EXPORT_FUNCTIONS pkg_setup pkg_postinst

#---------------------------------------------------------------------------------------------------------------------------------#
### GLOBAL ECLASS INHERIT DEFAULTS ##

## distutils-r1.eclass ##
# Set this to catch future parallel build problems, parallel builds give us no real benefit for our tiny python packages #
export DISTUTILS_NO_PARALLEL_BUILD=1

## vala.eclass ##
# Set base sane vala version for all packages requiring vala, override in ebuild if or when specific higher versions are needed #
export VALA_MIN_API_VERSION=${VALA_MIN_API_VERSION:=0.20}
export VALA_MAX_API_VERSION=${VALA_MAX_API_VERSION:=0.20}
export VALA_USE_DEPEND="vapigen"
#---------------------------------------------------------------------------------------------------------------------------------#


[[ "${URELEASE}" == *trusty* ]] && UVER_RELEASE="14.04"
[[ "${URELEASE}" == *utopic* ]] && UVER_RELEASE="14.10"


PV="${PV%%[a-z]_p*}"	# For package-3.6.0a_p0_p02
PV="${PV%%[a-z]*}"	# For package-3.6.0a
PV="${PV%%_p*}"		# For package-3.6.0_p0_p02
PV="${PV%%_*}"		# For package-3.6.0_p_p02

MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

OIFS="${IFS}"
IFS=p; read -ra PVR_ARRAY <<< "${PVR}"
IFS="${OIFS}"

PVR_PL_MAJOR="${PVR_ARRAY[1]}"
PVR_PL_MAJOR="${PVR_PL_MAJOR%*_}"	# Major

PVR_PL="${PVR_ARRAY[2]}"
PVR_PL="${PVR_PL%*_}"			# Minor
PVR_PL="${PVR_PL%%-r*}"		# Strip revision strings

PVR_MICRO="${PVR_ARRAY[3]}"
PVR_MICRO="${PVR_MICRO%*_}"		# Micro
PVR_MICRO="${PVR_MICRO%%-r*}"	# Strip revision strings

char=2
index=1
strlength="${#PVR_PL}"
while [ "${PVR_PL}" != "" ]; do
	strtmp="${PVR_PL:0:$char}"
	if [ "${strlength}" -ge 6 ]; then	# Don't strip zeros from 3rd number field, this is the Ubuntu OS release #
		if [ "${index}" != 3 ]; then
			strtmp="${strtmp#0}"
		fi
	else
		strtmp="${strtmp#0}"
	fi
	strarray+=( "${strtmp}" )
	PVR_PL="${PVR_PL:$char}"
	((index++))
done

PVR_PL_MINOR="${strarray[@]}"
PVR_PL_MINOR="${PVR_PL_MINOR// /.}"

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
        # unity-base/unity-build-env creates symlinks to /etc/portage/package.*
        #   This allows masking category/package::gentoo and overriding IUSE in /etc/portage/make.conf, which cannot be done in profiles/
        #   Using profiles/ also sets a sane base set of USE flags by all profiles inheriting the Gentoo 'desktop' profile

        if [ -z "${UNITY_BUILD_OK}" ]; then     # Creates a oneshot so it only checks on the 1st package in the emerge list
                CURRENT_PROFILE=$(eselect --brief profile show)

                if [ -z "$(echo ${CURRENT_PROFILE} | grep unity-gentoo)" ]; then
                        die "Invalid profile detected, please select a 'unity-gentoo' profile for your architecture shown in 'eselect profile list'"
                else
                        PROFILE_RELEASE=$(echo "${CURRENT_PROFILE}" | sed -n 's/.*:\(.*\)\/.*/\1/p')
                fi

                has_version unity-base/unity-build-env:0/${PROFILE_RELEASE} || \
			die "'${PROFILE_RELEASE}' profile detected, please run 'emerge unity-base/unity-build-env:0/${PROFILE_RELEASE}' to setup package masking"
                export UNITY_BUILD_OK=1
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
