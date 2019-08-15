# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Ebuild hooks patching system"
HOMEPAGE="https://github.com/shiznix/unity-gentoo"
SRC_URI=""

URELEASE="disco"

LICENSE="GPL-2+"
SLOT="0"
#KEYWORDS="~amd64 ~x86"

IUSE="audacity_menu eog_menu evince_menu gnome-screenshot_adjust gnome-terminal_theme libreoffice_theme nemo_noroot pidgin_chat totem_menu zim_theme"

DEPEND=""

S=${WORKDIR}

EHOOK_UPDATE=()

src_install() {
	dosym "$(/usr/bin/portageq get_repo_path / unity-gentoo)"/ehooks_check.sh /usr/bin/ehooks
}

pkg_preinst() {
	local \
		count=1 \
		sys_db="/var/db/pkg/" \
		repo_dir pkg_flag sys_flag x m n slot prev_shopt

	local -a \
		ehk=() pkg=() \
		indicator=( "|" "/" "-" "\\" )

	printf "%s" "Looking for USE-flag changes ${indicator[0]}"

	repo_dir="$(/usr/bin/portageq get_repo_path / unity-gentoo)"

	for x in ${IUSE}; do
		## Progress indicator.
		[[ ${count} -eq 4 ]] && count=0
		printf "\b\b %s" "${indicator[${count}]}"
		count=$((count + 1))

		## Try another USE-flag if there is no change.
		use "${x}" && pkg_flag=1 || pkg_flag=0
		portageq has_version / unity-extra/ehooks["${x}"] && sys_flag=1 || sys_flag=0
		[[ ${pkg_flag} -eq ${sys_flag} ]] && continue

		## Get ebuild hooks containing recently changed USE-flag.
		prev_shopt=$(shopt -p nullglob)
		shopt -s nullglob
		ehk=( $(fgrep -l "${x}" "${repo_dir}"/profiles/releases/"${URELEASE}"/ehooks/*/*/*.ehook) )
		${prev_shopt}

		for m in "${ehk[@]}"; do
			## Get ${CATEGORY}/{${P}-${PR},${P},${P%.*},${P%.*.*},${PN}} from ebuild hook's path.
			m=${m%/*.ehook}
			m=${m#*/ehooks/}
			## Get ${SLOT}.
			[[ ${m} == *":"+([0-9.]) ]] && slot="${m#*:}" || slot=""
			m="${m%:*}"

			## Get installed packages affected by the ebuild hook.
			prev_shopt=$(shopt -p nullglob) ## don't use extglob
			shopt -s nullglob
			[[ -d ${sys_db}${m} ]] && pkg=( "${sys_db}${m}" ) || pkg=( "${sys_db}${m}"{-[0-9],.[0-9],-r[0-9]}*/ )
			${prev_shopt}

			for n in "${pkg[@]}"; do
				## Try another package if slots differ.
				[[ -z ${slot} ]] || fgrep -qsx "${slot}" "${n}/SLOT" || continue

				## Get =${CATEGORY}/${PF} from package's ${sys_db} path.
				n="${n%/}"
				n="${n#${sys_db}}"
				EHOOK_UPDATE+=( "=${n}" )
			done
		done
	done

	printf "\b\b%s\n" "... done!"
}

pkg_postinst() {
	echo
	if [[ -n ${EHOOK_UPDATE[@]} ]]; then
		## Remove duplicates.
		EHOOK_UPDATE=( $(printf "%s\n" "${EHOOK_UPDATE[@]}" | sort -u) )

		ewarn "Rebuild the packages affected by the USE-flag changes:"
		ewarn "emerge -1 ${EHOOK_UPDATE[@]}"
	else
		einfo "No rebuild needed"
	fi

	if [[ -d /etc/portage/ehooks ]]; then
		echo
		echo " * Note: You can safely remove '/etc/portage/ehooks' directory as it's not used anymore"
	fi
	echo
}
