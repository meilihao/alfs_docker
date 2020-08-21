#!/usr/bin/env bash
set -e
echo -e "--- start creating-essential-files-and-symlinks2.sh in chroot ---\n\n"

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

echo -e "--- done creating-essential-files-and-symlinks2.sh in chroot ---\n\n"
