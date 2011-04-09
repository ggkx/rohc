#!/bin/sh
#
# file:        test_feedback2.sh
# description: Check that the ROHC library creates expected FEEDBACK-2 packets
# author:      Didier Barvaux <didier@barvaux.org>
#
# This script may be used by creating a link "test_feedback2_ACKTYPE_TESTTYPE_OPTIONS.sh"
# where:
#    ACKTYPE  is the ACK type to check for, it is used to choose the source
#             capture located in the 'inputs' subdirectory.
#    TESTTYPE is the type of test to run, it is used to choose the source
#             capture located in the 'inputs' subdirectory.
#    OPTIONS  a underscore-separated list of feedback options that are
#             expected to be generated in the FEEDBACK-2 packet.
#
# Script arguments:
#    test_feedback2_ACKTYPE_TESTTYPE_OPTIONS.sh [verbose]
# where:
#   verbose          prints the traces of test application
#

# parse arguments
SCRIPT="$0"
VERBOSE="$1"
VERY_VERBOSE="$2"
if [ "x$MAKELEVEL" != "x" ] ; then
	BASEDIR="${srcdir}"
	APP="./test_feedback2"
else
	BASEDIR=$( dirname "${SCRIPT}" )
	APP="${BASEDIR}/test_feedback2"
fi

# extract the ACK type and test type from the name of the script
ACKTYPE=$( echo "${SCRIPT}" | \
           sed -e 's#^.*/test_feedback2_\([^_]\+\)_\([^_]\+\)_\(.\+\)\.sh#\1#' )
TESTTYPE=$( echo "${SCRIPT}" | \
            sed -e 's#^.*/test_feedback2_\([^_]\+\)_\([^_]\+\)_\(.\+\)\.sh#\2#' )
CID_TYPE=$( echo "${TESTTYPE}" | \
            sed -e 's/^.*\(small\|large\).*$/\1/' )
OPTIONS=$( echo "${SCRIPT}" | \
           sed -e 's#^.*/test_feedback2_\([^_]\+\)_\([^_]\+\)_\(.\+\)\.sh#\3#' | \
           sed -e 's/none//g' | \
           sed -e 's/_/ /g' )
CAPTURE_SOURCE="${BASEDIR}/inputs/${ACKTYPE}_${TESTTYPE}.pcap"

# check that capture exists
if [ ! -r "${CAPTURE_SOURCE}" ] ; then
	echo "source capture ${CAPTURE_SOURCE} not found or not readable, please do not run $(dirname $0)/test_feedback2.sh directly!"
	exit 1
fi

CMD="${APP} ${CAPTURE_SOURCE} ${CID_TYPE} ${ACKTYPE} ${OPTIONS}"

# run in verbose mode or quiet mode
if [ "${VERBOSE}" = "verbose" ] ; then
	if [ "${VERY_VERBOSE}" = "verbose" ] ; then
		${CMD} || exit $?
	else
		${CMD} > /dev/null || exit $?
	fi
else
	${CMD} > /dev/null 2>&1 || exit $?
fi

