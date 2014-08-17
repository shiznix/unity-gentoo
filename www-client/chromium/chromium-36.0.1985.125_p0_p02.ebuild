# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} )

CHROMIUM_LANGS="am ar bg bn ca cs da de el en_GB es es_LA et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt_BR pt_PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh_CN zh_TW"

inherit base chromium eutils flag-o-matic multilib multiprocessing pax-utils \
	portability python-any-r1 readme.gentoo toolchain-funcs ubuntu-versionator versionator virtualx

MY_PN="chromium-browser"
MY_P="${MY_PN}_${PV}"

UURL="mirror://ubuntu/pool/universe/c/${MY_PN}"
URELEASE="utopic"

DESCRIPTION="Open-source version of Google Chrome web browser patched for the Unity desktop"
HOMEPAGE="http://chromium.org/"
SRC_URI="https://commondatastorage.googleapis.com/chromium-browser-official/${PN}-${PV}.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz
	test? ( https://commondatastorage.googleapis.com/chromium-browser-official/${PN}-${PV}-testdata.tar.xz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="aura bindist cups gnome gnome-keyring kerberos neon pulseaudio selinux +tcmalloc"
RESTRICT="mirror"

# Native Client binaries are compiled with different set of flags, bug #452066.
QA_FLAGS_IGNORED=".*\.nexe"

# Native Client binaries may be stripped by the build system, which uses the
# right tools for it, bug #469144 .
QA_PRESTRIPPED=".*\.nexe"

RDEPEND=">=app-accessibility/speech-dispatcher-0.8:=
	app-arch/bzip2:=
	app-arch/snappy:=
	cups? (
		dev-libs/libgcrypt:0=
		>=net-print/cups-1.3.11:=
	)
	>=dev-libs/elfutils-0.149
	dev-libs/expat:=
	dev-libs/icu:=
	>=dev-libs/jsoncpp-0.5.0-r1:=
	>=dev-libs/libevent-1.4.13:=
	dev-libs/libxml2:=[icu]
	dev-libs/libxslt:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.14.3:=
	dev-libs/re2:=
	gnome? ( >=gnome-base/gconf-2.24.0:= )
	gnome-keyring? ( gnome-base/libgnome-keyring:= )
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/flac:=
	media-libs/harfbuzz:=[icu(+)]
	media-libs/libexif:=
	>=media-libs/libjpeg-turbo-1.2.0-r1:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.4.0:=
	media-libs/speex:=
	pulseaudio? ( media-sound/pulseaudio:= )
	sys-apps/dbus:=
	sys-apps/pciutils:=
	>=sys-libs/libcap-2.22:=
	sys-libs/zlib:=[minizip]
	virtual/udev
	x11-libs/libdrm
	x11-libs/gtk+:2=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXinerama:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	kerberos? ( virtual/krb5 )
	selinux? ( sec-policy/selinux-chromium )"
DEPEND="${RDEPEND}
	!arm? (
		dev-lang/yasm
	)
	dev-lang/perl
	dev-perl/JSON
	>=dev-util/gperf-3.0.3
	dev-util/ninja
	sys-apps/hwids
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	test? (
		dev-libs/openssl:0
	)"
# For nvidia-drivers blocker, see bug #413637 .
RDEPEND+="
	!=www-client/chromium-9999
	x11-misc/xdg-utils
	virtual/ttf-fonts
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )"

# Python dependencies. The DEPEND part needs to be kept in sync
# with python_check_deps.
DEPEND+=" $(python_gen_any_dep '
	dev-python/simplejson[${PYTHON_USEDEP}]
	test? ( dev-python/pyftpdlib[${PYTHON_USEDEP}] )
')"
python_check_deps() {
	has_version "dev-python/simplejson[${PYTHON_USEDEP}]" && \
		{ ! use test || has_version "dev-python/pyftpdlib[${PYTHON_USEDEP}]"; }
}

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/bitstream-cyberbit
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

Depending on your desktop environment, you may need
to install additional packages to get icons on the Downloads page.

For KDE, the required package is kde-base/oxygen-icons.

For other desktop environments, try one of the following:
- x11-themes/gnome-icon-theme
- x11-themes/tango-icon-theme
"

pkg_setup() {
	ubuntu-versionator_pkg_setup

	if [[ "${SLOT}" == "0" ]]; then
		CHROMIUM_SUFFIX=""
	else
		CHROMIUM_SUFFIX="-${SLOT}"
	fi
	CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser${CHROMIUM_SUFFIX}"

	# Make sure the build system will use the right python, bug #344367.
	python-any-r1_pkg_setup

	chromium_suid_sandbox_check_kernel_config

	if use bindist; then
		elog "bindist enabled: H.264 video support will be disabled."
	else
		elog "bindist disabled: Resulting binaries may not be legal to re-distribute."
	fi
}

