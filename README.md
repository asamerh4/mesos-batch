# mesos-batch
commandline mesos batch processing framework using Mesos V1 HTTP scheduler API for parallel job execution. (still in early beta, not intended for production use)

## use cases
- parallel arbitrary `one-off` tasks
- creating persistent volumes
- parallel tasks on e.g. shared persistent volumes (reduce steps)

## features
- parallel job execution (multiple tasks specified as TaskInfos protobuf/JSON)
- no task grouping like in pods, but queued execution within each offer (->parallel processing accross offers)
- optional usage of dynamic reservations & subsequent creation of persistent volumes (specified via resources message of TaskInfo proto)
- decoupled reserve/unreserve operations
- interfaces with Mesos HTTP V1 API (-> no libmesos drivers needed)
- released for linux/docker and native 64bit windows

## build
use `build.sh` script to generate a `mesos-batch` docker image which contains a recent mesos build from asamerh4/mesos. Note that during the build process a temporary build-image is generated, which could be removed afterwards.

Once build.sh finishes successfully a message like this should be displayed:
```sh
Successfully built de7bd82c8b50
**build finished -> use: docker run --rm -it asamerh4/mesos-batch:3caf670 mesos-batch --h
```
## run
Use docker run --rm -it asamerh4/mesos-batch:`tag` mesos-batch

## usage
```
 ___  ___  ___
|\__\|\__\|\__\  commandline batch processing framework for mesos 1.1++
\|__|\|__|\|__|  github.com/asamerh4/mesos-batch

Usage: mesos-batch [options]

  --[no-]checkpoint                      Enable checkpointing for the framework. (default: false)
  --content_type=VALUE                   The content type to use for scheduler protocol messages. 'json'
                                         and 'protobuf' are valid choices. (default: protobuf)
  --framework_capabilities=VALUE         Comma separated list of optional framework capabilities to enable.
                                         TASK_KILLING_STATE is always enabled. PARTITION_AWARE is enabled
                                         unless --no-partition-aware is specified.
                                         other choices are e.g. 'SHARED_RESOURCES' or 'GPU_RESOURCES'
  --framework_name=VALUE                 name of the framework (default: mesos-batch instance)
  --[no-]help                            Prints this help message (default: false)
  --kill_after=VALUE                     Specifies a delay after which the task is killed
                                         (e.g., 10secs, 2mins, etc).
  --master=VALUE                         Mesos master (e.g., IP:PORT). (default: )
  --[no-]partition_aware                 Enable partition-awareness for the framework. (default: true)
  --[no-]persistent_volume               Enable dynamic reservation and creation of a persistent volume (default: false)
  --persistent_volume_resource=VALUE     The value could be a JSON formatted string of `TaskInfo` or a
                                         file path containing the JSON/protobuf. Path must
                                         be of the form `file:///path/to/file` or `/path/to/file`.
                                         See the `TaskInfo` and the contained `Resource` messages
                                         in `mesos.proto` for the expected format.
                                         NOTE: `DiskInfo` inside the `disk` Resource must be present.

                                         Example:
                                         {
                                           "name": "persistent_vol_resource_spec",
                                           "task_id": {
                                              "value": "resource_spec001"
                                           },
                                           "agent_id": {
                                              "value": ""
                                           },
                                           "resources": [{
                                                "name": "cpus",
                                                 "type": "SCALAR",
                                                 "scalar": {
                                                    "value": 3.0
                                                 },
                                                 "role": "test",
                                                 "reservation": {
                                                    "principal": "test"
                                                 }
                                              }, {
                                                 "name": "mem",
                                                 "type": "SCALAR",
                                                 "scalar": {
                                                    "value": 64
                                                 },
                                                 "role": "test",
                                                 "reservation": {
                                                    "principal": "test"
                                                 }
                                              }, {
                                                 "name": "disk",
                                                 "type": "SCALAR",
                                                 "scalar": {
                                                    "value": 4096
                                                 },
                                                 "role": "test",
                                                 "reservation": {
                                                    "principal": "test"
                                                 },
                                                 "disk": {
                                                    "persistence": {
                                                       "id": "22d664c4-15d2-4978-86e3-d9b5d310666f",
                                                       "principal": "test"
                                                    },
                                                    "volume": {
                                                       "container_path": "volume",
                                                       "mode": "RW"
                                                    }
                                                 }
                                              }
                                           ]
                                         }
  --principal=VALUE                      The principal to use for framework authentication.
  --[no-]remove_persistent_volume        Unreserves dynamic reservations and removes persistent volumes
                                         if any
                                         (default: false)
  --role=VALUE                           Role to use when registering. (default: *)
  --secret=VALUE                         The secret to use for framework authentication.
  --task_list=VALUE                      The value could be a JSON-formatted string of `TaskGroupInfo` or a
                                         file path containing the JSON-formatted `TaskGroupInfo`. Path must
                                         be of the form `file:///path/to/file` or `/path/to/file`.
                                         See the `TaskGroupInfo` message in `mesos.proto` for the expected
                                         format. NOTE: `agent_id` need not to be set.

                                         Example:
                                         {
                                           "tasks": [{
                                                  "name": "S2_33UUU_2017_2_6_0",
                                                  "task_id": {
                                                    "value": "fmaskr_S2_33UUU_2017_2_6_0"
                                                  },
                                                  "agent_id": {
                                                    "value": ""
                                                  },
                                                  "resources": [
                                                    {
                                                      "name": "cpus",
                                                      "type": "SCALAR",
                                                      "scalar": {
                                                        "value": 1.5
                                                      }
                                                    },
                                                    {
                                                      "name": "mem",
                                                      "type": "SCALAR",
                                                      "scalar": {
                                                        "value": 4000
                                                      }
                                                    }
                                                  ],
                                                  "command": {
                                                    "value": "./run-fmask.sh",
                                                    "environment": {
                                                      "variables": [
                                                        {
                                                          "name": "inputId",
                                                          "value": "s3://s2-sync/tiles/33/U/UU/2017/2/6/0/"
                                                        },
                                                        {
                                                          "name": "outputId",
                                                          "value": "s3://s2-derived/tiles/33/U/UU/2017/2/6/0/"
                                                        },
                                                        {
                                                          "name": "AWS_DEFAULT_REGION",
                                                          "value": "eu-central-1"
                                                        }
                                                      ]
                                                    }
                                                  },
                                                  "container": {
                                                    "type": "DOCKER",
                                                    "docker": {
                                                      "image": "asamerh4/python-fmask:fmask0.4-aws-65775b8",
                                                      "parameters": [
                                                        {
                                                          "key": "memory",
                                                          "value": "12G"
                                                        },
                                                        {
                                                          "key": "memory-swap",
                                                          "value": "12G"
                                                        }
                                                      ]
                                                    }
                                                  }
                                                },{...},{...},{...},{...}
                                           ]
                                         }
```
