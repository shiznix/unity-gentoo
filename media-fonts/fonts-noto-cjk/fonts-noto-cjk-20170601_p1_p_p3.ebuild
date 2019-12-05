# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
URELEASE="cosmic"
inherit font ubuntu-versionator

UURL="mirror://unity/pool/main/f/${PN}"

DESCRIPTION="No Tofu font families with large Unicode coverage"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-cjk"

UVER_PREFIX="+repack${PVR_MICRO}"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.xz
	${UURL}/${MY_P}${UVER_PREFIX}-${PVR_PL_MINOR}.debian.tar.xz"

## conf source ##
LSVER="0.190" ## language-selector package version
SRC_URI+="${UURL/\/f\/${PN}}/l/language-selector/language-selector_${LSVER}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extra"

RESTRICT="mirror binchecks strip"

RDEPEND="!media-fonts/noto-cjk"

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="ttc"
FONT_CONF=(
	"${WORKDIR}"/debian/70-"${PN}".conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/30-cjk-aliases.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/64-language-selector-prefer.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/69-language-selector-ja.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/69-language-selector-zh-cn.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/69-language-selector-zh-hk.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/69-language-selector-zh-mo.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/69-language-selector-zh-sg.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/69-language-selector-zh-tw.conf
	"${WORKDIR}"/language-selector-${LSVER}/fontconfig/99-language-selector-zh.conf
)

src_install() {
	! use extra find "${WORKDIR}" -type f -name "*.ttc" \
		! -name "*CJK-Regular.ttc" \
		! -name "*CJK-Bold.ttc" \
			-delete

	font_src_install

	local \
		f \
		symlink_dir="/etc/fonts/conf.d"

	einfo "Creating fontconfig configuration symlinks ..."
	dodir "${symlink_dir}"
	for f in "${ED%/}"/etc/fonts/conf.avail/*; do
		f=${f##*/}
		echo " * ${f}"
		dosym "../conf.avail/${f}" "${symlink_dir}/${f}"
	done

	dodoc debian/copyright
}
