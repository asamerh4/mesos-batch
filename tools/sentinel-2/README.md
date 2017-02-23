# Sentinel-2 fmask TaskGroupInfo generator
Use the script 's2_fmask_taskgroupinfo_gen' to generate a valid TaskGroupInfo object based on S3-queries (S2-AWS bucket) as input for mesos-batch to process cloudmasks for multiple Sentinel-2 tiles.

## prerequisites
configured aws-cli & write access to a target S3-bucket, jq

## usage (standalone)
export AWS_DEFAULT_REGION="eu-central-1"
export COMMAND="./run-fmask.sh"
export CPUS=1.5
export DISK=500
export DOCKER_IMAGE="asamerh4/python-fmask:fmask0.4-aws-65775b8" 
export DOCKER_MEM="12G"
export DOCKER_SWAP="12G"
export MEM=4000
export S3_PREFIX="tiles/33/U"
export SOURCE_BUCKET="s2-sync"
export TARGET_BUCKET="s2-derived"
export UNIQUE_FILE="metadata.xml"

./s2_fmask_taskgroupinfo_gen.sh

## usage (docker)
