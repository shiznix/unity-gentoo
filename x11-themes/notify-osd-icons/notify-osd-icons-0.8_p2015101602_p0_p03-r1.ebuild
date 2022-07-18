# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URELEASE="jammy"
inherit ubuntu-versionator

UVER_PREFIX="+15.10.${PVR_MICRO}"

DESCRIPTION="Icons for on-screen-display notification agent"
HOMEPAGE="http://launchpad.net/notify-osd"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/notify-osd"
DEPEND="media-gfx/scour"

RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"

src_install() {
	emake DESTDIR="${D}" install || die

	# Source: debian/notify-osd-icons.links
	local path=/usr/share/notify-osd/icons/Humanity/scalable/status
	dosym notification-battery-000.svg ${path}/notification-battery-empty.svg
	dosym notification-battery-020.svg ${path}/notification-battery-low.svg

	# Optimize SVG files
	for f in "${ED}${path}"/*.svg; do
		[[ -f ${f} ]] && scour -i "${f}" -o "${f}.tmp" && mv "${f}.tmp" "${f}" || rm "${f}.tmp"
	done
}
