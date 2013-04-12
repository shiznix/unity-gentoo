EAPI="4"

inherit ubuntu-versionator

DESCRIPTION="Language translations pack for Unity desktop"
HOMEPAGE="https://translations.launchpad.net/ubuntu"

UURL="http://archive.ubuntu.com/ubuntu/pool/main/l"
UVER="+20130321"
URELEASE="raring"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

# Soft blocks to resolve file collisions #
# Remove these package versions and blocks at next version bump #
RDEPEND="!<unity-base/compiz-0.9.8.6_p0_p01-r1
	!<unity-base/unity-6.12.0_p0_p01-r1
	!<unity-lenses/unity-lens-photos-0.9_p0_p01-r1"
DEPEND="sys-devel/gettext"

## Only languages that are listed in /usr/portage/profiles/desc/linguas.desc are supported ##
IUSE_LINGUAS="aa af ak am an ar as ast az be be@latin bem ber
bg bn bo br bs ca ca@valencia crh cs csb cv cy da de dv dz el
en en_AU en_CA en_GB en@shaw en_US en_US@piglatin eo es et eu
fa fi fil fo fr fur fy ga gd gl gu gv ha he hi hr ht hu hy ia
id ig is it ja jv ka kk kl km kn ko kok ks ku kw ky la lb lg
li lo lt lv mai mg mhr mi mk ml mn mr ms mt my nan nb nds
nds@NFE ne nl nn no nso oc om or os pa pap pl ps pt pt_BR rm
ro ru rw sa sc sco sd se shs si sk sl sn so sq sr sr@ije
sr@latin sr@Latn st sv sw ta te tg th ti tk tl tr ts tt ug uk
ur uz uz@cyrillic uz@Latn ve vi wa wae wo xh yi yo zh zu"

## Only languages that are listed in /usr/portage/profiles/desc/linguas.desc are supported ##
TARBALL_LANGS="aa af am an ar as ast az be bem ber bg bn bo
br bs ca crh cs csb cv cy da de dv dz el en eo es et eu fa fi
fil fo fr fur fy ga gd gl gu gv ha he hi hr ht hu hy ia id ig
is it ja ka kk kl km kn ko ks ku kw ky lb lg li lo lt lv mai
mg mhr mi mk ml mn mr ms mt my nan nb nds ne nl nn nso oc om
or os pa pap pl ps pt ro ru rw sa sc sd se shs si sk sl so sq
sr st sv sw ta te tg th ti tk tl tr ts tt ug uk ur uz ve vi
wa wae wo xh yi yo zu"

## Track older tarball packs that upstream haven't updated ##
TARBALL_LANGS_OLD="ak-base_8.04+20080527 jv-base_8.04+20080527
kok-base_8.04+20080527 la-base_12.04+20130128
no-base_8.04+20080527 rm-base_8.04+20080527
sco-base_8.04+20080527 zh-base_10.04+20091212"

for MY_LINGUA in ${IUSE_LINGUAS}; do
	IUSE+=" linguas_${MY_LINGUA}"
done

## CAUTION: Be sure to enable *all* LINGUAS in /etc/make.conf when creating Manifest ##
for TARBALL_LANG in ${TARBALL_LANGS}; do
	if has ${TARBALL_LANG} ${LINGUAS}; then
		SRC_URI_array+=( linguas_${TARBALL_LANG}? \( ${UURL}/language-pack-gnome-${TARBALL_LANG}-base/language-pack-gnome-${TARBALL_LANG}-base_${PV}${UVER}.tar.gz \) )
	fi
done
for TARBALL_LANG in ${TARBALL_LANGS_OLD}; do
	LANG=${TARBALL_LANG%%-*}
        if has ${LANG} ${LINGUAS}; then
		SRC_URI_array+=( linguas_${LANG}? \( ${UURL}/language-pack-gnome-${LANG}-base/language-pack-gnome-${TARBALL_LANG}.tar.gz \) )
        fi
done

SRC_URI="${SRC_URI_array[@]}"
S="${WORKDIR}"

src_prepare() {
	if [ -z "${LINGUAS}" ]; then
		die "At least one LINGUA must be set in /etc/make.conf"
	fi
}

src_install() {
	einfo "Installing language files for the following LINGUAS: ${LINGUAS}"
	for TARBALL_LANG in ${TARBALL_LANGS}; do
		if has ${TARBALL_LANG} ${LINGUAS}; then
			for SUB_LANG in `find "${WORKDIR}/language-pack-gnome-${TARBALL_LANG}-base/data" -maxdepth 1 -type d | awk -Fdata/ '{print $2}'`; do
				# Remove all translations except those we need #
				find language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG} \
					-type f \! -iname '*activity-log-manager*' \
					-type f \! -iname '*compiz*' \
					-type f \! -iname '*ccsm*' \
					-type f \! -iname '*credentials-control-center*' \
					-type f \! -iname '*indicator-*' \
					-type f \! -iname '*libdbusmenu*' \
					-type f \! -iname '*signon*' \
					-type f \! -iname '*unity*' \
						-delete || die

				if has ${SUB_LANG} ${LINGUAS}; then
					for pofile in `find "${WORKDIR}/language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG}/LC_MESSAGES/" -type f -name "*.po"`; do
						msgfmt -o ${pofile%%.po}.mo ${pofile}
						rm ${pofile}
					done
					insinto /usr/share/locale
					doins -r language-pack-gnome-${TARBALL_LANG}-base/data/${SUB_LANG}
				fi
			done
		fi
	done
}
