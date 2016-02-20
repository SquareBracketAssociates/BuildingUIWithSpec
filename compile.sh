#!/usr/bin/env bash

set -e

PILLAR_COMMAND="pillar"

if [ -x pillar ]; then
  PILLAR_COMMAND="./pillar"
fi

${PILLAR_COMMAND} export "$@"
bash pillarPostExport.sh
