#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start the-end-fix.sh +++\n\n"

# nscd start failed
if [ -f /lib/systemd/system/nscd.service ] && [ "`grep "RuntimeDirectory" /lib/systemd/system/nscd.service 2>&1`" == "" ]; then
    echo -e "--- fix nscd ----\n\n"
    sed -i '/PIDFile/a\RuntimeDirectory=nscd' /lib/systemd/system/nscd.service
fi

echo -e "+++ done the-end-fix.sh +++\n\n"