src_prepare() {
	# Ubuntu patchset #
	for patch in $(cat "${WORKDIR}/debian/patches/series" | grep -v \# ); do
		PATCHES+=( "${WORKDIR}/debian/patches/${patch}" )
	done
	base_src_prepare

	# if ! use arm; then
	#	mkdir -p out/Release/gen/sdk/toolchain || die
	#	# Do not preserve SELinux context, bug #460892 .
	#	cp -a --no-preserve=context /usr/$(get_libdir)/nacl-toolchain-newlib \
	#		out/Release/gen/sdk/toolchain/linux_x86_newlib || die
	#	touch out/Release/gen/sdk/toolchain/linux_x86_newlib/stamp.untar || die
	# fi

	epatch "${FILESDIR}/${PN}-ffmpeg-r0.patch"

	epatch_user

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py \
		'base/third_party/dmg_fp' \
		'base/third_party/dynamic_annotations' \
		'base/third_party/icu' \
		'base/third_party/nspr' \
		'base/third_party/superfasthash' \
		'base/third_party/symbolize' \
		'base/third_party/valgrind' \
		'base/third_party/xdg_mime' \
		'base/third_party/xdg_user_dirs' \
		'breakpad/src/third_party/curl' \
		'chrome/third_party/mozilla_security_manager' \
		'courgette/third_party' \
		'crypto/third_party/nss' \
		'net/third_party/mozilla_security_manager' \
		'net/third_party/nss' \
		'third_party/WebKit' \
		'third_party/angle' \
		'third_party/brotli' \
		'third_party/cacheinvalidation' \
		'third_party/cld' \
		'third_party/cros_system_api' \
		'third_party/dom_distiller_js' \
		'third_party/ffmpeg' \
		'third_party/flot' \
		'third_party/hunspell' \
		'third_party/iccjpeg' \
		'third_party/icu/icu.isolate' \
		'third_party/jinja2' \
		'third_party/jstemplate' \
		'third_party/khronos' \
		'third_party/leveldatabase' \
		'third_party/libaddressinput' \
		'third_party/libjingle' \
		'third_party/libphonenumber' \
		'third_party/libsrtp' \
		'third_party/libusb' \
		'third_party/libvpx' \
		'third_party/libwebm' \
		'third_party/libxml/chromium' \
		'third_party/libXNVCtrl' \
		'third_party/libyuv' \
		'third_party/lss' \
		'third_party/lzma_sdk' \
		'third_party/markupsafe' \
		'third_party/mesa' \
		'third_party/modp_b64' \
		'third_party/mt19937ar' \
		'third_party/npapi' \
		'third_party/opus' \
		'third_party/ots' \
		'third_party/ply' \
		'third_party/polymer' \
		'third_party/protobuf' \
		'third_party/pywebsocket' \
		'third_party/qcms' \
		'third_party/readability' \
		'third_party/sfntly' \
		'third_party/skia' \
		'third_party/smhasher' \
		'third_party/sqlite' \
		'third_party/tcmalloc' \
		'third_party/tlslite' \
		'third_party/trace-viewer' \
		'third_party/undoview' \
		'third_party/usrsctp' \
		'third_party/webdriver' \
		'third_party/webrtc' \
		'third_party/widevine' \
		'third_party/x86inc' \
		'third_party/zlib/google' \
		'url/third_party/mozilla' \
		'v8/src/third_party/valgrind' \
		--do-remove || die
}

src_configure() {
	local myconf=""

	# Never tell the build system to "enable" SSE2, it has a few unexpected
	# additions, bug #336871.
	myconf+=" -Ddisable_sse2=1"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf+=" -Ddisable_nacl=1"

	# Disable glibc Native Client toolchain, we don't need it (bug #417019).
	# myconf+=" -Ddisable_glibc=1"

	# TODO: also build with pnacl
	# myconf+=" -Ddisable_pnacl=1"

	# It would be awkward for us to tar the toolchain and get it untarred again
	# during the build.
	# myconf+=" -Ddisable_newlib_untar=1"

	# Make it possible to remove third_party/adobe.
	echo > "${T}/flapper_version.h" || die
	myconf+=" -Dflapper_version_h_file=${T}/flapper_version.h"

	# Use system-provided libraries.
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_libsrtp (bug #459932).
	# TODO: use_system_libvpx (http://crbug.com/347823).
	# TODO: use_system_libusb (http://crbug.com/266149).
	# TODO: use_system_opus (https://code.google.com/p/webrtc/issues/detail?id=3077).
	# TODO: use_system_protobuf (bug #503084).
	# TODO: use_system_ssl (http://crbug.com/58087).
	# TODO: use_system_sqlite (http://crbug.com/22208).
	myconf+="
		-Duse_system_bzip2=1
		-Duse_system_flac=1
		-Duse_system_harfbuzz=1
		-Duse_system_icu=1
		-Duse_system_jsoncpp=1
		-Duse_system_libevent=1
		-Duse_system_libjpeg=1
		-Duse_system_libpng=1
		-Duse_system_libwebp=1
		-Duse_system_libxml=1
		-Duse_system_libxslt=1
		-Duse_system_minizip=1
		-Duse_system_nspr=1
		-Duse_system_openssl=1
		-Duse_system_re2=1
		-Duse_system_snappy=1
		-Duse_system_speex=1
		-Duse_system_xdg_utils=1
		-Duse_system_zlib=1"

	# Needed for system icu - we don't need additional data files.
	myconf+=" -Dicu_use_data_file_flag=0"

	# TODO: patch gyp so that this arm conditional is not needed.
	if ! use arm; then
		myconf+="
			-Duse_system_yasm=1"
	fi

	# Optional dependencies.
	# TODO: linux_link_kerberos, bug #381289.
	myconf+="
		$(gyp_use cups)
		$(gyp_use gnome use_gconf)
		$(gyp_use gnome-keyring use_gnome_keyring)
		$(gyp_use gnome-keyring linux_link_gnome_keyring)
		$(gyp_use kerberos)
		$(gyp_use pulseaudio)
		$(gyp_use tcmalloc use_allocator tcmalloc none)"

	# Use explicit library dependencies instead of dlopen.
	# This makes breakages easier to detect by revdep-rebuild.
	myconf+="
		-Dlinux_link_gsettings=1
		-Dlinux_link_libpci=1
		-Dlinux_link_libspeechd=1
		-Dlibspeechd_h_prefix=speech-dispatcher/"

	# TODO: use the file at run time instead of effectively compiling it in.
	myconf+="
		-Dusb_ids_path=/usr/share/misc/usb.ids"

	# Save space by removing DLOG and DCHECK messages (about 6% reduction).
	myconf+="
		-Dlogging_like_official_build=1"

	# Never use bundled gold binary. Disable gold linker flags for now.
	myconf+="
		-Dlinux_use_bundled_binutils=0
		-Dlinux_use_bundled_gold=0
		-Dlinux_use_gold_flags=0"

	# TODO: enable mojo after fixing compile failures.
	myconf+=" -Duse_mojo=0"

	# Always support proprietary codecs.
	myconf+=" -Dproprietary_codecs=1"

	# Set python version and libdir so that python_arch.sh can find libpython.
	# Bug 492864.
	myconf+="
		-Dpython_ver=${EPYTHON#python}
		-Dsystem_libdir=$(get_libdir)"

	if ! use bindist; then
		# Enable H.264 support in bundled ffmpeg.
		myconf+=" -Dffmpeg_branding=Chrome"
	fi

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info.
	myconf+=" -Dgoogle_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc
		-Dgoogle_default_client_id=329227923882.apps.googleusercontent.com
		-Dgoogle_default_client_secret=vgKG0NNv7GoDpbtoFNLxCUXu"

	local myarch="$(tc-arch)"
	if [[ $myarch = amd64 ]] ; then
		target_arch=x64
		ffmpeg_target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		target_arch=ia32
		ffmpeg_target_arch=ia32
	elif [[ $myarch = arm ]] ; then
		target_arch=arm
		ffmpeg_target_arch=$(usex neon arm-neon arm)
		# TODO: re-enable NaCl (NativeClient).
		local CTARGET=${CTARGET:-${CHOST}}
		if [[ $(tc-is-softfloat) == "no" ]]; then

			myconf+=" -Darm_float_abi=hard"
		fi
		filter-flags "-mfpu=*"
		use neon || myconf+=" -Darm_fpu=${ARM_FPU:-vfpv3-d16}"

		if [[ ${CTARGET} == armv[78]* ]]; then
			myconf+=" -Darmv7=1"
		else
			myconf+=" -Darmv7=0"
		fi
		myconf+=" -Dsysroot=
			$(gyp_use neon arm_neon)
			-Ddisable_nacl=1"
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	myconf+=" -Dtarget_arch=${target_arch}"

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf+=" -Dwerror="

	# Disable fatal linker warnings, bug 506268.
	myconf+=" -Ddisable_fatal_linker_warnings=1"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Prevent linker from running out of address space, bug #471810 .
		if use x86; then
			filter-flags "-g*"
		fi
	fi

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX RANLIB

	# Tools for building programs to be executed on the build system, bug #410883.
	export AR_host=$(tc-getBUILD_AR)
	export CC_host=$(tc-getBUILD_CC)
	export CXX_host=$(tc-getBUILD_CXX)
	export LD_host=${CXX_host}

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -m 755 "${TMPDIR}" || die

	# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
	einfo "Configuring bundled ffmpeg..."
	pushd third_party/ffmpeg > /dev/null || die
	chromium/scripts/build_ffmpeg.sh linux ${ffmpeg_target_arch} "${PWD}" config-only || die
	chromium/scripts/copy_config.sh || die
	popd > /dev/null || die

	einfo "Configuring Chromium..."
	build/linux/unbundle/replace_gyp_files.py ${myconf} || die
	egyp_chromium ${myconf} || die
}

eninja() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		local jobs=$(makeopts_jobs)
		local loadavg=$(makeopts_loadavg)

		if [[ ${MAKEOPTS} == *-j* && ${jobs} != 999 ]]; then
			NINJAOPTS+=" -j ${jobs}"
		fi
		if [[ ${MAKEOPTS} == *-l* && ${loadavg} != 999 ]]; then
			NINJAOPTS+=" -l ${loadavg}"
		fi
	fi
	set -- ninja -v ${NINJAOPTS} "$@"
	echo "$@"
	"$@"
}

src_compile() {
	# TODO: add media_unittests after fixing compile (bug #462546).
	local test_targets=""
	for x in base cacheinvalidation content crypto \
		gpu net printing sql; do
		test_targets+=" ${x}_unittests"
	done

	local ninja_targets="chrome chrome_sandbox chromedriver"
	if use test; then
		ninja_targets+=" $test_targets"
	fi

	# Build mksnapshot and pax-mark it.
	eninja -C out/Release mksnapshot.${target_arch} || die
	pax-mark m out/Release/mksnapshot.${target_arch}

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release ${ninja_targets} || die

	pax-mark m out/Release/chrome
	if use test; then
		for x in $test_targets; do
			pax-mark m out/Release/${x}
		done
	fi
}

src_test() {
	# For more info see bug #350349.
	local LC_ALL="en_US.utf8"

	if ! locale -a | grep -q "${LC_ALL}"; then
		eerror "${PN} requires ${LC_ALL} locale for tests"
		eerror "Please read the following guides for more information:"
		eerror "  http://www.gentoo.org/doc/en/guide-localization.xml"
		eerror "  http://www.gentoo.org/doc/en/utf-8.xml"
		die "locale ${LC_ALL} is not supported"
	fi

	# If we have the right locale, export it to the environment
	export LC_ALL

	# For more info see bug #370957.
	if [[ $UID -eq 0 ]]; then
		die "Tests must be run as non-root. Please use FEATURES=userpriv."
	fi

	# virtualmake dies on failure, so we run our tests in a function
	VIRTUALX_COMMAND="chromium_test" virtualmake
}

chromium_test() {
	# Keep track of the cumulative exit status for all tests
	local exitstatus=0

	runtest() {
		local cmd=$1
		shift
		local IFS=:
		set -- "${cmd}" --test-launcher-bot-mode "--gtest_filter=-$*"
		einfo "$@"
		"$@"
		local st=$?
		(( st )) && eerror "${cmd} failed"
		(( exitstatus |= st ))
	}

	local excluded_base_unittests=(
		"OutOfMemoryDeathTest.ViaSharedLibraries" # bug #497512
	)
	runtest out/Release/base_unittests "${excluded_base_unittests[@]}"
	runtest out/Release/cacheinvalidation_unittests

	local excluded_content_unittests=(
		"RendererDateTimePickerTest.*" # bug #465452
	)
	runtest out/Release/content_unittests "${excluded_content_unittests[@]}"

	runtest out/Release/crypto_unittests
	runtest out/Release/gpu_unittests

	# TODO: add media_unittests after fixing compile (bug #462546).
	# runtest out/Release/media_unittests

	local excluded_net_unittests=(
		"NetUtilTest.IDNToUnicode*" # bug 361885
		"NetUtilTest.FormatUrl*" # see above
		"SpdyFramerTests/SpdyFramerTest.CreatePushPromiseCompressed/2" # bug #478168
		"SpdyFramerTests/SpdyFramerTest.CreateContinuationCompressed/2" # see above
		"HostResolverImplTest.BypassCache" # bug #498304
		"HostResolverImplTest.FlushCacheOnIPAddressChange" # bug #481812
		"HostResolverImplTest.ResolveFromCache" # see above
		"ProxyResolverV8TracingTest.*" # see above
		"SSLClientSocketTest.ConnectMismatched" # see above
		"UDPSocketTest.*" # see above
		"*EndToEndTest*" # see above
		"Version/QuicHttpStreamTest.Priority/0" # bug #503010
		"Version/QuicHttpStreamTest.DestroyedEarly/0" # see above
	)
	runtest out/Release/net_unittests "${excluded_net_unittests[@]}"

	runtest out/Release/printing_unittests
	runtest out/Release/sql_unittests

	return ${exitstatus}
}

src_install() {
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome || die

	newexe out/Release/chrome_sandbox chrome-sandbox || die
	fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"

	doexe out/Release/chromedriver || die

	# if ! use arm; then
	#	doexe out/Release/nacl_helper{,_bootstrap} || die
	#	insinto "${CHROMIUM_HOME}"
	#	doins out/Release/nacl_irt_*.nexe || die
	#	doins out/Release/libppGoogleNaClPluginChrome.so || die
	# fi

	local sedargs=( -e "s:/usr/lib/:/usr/$(get_libdir)/:g" )
	if [[ -n ${CHROMIUM_SUFFIX} ]]; then
		sedargs+=(
			-e "s:chromium-browser:chromium-browser${CHROMIUM_SUFFIX}:g"
			-e "s:chromium.desktop:chromium${CHROMIUM_SUFFIX}.desktop:g"
			-e "s:plugins:plugins --user-data-dir=\${HOME}/.config/chromium${CHROMIUM_SUFFIX}:"
		)
	fi
	sed "${sedargs[@]}" "${FILESDIR}/chromium-launcher-r3.sh" > chromium-launcher.sh || die
	doexe chromium-launcher.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium-browser${CHROMIUM_SUFFIX} || die
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium${CHROMIUM_SUFFIX} || die

	dosym "${CHROMIUM_HOME}/chromedriver" /usr/bin/chromedriver${CHROMIUM_SUFFIX} || die

	# Allow users to override command-line options, bug #357629.
	dodir /etc/chromium || die
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default" || die

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.pak || die

	doins -r out/Release/locales || die
	doins -r out/Release/resources || die

	newman out/Release/chrome.1 chromium${CHROMIUM_SUFFIX}.1 || die
	newman out/Release/chrome.1 chromium-browser${CHROMIUM_SUFFIX}.1 || die

	doexe out/Release/libffmpegsumo.so || die

	# Install icons and desktop entry.
	local branding size
	for size in 16 22 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser${CHROMIUM_SUFFIX}.png
	done

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # bug #360797
	mime_types+="x-scheme-handler/ftp;" # bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # bug #416393
	make_desktop_entry \
		chromium-browser${CHROMIUM_SUFFIX} \
		"Chromium${CHROMIUM_SUFFIX}" \
		chromium-browser${CHROMIUM_SUFFIX} \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=chromium-browser"
	sed -e "/^Exec/s/$/ %U/" -i "${ED}"/usr/share/applications/*.desktop || die

	# Custom Ubuntu *.desktop file contains Quicklist menu #
	insinto /usr/share/applications
	newins "${WORKDIR}/debian/chromium-browser.desktop" \
			chromium-browser-chromium.desktop
	sed \
		-e "/^Exec/s/$/ %U/" \
		-e "/^MimeType/s/$/x-scheme-handler\/ftp;x-scheme-handler\/mailto;x-scheme-handler\/webcal;/" \
			-i "${ED}"/usr/share/applications/chromium-browser-chromium.desktop || die

	# Install GNOME default application entry (bug #303100).
	if use gnome; then
		dodir /usr/share/gnome-control-center/default-apps || die
		insinto /usr/share/gnome-control-center/default-apps
		newins "${FILESDIR}"/chromium-browser.xml chromium-browser${CHROMIUM_SUFFIX}.xml || die
		if [[ "${CHROMIUM_SUFFIX}" != "" ]]; then
			sed "s:chromium-browser:chromium-browser${CHROMIUM_SUFFIX}:g" -i \
				"${ED}"/usr/share/gnome-control-center/default-apps/chromium-browser${CHROMIUM_SUFFIX}.xml
		fi
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}
