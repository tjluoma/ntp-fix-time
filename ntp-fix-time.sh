#!/bin/zsh -f
# force one time update of system time
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2013-07-11

NAME="$0:t:r"

zmodload zsh/datetime

LOG=/tmp/ntpd.out.txt

timestamp () {
	strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS"
}


function log {
	echo "$NAME [`timestamp`]: $@" | tee -a "$LOG"
}


die ()
{
	echo "$NAME [die at `timestamp`]: $@" | tee -a "$LOG"
	exit 1
}


if [ "$EUID" != "0" ]
then
		die "$0 must be run as root not $EUID"
		exit 1
fi



NTPHOST=$(systemsetup -getnetworktimeserver 2>/dev/null | awk '{print $4}' || echo -n 'time.apple.com')


log "Starting"


if (( $+commands[ntpdate] ))
then
			# 2014-01-07: from `man ntpdate`:
			#
			# Note: The functionality of this program is now available in the ntpd(8) program.
			# See the -q command line option in the ntpd(8) page. After a suitable period of mourning, the
			# ntpdate utility is to be retired from this distribution.
			#
			# (It still exists in 10.9.1)

		( ntpdate -u "${NTPHOST}"  | tee -a "$LOG") || ( ntpd --quit  | tee -a "$LOG") || die "ntpdate and ntpd failed"
else
			# not sure if this is correct
		( ntpd --quit 2>&1 ) | tee -a "$LOG"
fi

log "finished"

exit
#
#EOF
