#!/bin/bash
set -e

cd build-img/mesos
MESOS_BUILD=$(git rev-parse --short HEAD)

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cd ../..

docker build -t asamerh4/mesos-batch:$MESOS_BUILD .

echo -e ${YELLOW}"**build finished -> use: docker run --rm -t asamerh4/mesos-batch:$MESOS_BUILD mesos-batch --h"${NC}
