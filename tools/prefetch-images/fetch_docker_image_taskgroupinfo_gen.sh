#!/bin/bash
set -e

#Docker image fetcher for all mesos-agents
#(c)Hubert Asamer 2017
#jq required
#Creates a TaskGroupInfo Object needed for 'mesos-batch'

#ENV-VARS - START

# AWS_ACCESS_KEY_ID=""     -> Your aws access key
# AWS_DEFAULT_REGION=""    -> AWS-Region where S3-data resides (string)
# AWS_SECRET_ACCESS_KEY="" -> Your aws secret access key
# COMMAND=""               -> Command for docker fmask-processor (string)
# CPUS=                    -> CPUS needed for calculating a fmask of
#                            one S2-MSI tile (int)
# DISK=                    -> DISK space (in MB) needed for calculating a fmask of
#                            one S2-MSI tile (int)
# DOCKER_IMAGE=""          -> Docker image to fetch (string)
# DOCKER_MEM=""            -> Docker engine parameter for fmask mem-setting (string)
# DOCKER_SWAP=""           -> Docker engine parameter for fmask mem-swap-setting (string)
# MEM=                     -> RAM (in MB) needed for calculating a fmask of
#                            one S2-MSI tile (int)
# S3_PREFIX=""             -> Prefix pattern of S2-tile(s) (string)
# SOURCE_BUCKET=""         -> Source s3-bucket (=Sentinel-2 AWS bucket) (string)
# TARGET_BUCKET=""         -> Bucket where results are written to
#                           (read/write permissions required)(string)
# UNIQUE_FILE=""           -> Unique file pattern inside a single tile S3-folder (string)

#ENV-VARS - END

#JSON skeletons for TaskInfo mesos.proto
export TaskGroupInfo='{"tasks":[]}'
export resources='[{"name":"cpus","type":"SCALAR","scalar":{"value":1.0}},{"name":"mem","type":"SCALAR","scalar":{"value":32}}]'
export command='{"value":"docker pull '$DOCKER_IMAGE'"}'

#query aws s3 and print TaskGroupInfo to stdout
curl leader.mesos:5050/master/slaves | 
jq '[.slaves | .[] | .id] | map(. as $o | 
{
  ("name"):("fetch-"+$o),
  ("task_id"):(
    {
      ("value"):("fetcher"+$o)
    }),
  ("agent_id"):({"value": $o}),
  ("resources"):(env.resources | fromjson),
  ("command"): (env.command | fromjson)
}
)' > hash.json

echo $TaskGroupInfo | jq --slurpfile hash hash.json '.tasks=$hash[0]'

rm hash.json
