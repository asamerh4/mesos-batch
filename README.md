# mesos-batch
commandline mesos batch processing framework (for mesos 1.1.X+) as docker image (still in early beta, not intended for production use)

## features
- parallel job execution (multiple tasks specified in protobuf/JSON)
- no task grouping like in pods, but queued execution within each offer (->parallel processing accross offers)
- optional usage of dynamic reservations & subsequent creation of persistent volumes (specified via resources message of TaskInfo proto)
- decoupled reserve/unreserve operations

## build
use build.sh script to generate a mesos-batch docker image which contains a recent mesos build from asamerh4/mesos. Note that in the process of build.sh a temporary build-image is generated, which could be removed afterwards.

Once build.sh finishes successfully a message like this should be displayed:
```sh
Successfully built de7bd82c8b50
**build finished -> use: docker run --rm -it asamerh4/mesos-batch:3caf670 mesos-batch --h
```
## run
Use docker run --rm -it asamerh4/mesos-batch:#build-tag# mesos-batch

## usage
```sh
Usage: mesos-batch [options]

  --[no-]checkpoint                      Enable checkpointing for the framework. (default: false)
  --content_type=VALUE                   The content type to use for scheduler protocol messages. 'json'
                                         and 'protobuf' are valid choices. (default: protobuf)
  --framework_capabilities=VALUE         Comma separated list of optional framework capabilities to enable.
                                         (e.g. 'SHARED_RESOURCES' or 'GPU_RESOURCES')
  --framework_name=VALUE                 name of the framework (default: mesos-execute instance)
  --[no-]help                            Prints this help message (default: false)
  --kill_after=VALUE                     Specifies a delay after which the task is killed
                                         (e.g., 10secs, 2mins, etc).
  --master=VALUE                         Mesos master (e.g., IP:PORT). (default: )
  --[no-]persistent_volume               Enable dynamic reservation and creation of a persistent volume (default: false)
  --persistent_volume_resource=VALUE     message -> TaskInfo from mesos.proto
  --principal=VALUE                      The principal to use for framework authentication.
  --[no-]remove_persistent_volume        Unreserves dynamic reservations and removes persistent volumes if any (default: false)
  --role=VALUE                           Role to use when registering. (default: *)
  --secret=VALUE                         The secret to use for framework authentication.
  --task_list=VALUE                      The value could be a JSON-formatted string of `TaskGroupInfo` or a
                                         file path containing the JSON-formatted `TaskGroupInfo`. Path must
                                         be of the form `file:///path/to/file` or `/path/to/file`.
                                         See the `TaskGroupInfo` message in `mesos.proto` for the expected
                                         format. NOTE: `agent_id` need not to be set.

                                         Example:
                                         {
                                            "tasks" : [{
                                                  "name" : "sub01-docker",
                                                  "task_id" : {
                                                     "value" : "sub01-docker"
                                                  },
                                                  "agent_id" : {
                                                     "value" : ""
                                                  },
                                                  "resources" : [{
                                                        "name" : "cpus",
                                                        "type" : "SCALAR",
                                                        "scalar" : {
                                                           "value" : 0.5
                                                        },
                                                        "role" : "*"
                                                     }, {
                                                        "name" : "mem",
                                                        "type" : "SCALAR",
                                                        "scalar" : {
                                                           "value" : 32
                                                        },
                                                        "role" : "*"
                                                     }
                                                  ],
                                                  "command" : {
                                                     "value" : "sleep 60 && ls -ltr && df"
                                                  },
                                                  "container" : {
                                                     "type" : "DOCKER",
                                                     "docker" : {
                                                        "image" : "alpine"
                                                     }
                                                  }
                                               }
                                            ]
                                         }
```
