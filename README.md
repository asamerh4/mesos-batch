# mesos-batch
commandline mesos batch processing framework (for mesos 1.1.X+)

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
