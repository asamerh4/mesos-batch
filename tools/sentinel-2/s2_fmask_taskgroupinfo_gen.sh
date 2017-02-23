#!/bin/bash
set -ex

#Sentinel-2 MSI fmaskr TaskGroupInfo generator
#(c)Hubert Asamer 2017
#Configured 'aws-cli' or ec2-s3-policy in place & jq required
#Creates a TaskGroupInfo Object needed for 'mesos-batch' from S3-queries 
# for distributed processing on mesos

#ENV-VARS - START

# AWS_DEFAULT_REGION="" -> AWS-Region where S3-data resides (string)
# COMMAND=""            -> Command for docker fmask-processor (string)
# CPUS=                 -> CPUS needed for calculating a fmask of
#                            one S2-MSI tile (int)
# DISK=                 -> DISK space (in MB) needed for calculating a fmask of
#                            one S2-MSI tile (int)
# DOCKER_IMAGE=""       -> Docker image name of fmask processor (string)
# DOCKER_MEM=""         -> Docker engine parameter for fmask mem-setting (string)
# DOCKER_SWAP=""        -> Docker engine parameter for fmask mem-swap-setting (string)
# MEM=                  -> RAM (in MB) needed for calculating a fmask of
#                            one S2-MSI tile (int)
# S3_PREFIX=""          -> Prefix pattern of S2-tile(s) (string)
# SOURCE_BUCKET=""      -> Source s3-bucket (=Sentinel-2 AWS bucket) (string)
# TARGET_BUCKET=""      -> Bucket where results are written to
#                           (read/write permissions required)(string)
# UNIQUE_FILE=""        -> Unique file pattern inside a single tile S3-folder (string)

#ENV-VARS - END

#JSON skeletons for TaskInfo mesos.proto
export TaskGroupInfo='{"tasks":[]}'
export resources='[{"name":"cpus","type":"SCALAR","scalar":{"value":'$CPUS'}},{"name":"mem","type":"SCALAR","scalar":{"value":'$MEM'}}]'
export command='{"value":"'$COMMAND'","environment":[]}'
export container='{"type":"DOCKER","docker":{"image":"","parameters":[{"key":"memory","value":"'$DOCKER_MEM'"},{"key":"memory-swap","value":"'$DOCKER_SWAP'"}]}}'

#query aws s3 and print TaskGroupInfo to stdout
aws s3api list-objects-v2 \
--bucket $SOURCE_BUCKET \
--prefix $S3_PREFIX \
--output json \
--query 'Contents[*].Key | [?contains(@, `'$UNIQUE_FILE'`) == `true`]' |
jq 'map( . as $o | split("/")|
{
  ("name"):("S2_"+.[1]+.[2]+.[3]+"_"+.[4]+"_"+.[5]+"_"+.[6]+"_"+.[7]),
  ("task_id"):(
    {
      ("value"):("fmaskr_S2_"+.[1]+.[2]+.[3]+"_"+.[4]+"_"+.[5]+"_"+.[6]+"_"+.[7])
    }),
  ("resources"):(env.resources | fromjson),
  ("command"): (env.command | fromjson |
    .environment = 
    [
      {"name":"inputId","value":(env.SOURCE_BUCKET+"/"+$o | rtrimstr(env.UNIQUE_FILE))},
      {"name":"outputId","value":(env.TARGET_BUCKET+"/"+$o| rtrimstr(env.UNIQUE_FILE))},
      {"name":"AWS_DEFAULT_REGION","value":(env.AWS_DEFAULT_REGION)}
    ]
  ),
  ("container"):(env.container | fromjson | .docker.image = (env.DOCKER_IMAGE))
}
)' > hash.json

echo $TaskGroupInfo | jq --slurpfile hash hash.json '.tasks=$hash[0]'

rm hash.json
