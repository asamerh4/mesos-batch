#!/bin/bash
set -e

ROOT_DIR=$(pwd)
NPROC=$(nproc)
cd build-img/mesos
MESOS_BUILD=$(git rev-parse --short HEAD)

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cd ../..
docker build -t asamerh4/mesos-build-img-$MESOS_BUILD build-img/

docker run --rm -it -e MAKEFLAGS=-j$NPROC -v $ROOT_DIR/build-img/rpm:/out asamerh4/mesos-build-img-$MESOS_BUILD /bin/bash -c "./mesos-rpm-packaging/build_mesos --src-dir /mesos;  cp /mesos-rpm-packaging/pkg.rpm /out"

docker build -t asamerh4/mesos-batch-$MESOS_BUILD .

echo -e ${YELLOW}"**build finished -> use: docker run --rm -it asamerh4/mesos-batch-$MESOS_BUILD mesos-batch --h" ${NC}