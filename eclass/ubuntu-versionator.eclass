# @ECLASS: ubuntu-versionator.eclass
# @MAINTAINER:
# Rick Harris <rickfharris@yahoo.com.au>
# @BLURB: Eclass to turn the example of package-version_p0_p0302 into 0ubuntu3.2
# @DESCRIPTION:
# This eclass simplifies manipulating $PVR for the purpose of creating
#  <patchlevel>ubuntu<revision> strings for Ubuntu based SRC_URIs

## Naming convention examples ##
# 0ubuntu0.12.10.3	= package-3.6.0_p0_p00121003
# 0ubuntu3.2		= package-3.6.0_p0_p0302
# 1ubuntu5		= package-3.6.0_p1_p05
# 0ubuntu6		= package-3.6.0_p0_p06

EXPORT_FUNCTIONS pkg_pretend

PV="${PV%%_p*}"		# Strips off _p0_p0302 from ${PV}
MY_P="${PN}_${PV}"
S="${WORKDIR}/${PN}-${PV}"

PVR_PL_MAJOR="${PVR#*_p}"
PVR_PL_MAJOR="${PVR_PL_MAJOR%_p*}"
PVR_PL="${PVR##*_p}"
PVR_PL="${PVR_PL%%-r*}"

char=2
while [ "${PVR_PL}" != "" ]; do
	strtmp="${PVR_PL:0:$char}"
	strtmp="${strtmp#0}"
	strarray+=( "${strtmp}" )
	PVR_PL="${PVR_PL:$char}"
done

PVR_PL_MINOR="${strarray[@]}"
PVR_PL_MINOR="${PVR_PL_MINOR// /.}"
UVER="${PVR_PL_MAJOR}ubuntu${PVR_PL_MINOR}"

## Check we have the correct masking in place for the overlay to work ##
ubuntu-versionator_pkg_pretend() {
	readlink /etc/portage/package.mask/unity-portage.pmask &> /dev/null || \
		die "Please create symlink 'ln -s /var/lib/layman/unity-gentoo/unity-portage.pmask /etc/portage/package.mask/unity-portage.pmask'"

	grep -r '\*/\*::unity-gentoo' /etc/portage/package.keywords* &> /dev/null || \
		die "Please place '*/*::unity-gentoo' in your package.keywords file"
}
