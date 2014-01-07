ntp-fix-time
============

Fix Mac OS X time using ntpdate 

### launchd ###

[com.tjluoma.fixtime.plist](com.tjluoma.fixtime.plist) - must be placed in /Library/LaunchDaemons/com.tjluoma.fixtime.plist owned by root:wheel

	sudo mv -v com.tjluoma.fixtime.plist /Library/LaunchDaemons/com.tjluoma.fixtime.plist 

	sudo chmod root:wheel /Library/LaunchDaemons/com.tjluoma.fixtime.plist 

### ntp-fix-time.sh ###

[ntp-fix-time.sh](ntp-fix-time.sh) - must be placed anywhere in `$PATH` such as /usr/local/bin/ntp-fix-time.sh

	sudo mv ntp-fix-time.sh /usr/local/bin/ntp-fix-time.sh

	sudo chmod 755 /usr/local/bin/ntp-fix-time.sh

### Logs ###

* Standard output saved to **/tmp/ntpd.err.txt**

* Errors will be logged to **/tmp/ntpd.out.txt**


