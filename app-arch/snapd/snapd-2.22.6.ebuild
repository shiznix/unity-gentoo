# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

URELEASE="yakkety-updates"
inherit autotools systemd ubuntu-versionator

UURL="mirror://unity/pool/main/s/${PN}"
UVER="+${UVER_RELEASE}"

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="https://github.com/snapcore/snapd"
SRC_URI="${UURL}/${MY_P}${UVER}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="dev-lang/go
	dev-libs/glib:2
	dev-python/docutils
	sys-apps/systemd
	sys-fs/squashfs-tools
	sys-libs/libseccomp"

# TODO: ensure that used kernel supports xz compression for squashfs
# TODO: enable tests
# TODO: put /var/lib/snapd/desktop on XDG_DATA_DIRS

S="${WORKDIR}/snappy.upstream/cmd"

src_prepare() {
	ubuntu-versionator_src_prepare

	export GOPATH="${WORKDIR}/${PN}_gobuild"
	go get -v -u github.com/kardianos/govendor
	mkdir -p ${GOPATH}/src/github.com/snapcore/
	cp -arv ../ ${GOPATH}/src/github.com/snapcore/snapd
	pushd ${GOPATH}/src/github.com/snapcore/snapd
		${GOPATH}/bin/govendor sync
	popd

	eautoreconf
}

src_configure() {
	econf \
		--prefix=/usr \
		--libexecdir=/usr/lib/snapd \
		--disable-apparmor \
		--disable-silent-rules
}

src_compile() {
	default
	go install -v github.com/snapcore/snapd/cmd/snap{,d,-exec} || die
}

src_install() {
	default
	exeinto /usr/bin
	dobin "${GOPATH}/bin/snap"
	exeinto /usr/lib/snapd/
	doexe "${GOPATH}/bin/snapd"
	doexe "${GOPATH}/bin/snap-exec"

	# Install systemd units
	sed -i -e 's/RandomizedDelaySec=/#RandomizedDelaySec=/' ../data/systemd/snapd.refresh.timer
	systemd_dounit ../data/systemd/snapd.{service,socket}
	systemd_dounit ../data/systemd/snapd.autoimport.service
	systemd_dounit ../data/systemd/snapd.refresh.{service,timer}
	systemd_dounit ../data/systemd/snapd.system-shutdown.service

	# Put /snap/bin on PATH
	dodir /etc/profile.d/
	echo 'PATH=$PATH:/snap/bin' > ${ED}/etc/profile.d/snapd.sh
	keepdir /snap

	# Delete some files that are only useful on Ubuntu
	rm -rf "${ED}"etc/apparmor.d
}

pkg_postinst() {
	systemctl enable snapd.socket
	systemctl enable snapd.refresh.timer
}

pkg_postrm() {
	systemctl disable snapd.service
	systemctl stop snapd.service
	systemctl disable snapd.socket
	systemctl disable snapd.refresh.timer
}
