#!/bin/sh -eux

if [ -n "${PAPERTRAIL_SYSLOG_DESTINATION:-}" ]  ; then
  echo "*.*    @${PAPERTRAIL_SYSLOG_DESTINATION}" | sudo tee -a /etc/syslog.conf
fi
