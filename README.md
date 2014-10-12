ntp-fix-time
============

**Summary:** Fix OS X time using ntpdate. For some reason, OS X does not to keep very good time lately, so I wrote this script to force it in sync every few hours.

(Yes, Unix operating systems _do_ have tools which are supposed to do this automatically. For some reason OS X’s have not been working well for me, at least through Mountain Lion.)

## Automated Installation Instructions

	curl -sfL 'https://raw.githubusercontent.com/tjluoma/ntp-fix-time/master/install-ntp-fix-time.sh' | zsh -f

That's a really long line. Make sure you get all of it, or use this shorter alternative:

	curl -sfL http://luo.ma/install-ntp-fix-time.sh | zsh -f

## Manual Installation Instructions

So, you like to do things by hand, eh? Well, I can respect that. It's pretty easy.

### launchd ###

[com.tjluoma.fixtime.plist](com.tjluoma.fixtime.plist) - must be placed in /Library/LaunchDaemons/com.tjluoma.fixtime.plist owned by root:wheel

	sudo mv -v com.tjluoma.fixtime.plist /Library/LaunchDaemons/com.tjluoma.fixtime.plist

	sudo chown root:wheel /Library/LaunchDaemons/com.tjluoma.fixtime.plist

	sudo chmod 644 /Library/LaunchDaemons/com.tjluoma.fixtime.plist

### ntp-fix-time.sh ###

[ntp-fix-time.sh](ntp-fix-time.sh) - must be placed anywhere in `$PATH` such as /usr/local/bin/ntp-fix-time.sh

	sudo mv ntp-fix-time.sh /usr/local/bin/ntp-fix-time.sh

	sudo chmod 755 /usr/local/bin/ntp-fix-time.sh

### Logs ###

Output is saved to `/var/log/com.tjluoma.fixtime.log`


