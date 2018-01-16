Ebuild hooks in /var/lib/layman/unity-gentoo/profiles/releases/${PROFILE_RELEASE}/ehooks
are always applied.
Ebuild hooks in /etc/portage/ehooks are provided by unity-extra/ehooks
and managed by app-eselect/eselect-ehooks.

Basedir search order:
	1) /var/lib/layman/unity-gentoo/profiles/${PROFILE_RELEASE}/ehooks
	2) /etc/portage/ehooks

Pkgdir search order:
e.g. package app-arch/file-roller-3.22.3
	1) ${basedir}/app-arch/file-roller-3.22.3-r0
	2) ${basedir}/app-arch/file-roller-3.22.3
	3) ${basedir}/app-arch/file-roller-3.22
	3) ${basedir}/app-arch/file-roller-3
	4) ${basedir}/app-arch/file-roller
	- all of the above may be optionally followed by a slot:
		${basedir}/app-arch/file-roller-3.22.3-r0:0
		${basedir}/app-arch/file-roller-3.22:0
		${basedir}/app-arch/file-roller:0
	- empty pkgdir excludes package

File format to trigger ebuild hook:
	{pre,post}_${EBUILD_PHASE_FUNC}.ehook
	1) pre_pkg_setup.ehook
	2) post_pkg_setup.ehook
	3) pre_src_unpack.ehook
	4) post_src_unpack.ehook
	5) pre_src_prepare.ehook
	6) post_src_prepare.ehook
	7) pre_src_configure.ehook
	8) post_src_configure.ehook
	9) pre_src_compile.ehook
	10) post_src_compile.ehook
	11) pre_src_install.ehook
	12) post_src_install.ehook
	13) pre_pkg_preinst.ehook
	14) post_pkg_preinst.ehook
	15) pre_pkg_postinst.ehook
	16) post_pkg_postinst.ehook
	- it's possible to use filename prefix and sort it:
		[...]pre_src_prepare.ehook
		01_pre_src_prepare.ehook
		aa-pre_src_prepare.ehook

File body:
	ebuild_hook() {
		[COMMANDS...]
	}
	- templates are in ${basedir}/templates
	- command to apply patches in 'prepare' phase:
		eapply "${EHOOK_FILESDIR}"
	- command to trigger eautoreconf in pre_src_prepare:
		eautoreconf
	- and in post_src_prepare:
		AT_NOELIBTOOLIZE="yes" eautoreconf
	- errors log is located at ${T}/ehook.log

${EHOOK_FILESDIR}
	- path to ${pkgdir}/files
	- used for patches and miscellaneous files

Patch file format:
	- extensions: *.patch or *.diff
	- use filename prefix to control apply order
