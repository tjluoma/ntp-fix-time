#!/bin/zsh -f
# Purpose: Install the shell script and launchd plist
#
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2014-10-11

NAME="$0:t:r"

function die
{
	echo "$NAME: $@"
	exit 1
}

PLIST_URL='https://raw.githubusercontent.com/tjluoma/ntp-fix-time/master/com.tjluoma.fixtime.plist'

PLIST_PATH='/Library/LaunchDaemons/com.tjluoma.fixtime.plist'

SCRIPT_URL='https://raw.githubusercontent.com/tjluoma/ntp-fix-time/master/ntp-fix-time.sh'

SCRIPT_PATH='/usr/local/bin/ntp-fix-time.sh'

echo "$NAME: $PLIST_PATH must be owned by root. Please enter your administrator password:"
sudo -v

TEMPDIR="${TMPDIR-/tmp}/${NAME}.$$.$RANDOM"

mkdir -p "$TEMPDIR"

cd "$TEMPDIR"

echo "$NAME: fetching $PLIST_URL..."
curl --remote-name --progress-bar --location --fail "$PLIST_URL"  \
	|| die "Failed to download $PLIST_URL"

/bin/chmod -vv 644 "$PLIST_URL:t" \
	|| die "Failed to set permissions on $PLIST_URL:t"

echo "$NAME: fetching $SCRIPT_URL..."
curl --remote-name --progress-bar --location --fail "$SCRIPT_URL" \
	|| die "Failed to download $SCRIPT_URL"

/bin/chmod -vv 755 "$SCRIPT_URL:t" \
	|| die "Failed to set permissions on $SCRIPT_URL:t"

sudo /usr/sbin/chown -v 'root:wheel' "$SCRIPT_URL:t" "$PLIST_URL:t" \
	|| die "Failed to set ownership of $SCRIPT_URL:t and $PLIST_URL:t"

sudo /bin/mv -vf "$SCRIPT_URL:t" "$SCRIPT_PATH" \
	|| die "Failed to move $SCRIPT_URL:t to $SCRIPT_PATH"

sudo /bin/mv -vf "$PLIST_URL:t" "$PLIST_PATH" \
	|| die "Failed to move $PLIST_URL:t to $PLIST_PATH"

sudo /bin/launchctl load "$PLIST_PATH" \
	&& echo "$NAME: loaded $PLIST_PATH into launchd" \
	|| die "Failed to load $PLIST_PATH into launchd"



exit
#
#EOF
