#!/bin/bash
set -ex

#Docker image fetcher for all mesos-agents
#jq required
#Creates a TaskGroupInfo Object needed for 'mesos-batch'

#ENV-VARS - START

# DOCKER_IMAGE=""          -> Docker image to fetch (string)

#ENV-VARS - END

#JSON skeletons for TaskInfo mesos.proto
export TaskGroupInfo='{"tasks":[]}'
#use AWS ECS backed docker registry
export ecr_login=$(aws ecr get-login --region eu-central-1)
export command='{"value":"'$ecr_login' && docker pull '$DOCKER_IMAGE'"}'

#query aws s3 and print TaskGroupInfo to stdout
curl leader.mesos:5050/master/slaves | 
jq '[.slaves | .[]] | map(.id as $o | .resources.cpus as $cpus | 
{
  ("name"):("fetch-"+$o),
  ("task_id"):(
    {
      ("value"):("fetcher"+$o)
    }),
  ("agent_id"):({"value": $o}),
  ("resources"):([{"name":"cpus","type":"SCALAR","scalar":{"value":$cpus}},{"name":"mem","type":"SCALAR","scalar":{"value":32}}]),
  ("command"): (env.command | fromjson)
}
)' > hash.json

echo $TaskGroupInfo | jq --slurpfile hash hash.json '.tasks=$hash[0]'

rm hash.json
