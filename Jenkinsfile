pipeline {
  agent any
  stages {
    stage('test1') {
      steps {
        sh './tools/sentinel-2/s2_fmask_taskgroupinfo_gen.sh > tasks.json'
      }
    }
  }
}