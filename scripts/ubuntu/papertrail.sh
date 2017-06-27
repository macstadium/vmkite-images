#!/bin/sh -eux

if [ -n "${PAPERTRAIL_TOKEN:-}" ] && [ -n "${PAPERTRAIL_SETUP_SCRIPT:-}" ] ; then
  wget -qO - --header="X-Papertrail-Token: ${PAPERTRAIL_TOKEN}" \
    "${PAPERTRAIL_SETUP_SCRIPT}" | bash
fi
