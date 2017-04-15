#!/bin/bash
set -euo pipefail

scp -v -r -P \
  "${VMKITE_SCP_PORT}" \
  "${BUILD_ARTIFACT}" \
  "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}:${VMKITE_SCP_PATH}"