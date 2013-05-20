# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: xdummy.eclass
# @MAINTAINER:
# x11@gentoo.org
# @AUTHOR:
# Original author: Martin Schlemmer <azarah@gentoo.org>
# @BLURB: This eclass can be used for packages that needs a working X environment to build.

# @ECLASS-VARIABLE: XDUMMY_REQUIRED
# @DESCRIPTION:
# Variable specifying the dependency on xorg-server and xhost.
# Possible special values are "always" and "manual", which specify
# the dependency to be set unconditionaly or not at all.
# Any other value is taken as useflag desired to be in control of
# the dependency (eg. XDUMMY_REQUIRED="kde" will add the dependency
# into "kde? ( )" and add kde into IUSE.
: ${XDUMMY_REQUIRED:=test}

# @ECLASS-VARIABLE: XDUMMY_DEPEND
# @DESCRIPTION:
# Dep string available for use outside of eclass, in case a more
# complicated dep is needed.
# You can specify the variable BEFORE inherit to add more dependencies.
XDUMMY_DEPEND="${XDUMMY_DEPEND}
	!prefix? ( x11-misc/x11vnc[dummy] )
	x11-apps/xhost
"

# @ECLASS-VARIABLE: XDUMMY_COMMAND
# @DESCRIPTION:
# Command (or eclass function call) to be run in the X11 environment
# (within xdummymake function).
: ${XDUMMY_COMMAND:="emake"}

has "${EAPI:-0}" 0 1 && die "xdummy eclass require EAPI=2 or newer."

case ${XDUMMY_REQUIRED} in
	manual)
		;;
	always)
		DEPEND="${XDUMMY_DEPEND}"
		RDEPEND=""
		;;
	optional|tests)
		[[ -z ${XDUMMY_USE} ]] && XDUMMY_USE="test"
		DEPEND="${XDUMMY_USE}? ( ${XDUMMY_DEPEND} )"
		RDEPEND=""
		IUSE="${XDUMMY_USE}"
		;;
	*)
		DEPEND="${XDUMMY_REQUIRED}? ( ${XDUMMY_DEPEND} )"
		RDEPEND=""
		IUSE="${XDUMMY_REQUIRED}"
		;;
esac

# @FUNCTION: xdummymake
# @DESCRIPTION:
# Function which attach to running X session or start new Xdummy session
# where the XDUMMY_COMMAND variable content gets executed.
xdummymake() {
	debug-print-function ${FUNCNAME} "$@"

	local i=0
	local retval=0
	local OLD_SANDBOX_ON="${SANDBOX_ON}"
	local XDUMMY=$(type -p Xdummy)
	local XHOST=$(type -p xhost)
	local xdummyargs="-tmpdir "${WORKDIR}""

	# backcompat for maketype
	if [[ -n ${maketype} ]]; then
		ewarn "QA: ebuild is exporting \$maketype=${maketype}"
		ewarn "QA: Ebuild should be migrated to use XDUMMY_COMMAND=${maketype} instead."
		ewarn "QA: Setting XDUMMY_COMMAND to \$maketype conveniently for now."
		XDUMMY_COMMAND=${maketype}
	fi

	# If $DISPLAY is not set, or xhost cannot connect to an X
	# display, then do the Xdummy hack.
	if [[ -n ${XDUMMY} && -n ${XHOST} ]] && \
			( [[ -z ${DISPLAY} ]] || ! (${XHOST} &>/dev/null) ) ; then
		debug-print "${FUNCNAME}: running Xdummy hack"
		export XAUTHORITY=
		# The following is derived from Mandrake's hack to allow
		# compiling without the X display

		einfo "Scanning for an open DISPLAY to start Xdummy ..."
		# If we are in a chrooted environment, and there is already a
		# X server started outside of the chroot, Xdummy will fail to start
		# on the same display (most cases this is :0 ), so make sure
		# Xdummy is started, else bump the display number
		#
		# Azarah - 5 May 2002
		XDISPLAY=$(i=0; while [[ -f /tmp/.X${i}-lock ]] ; do ((i++));done; echo ${i})
		debug-print "${FUNCNAME}: XDISPLAY=${XDISPLAY}"

		# We really do not want SANDBOX enabled here
		export SANDBOX_ON="0"

		debug-print "${FUNCNAME}: ${XDUMMY} :${XDISPLAY} ${xdummyargs}"
		${XDUMMY} :${XDISPLAY} ${xdummyargs} &>/dev/null &
		sleep 2

		local start=${XDISPLAY}
		while [[ ! -f /tmp/.X${XDISPLAY}-lock ]]; do
			# Stop trying after 15 tries
			if ((XDISPLAY - start > 15)) ; then
				eerror "'${XDUMMY} :${XDISPLAY} ${xdummyargs}' returns:"
				echo
				${XDUMMY} :${XDISPLAY} ${xdummyargs}
				echo
				eerror "If possible, correct the above error and try your emerge again."
				die "Unable to start Xdummy"
			fi

			((XDISPLAY++))
			debug-print "${FUNCNAME}: ${XDUMMY} :${XDISPLAY} ${xdummyargs}"
			${XDUMMY} :${XDISPLAY} ${xdummyargs} &>/dev/null &
			sleep 2
		done

		# Now enable SANDBOX again if needed.
		export SANDBOX_ON="${OLD_SANDBOX_ON}"

		einfo "Starting Xdummy on \$DISPLAY=${XDISPLAY} ..."

		export DISPLAY=:${XDISPLAY}
		# Do not break on error, but setup $retval, as we need
		# to kill Xdummy
		debug-print "${FUNCNAME}: ${XDUMMY_COMMAND} \"$@\""
		if has "${EAPI}" 2 3; then
			${XDUMMY_COMMAND} "$@"
			retval=$?
		else
			nonfatal ${XDUMMY_COMMAND} "$@"
			retval=$?
		fi

		# Now kill Xdummy
		kill $(cat /tmp/.X${XDISPLAY}-lock)
	else
		debug-print "${FUNCNAME}: attaching to running X display"
		# Normal make if we can connect to an X display
		debug-print "${FUNCNAME}: ${XDUMMY_COMMAND} \"$@\""
		${XDUMMY_COMMAND} "$@"
		retval=$?
	fi

	# die if our command failed
	[[ ${retval} -ne 0 ]] && die "${FUNCNAME}: the ${XDUMMY_COMMAND} failed."

	return 0 # always return 0, it can be altered by failed kill for Xdummy
}

# @FUNCTION: Xmake
# @DESCRIPTION:
# Same as "make", but set up the Xdummy hack if needed.
# Deprecated call.
Xmake() {
	debug-print-function ${FUNCNAME} "$@"

	ewarn "QA: you should not execute make directly"
	ewarn "QA: rather execute Xemake -j1 if you have issues with parallel make"
	XDUMMY_COMMAND="emake -j1" xdummymake "$@"
}

# @FUNCTION: Xemake
# @DESCRIPTION:
# Same as "emake", but set up the Xdummy hack if needed.
Xemake() {
	debug-print-function ${FUNCNAME} "$@"

	XDUMMY_COMMAND="emake" xdummymake "$@"
}

# @FUNCTION: Xeconf
# @DESCRIPTION:
# Same as "econf", but set up the Xdummy hack if needed.
Xeconf() {
	debug-print-function ${FUNCNAME} "$@"

	XDUMMY_COMMAND="econf" xdummymake "$@"
}
