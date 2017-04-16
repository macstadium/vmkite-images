#!/bin/bash
set -euo pipefail
make "$@" "output_directory=$OUTPUT_DIR"