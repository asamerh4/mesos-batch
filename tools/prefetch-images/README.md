# Mesos agent image-fetcher TaskGroupInfo generator
Use the script 'fetch_docker_image_taskgroupinfo_gen' to generate a valid TaskGroupInfo object as  input for mesos-batch.

## prerequisites
curl, jq

## usage (standalone)
```sh
export DOCKER_IMAGE="asamerh4/python-fmask:fmask0.4-aws-65775b8" 
./fetch_docker_image_taskgroupinfo_gen.sh
```

## usage (docker)
```sh
docker run --rm -t \
-e DOCKER_IMAGE="asamerh4/python-fmask:fmask0.4-aws-65775b8" \
asamerh4/mesos-batch:{TAG} ./tools/prefetch-images/fetch_docker_image_taskgroupinfo_gen.sh
```