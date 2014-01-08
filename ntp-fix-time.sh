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

			# Get the servers from the appropriate file
		IFS=$'\n' NTPHOSTS=($(grep '^server' /etc/ntp.conf | awk -F' ' '{print $NF}'))

			# if we didn't get any from the pre vious command, fall back on 'time.apple.com'
		[[ "$NTPHOSTS" == "" ]] && NTPHOSTS='time.apple.com'

			# Keep trying until one works
		for NTPHOST in ${NTPHOSTS}
		do
				ntpdate -b -u ${NTPHOST} | tee -a "$LOG" && break
		done

else
			# not sure if this is correct
		 ntpd --quit 2>&1 | tee -a "$LOG"
fi

log "finished"

exit
#
#EOF
