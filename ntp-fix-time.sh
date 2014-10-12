#!/bin/zsh -f
# force one time update of system time
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2013-07-11

NAME="$0:t:r"

HOST=`hostname -s`

HOST="$HOST:l"

NTPHOST='time.apple.com'

PPID_NAME=$(/bin/ps -p ${PPID} | fgrep '/sbin/launchd' | awk '{print $NF}')

zmodload zsh/datetime

function timestamp	{ strftime "%d %b %T" "$EPOCHSECONDS" }

function log 		{ echo "`timestamp` $NAME[$$]: $@" | tee -a "$LOG" }

TIME=$(strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS")

if [ "$PPID_NAME" = "/sbin/launchd" ]
then
			# this was launched via launchd
		export IS_LAUNCHD=yes
else
		export IS_LAUNCHD=no
fi

if [ "$EUID" = "0" ]
then
		LOG="$HOME/Library/Logs/metalog/$NAME/$HOST/$TIME.log"
		SUDO=""
else
		SUDO='sudo'
		LOG="/var/log/$NAME.$HOST.$TIME.log"
fi

umask 022

log "Starting"

if [[ -x '/usr/sbin/ntpdate' ]]
then

	if [[ "$SUDO" == "sudo" ]]
	then
		if [ "$IS_LAUNCHD" = "yes" ]
		then
			log "Before time fix"
			${SUDO} /usr/sbin/ntpdate -b -u "${NTPHOST}" 2>&1 | tee -a "$LOG"
			log "After time fix"
		else
			if [[ "$TERM_PROGRAM" != "" ]]
			then
				sudo -v

				log "Before time fix"

				${SUDO} /usr/sbin/ntpdate -b -u "${NTPHOST}" 2>&1 | tee -a "$LOG"

				log "After time fix"
			else
				log "Before time fix"

				${SUDO} /usr/sbin/ntpdate -b -u "${NTPHOST}" 2>&1 | tee -a "$LOG"

				log "After timee fix"
			fi
		fi
	else
		log "Before time fix"
		/usr/sbin/ntpdate -b -u "${NTPHOST}" 2>&1 | tee -a "$LOG"
		log "After time fix"
	fi

else
			# not sure if this is correct
		${SUDO} /usr/sbin/ntpd --quit 2>&1 | tee -a "$LOG"
fi

# log "finished"

exit
#
#EOF
