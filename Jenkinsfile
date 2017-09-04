pipeline {
  agent {
    docker {
      image 'asamerh4/mesos-batch:f7ea7a1'
      args '-u root'
    }
    
  }
  stages {
    stage('fetch Sentinel-2 S3-refs') {
      steps {
        sh 'tools/sentinel-2/s2_fmask_taskgroupinfo_gen.sh > tasks.json'
      }
    }
    stage('do the parallel processing [map]') {
      steps {
        parallel(
          "fmask mesos-batch": {
            sh 'mesos-batch --master=$MESOS_MASTER --task_list=file://tasks.json --framework_name=$MESOS_FRAMEWORK_NAME'
            
          },
          "count S2-tiles": {
            sh 'cat tasks.json | jq \'.tasks | .[] | .name\' | wc -l'
            
          },
          "list mesos tasklist": {
            sh 'cat tasks.json'
            
          }
        )
      }
    }
    stage('aggregate results [reduce]') {
      steps {
        sh 'aws s3api list-objects-v2 --bucket $TARGET_BUCKET --prefix $S3_PREFIX --output json --query \'Contents[*].Key | [?contains(@, `\'CLOUDMASK.tif\'`) == `true`]\''
      }
    }
  }
  environment {
    COMMAND = './run-fmask.sh'
    CPUS = '1.0'
    DOCKER_IMAGE = 'asamerh4/python-fmask:fmask0.4-aws-4cdfaf5'
    DOCKER_MEM = '12G'
    DOCKER_SWAP = '12G'
    MEM = '2000'
    S3_PREFIX = 'tiles/54/M/TA/2017/6/'
    SOURCE_BUCKET = 's2-sync'
    TARGET_BUCKET = 's2-derived'
    UNIQUE_FILE = 'metadata.xml'
    AWS_DEFAULT_REGION = 'eu-central-1'
    MESOS_MASTER = '174.0.1.74:5050'
    MESOS_FRAMEWORK_NAME = 'S2-fmaskd-Papua54MTA'
  }
}
