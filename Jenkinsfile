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
        sh './tools/sentinel-2/s2_fmask_taskgroupinfo_gen.sh > tasks.json'
      }
    }
    stage('count S2-tiles') {
      steps {
        sh 'cat tasks.json | jq \'.tasks | .[] | .name\' | wc -l'
      }
    }
    stage('run mesos-batch') {
      steps {
        sh 'sudo mesos-batch --master=174.0.1.41:5050 --task_list=file://tasks.json --framework_name=S2-fmaskd-32-U-PU-all-jenkins'
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
    S3_PREFIX = 'tiles/32/U/PU'
    SOURCE_BUCKET = 's2-sync'
    TARGET_BUCKET = 's2-derived'
    UNIQUE_FILE = 'metadata.xml'
    AWS_DEFAULT_REGION = 'eu-central-1'
  }
}