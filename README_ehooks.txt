EBUILD HOOKS

* It's a patching system that looks for existence of {pre,post}_${EBUILD_PHASE_FUNC}.ehook
  and runs it to perform hook. It provides a way to patch packages we don't need to maintain.
  It's loosly based on eapply_user function from /usr/lib/portage/python*/phase-helpers.sh script
  and pre_src_prepare function from https://wiki.gentoo.org/wiki//etc/portage/patches link.

  see profiles/releases/profile.bashrc

* Overlay's ebuild hooks are located
  in /var/lib/layman/unity-gentoo/profiles/releases/${PROFILE_RELEASE}/ehooks directory.

* Optional ebuild hooks are managed via unity-extra/ehooks USE-flags
  and ehook_use and ehook_require query functions (see below).

* Updates or changes are managed via /usr/bin/ehooks. It looks for ebuild
  hooks changes and generates emerge command needed to apply the changes.
  It's a symlink to /var/lib/layman/unity-gentoo/ehooks_check.sh script.

	- usage:
		ehooks [OPTION]
	- options:
		-c, --check	generate emerge command when changes found
		-r, --reset	set changes as applied (reset modification time)

* Directory name and search order:
  - e.g. package app-arch/file-roller-3.22.3-r0:0/0

	 1) app-arch/file-roller-3.22.3-r0:0
	 2) app-arch/file-roller-3.22.3-r0
	 3) app-arch/file-roller-3.22.3:0
	 4) app-arch/file-roller-3.22.3
	 5) app-arch/file-roller-3.22:0
	 6) app-arch/file-roller-3.22
	 7) app-arch/file-roller-3:0
	 8) app-arch/file-roller-3
	 9) app-arch/file-roller:0
	10) app-arch/file-roller

	- empty directory EXCLUDES package

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

	- it's possible to use more files in one phase
	  see net-im/pidgin:
		01-pre_pkg_setup.ehook
		02-pre_pkg_setup.ehook

	- it's possible to use filename prefix and sort it for better overview:
		[...anything...]pre_src_prepare.ehook
		01_pre_src_prepare.ehook
		aa-pre_src_prepare.ehook

* File body:
	ebuild_hook() {
		[COMMANDS...]
	}

	- it's possible to use any ebuild functions

	- templates are in .../ehooks/templates directory
	  the preferred way of using templates are symbolic links:
		ln -s ../../templates/cb-post_pkg_postinst.ehook 04-post_pkg_postinst.ehook

	- command to apply patches in 'prepare' phase:
		eapply "${EHOOK_FILESDIR}"

	- command to trigger 'eautoreconf'
	  in pre_src_prepare phase:
		eautoreconf
	  and in post_src_prepare phase:
		AT_NOELIBTOOLIZE="yes" eautoreconf

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
	- e.g. 'if ehook_use nemo_noroot; then'
	  see gnome-extra/nemo:
		02-pre_src_prepare.ehook

		ebuild_hook() {
			if ehook_use nemo_noroot; then
				sed -i \
					-e "/gboolean show_open_as_root/{s/no_selection_or_one_dir/FALSE/}" \
					src/nemo-view.c || die
				einfo "  Open as Root context menu action removed"
			fi
		}

	ehook_require [USE-flag]
	- it skips the rest of the related ebuild hooks if unity-extra/ehooks USE-flag is not declared
	- it should be the first command of ebuild hooks
	- e.g. 'ehook_require gnome-terminal_theme'
	  see x11-terms/gnome-terminal:
		01-post_src_prepare.ehook
	  and x11-libs/vte:2.91:
		01-pre_src_prepare.ehook

* EHOOK_PATH variable defines the location of additional ebuild hooks. It provides a way
  for users to apply their own ebuild hooks. It's set through /etc/portage/make.conf
  - e.g. EHOOK_PATH="/home/ehooks"

  - own directory OVERRIDES overlay's directory of the same name
  - own empty directory DISABLES overlay's directory of the same name
  - e.g. /home/ehooks/app-arch/file-roller
         overrides or disables
         /var/lib/layman/unity-gentoo/profiles/releases/${PROFILE_RELEASE}/ehooks/app-arch/file-roller
