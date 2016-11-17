# mesos-batch
commandline mesos batch processing framework (for mesos 1.1.X+)

```sh
Usage: mesos-batch [options]

  --capabilities=VALUE               JSON representation of system capabilities needed to execute
                                     the command.
                                     Example:
                                     {
                                        "capabilities": [
                                            "NET_RAW",
                                            "SYS_ADMIN"
                                          ]
                                     }
  --[no-]checkpoint                  Enable checkpointing for the framework. (default: false)
  --framework_capabilities=VALUE     Comma separated list of optional framework capabilities to enable.
                                     (the only valid value is currently 'GPU_RESOURCES')
  --framework_name=VALUE             name of the framework (default: mesos-execute instance)
  --[no-]help                        Prints this help message (default: false)
  --kill_after=VALUE                 Specifies a delay after which the task is killed
                                     (e.g., 10secs, 2mins, etc).
  --master=VALUE                     Mesos master (e.g., IP:PORT). (default: )
  --principal=VALUE                  The principal to use for framework authentication.
  --role=VALUE                       Role to use when registering. (default: *)
  --secret=VALUE                     The secret to use for framework authentication.
  --task_list=VALUE                  The value could be a JSON-formatted string of `TaskGroupInfo` or a
                                     file path containing the JSON-formatted `TaskGroupInfo`. Path must
                                     be of the form `file:///path/to/file` or `/path/to/file`.
                                     See the `TaskGroupInfo` message in `mesos.proto` for the expected
                                     format. NOTE: `agent_id` need not to be set.

                                     Example:
                                     {
                                       "tasks":
                                          [
                                             {
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
                                            }, {
                                               "name" : "sub02-docker",
                                               "task_id" : {
                                                  "value" : "sub02-docker"
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
