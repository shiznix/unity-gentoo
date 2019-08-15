EBUILD HOOKS

* Patching system looking for existence of {pre,post}_${EBUILD_PHASE_FUNC}.ehook
  and run it to perform ebuild hook. Mimic the function of eapply_user
  and /etc/portage/patches/ so we can custom patch packages we don't need
  to maintain. Loosly based on eapply_user function from /usr/lib/portage/python*/phase-helpers.sh
  and https://wiki.gentoo.org/wiki//etc/portage/patches#Enabling_.2Fetc.2Fportage.2Fpatches_for_all_ebuilds.

* Ebuild hooks are located in basedir=/var/lib/layman/unity-gentoo/profiles/releases/${PROFILE_RELEASE}/ehooks directory

* Optional ebuild hooks are managed via unity-extra/ehooks USE-flags
  and ehook_use and ehook_require query functions (see below)

* Updates or changes are managed via /usr/bin/ehooks.
  /usr/bin/ehooks is a symlink to /var/lib/layman/unity-gentoo/ehooks_check.sh script.
  It looks for ebuild hooks changes and generates emerge command needed to apply the changes.
	- usage:
		ehooks [OPTION]
	- options:
		-c, --check	generate emerge command when changes found
		-r, --reset	set ebuild hooks changes as applied (reset modification time)

* Package's ebuild hooks search order:
  e.g. package app-arch/file-roller-3.22.3-r0:0
	 1) ${basedir}/app-arch/file-roller-3.22.3-r0:0
	 2) ${basedir}/app-arch/file-roller-3.22.3-r0
	 3) ${basedir}/app-arch/file-roller-3.22.3:0
	 4) ${basedir}/app-arch/file-roller-3.22.3
	 5) ${basedir}/app-arch/file-roller-3.22:0
	 6) ${basedir}/app-arch/file-roller-3.22
	 7) ${basedir}/app-arch/file-roller-3:0
	 8) ${basedir}/app-arch/file-roller-3
	 9) ${basedir}/app-arch/file-roller:0
	10) ${basedir}/app-arch/file-roller
	- empty pkgdir EXCLUDES package

* File format to trigger ebuild hook:
	{pre,post}_${EBUILD_PHASE_FUNC}.ehook
	1)  pre_pkg_setup.ehook
	2)  post_pkg_setup.ehook
	3)  pre_src_unpack.ehook
	4)  post_src_unpack.ehook
	5)  pre_src_prepare.ehook
	6)  post_src_prepare.ehook
	7)  pre_src_configure.ehook
	8)  post_src_configure.ehook
	9)  pre_src_compile.ehook
	10) post_src_compile.ehook
	11) pre_src_install.ehook
	12) post_src_install.ehook
	13) pre_pkg_preinst.ehook
	14) post_pkg_preinst.ehook
	15) pre_pkg_postinst.ehook
	16) post_pkg_postinst.ehook
	- it's possible to use more files in one phase:
		01-pre_pkg_setup.ehook
		02-pre_pkg_setup.ehook (e.g. symlink to ../templates/ca-pre_pkg_setup.ehook)
	- it's possible to use filename prefix and sort it for better overview:
		[...anything...]pre_src_prepare.ehook
		01_pre_src_prepare.ehook
		aa-pre_src_prepare.ehook

* File body:
	ebuild_hook() {
		[COMMANDS...]
	}
	- templates are in .../ehooks/templates directory
	- command to apply patches in 'prepare' phase:
		eapply "${EHOOK_FILESDIR}"
	- command to trigger eautoreconf in pre_src_prepare phase:
		eautoreconf
	- and in post_src_prepare phase:
		AT_NOELIBTOOLIZE="yes" eautoreconf
	- it's possible to use any ebuild functions
	- errors log is located at ${T}/ehook.log

* ${EHOOK_FILESDIR}
	- path to ${pkgdir}/files
	- used for patches and miscellaneous files

* Patch file format:
	- extensions: *.patch or *.diff
	- use filename prefix to control apply order

* Query functions:
	ehook_use [USE-flag]
	- it returns a true value if unity-extra/ehooks USE-flag is declared
	- e.g. if ehook_use nemo_noroot; then...
	  see gnome-extra/nemo 02-pre_src_prepare.ehook

	ehook_require [USE-flag]
	- it skips the rest of the related ebuild hooks if unity-extra/ehooks USE-flag is not declared
	- it should be the first command of ebuild hooks
	- e.g. ehook_require gnome-terminal_theme
	  see x11-terms/gnome-terminal 01-post_src_prepare.ehook
	    and x11-libs/vte:2.91 01-pre_src_prepare.ehook
