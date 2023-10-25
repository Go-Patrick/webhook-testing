pipeline {
    agent any

    environment {
        imagename = "rails-reg"
        registry = '457527268327.dkr.ecr.ap-southeast-1.amazonaws.com/rails-reg'
        registryCredential = 'aws-iam-key'
        dockerImage = ''
        servive='rails-service'
    }


    stages {
        stage('Building image') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }

        stage('Deploy image') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps{
                script{
                    docker.withRegistry("https://" + registry, "ecr:ap-southeast-1:" + registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}