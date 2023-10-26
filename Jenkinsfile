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
        stage('Checking'){
            steps{
                sh "echo Testing"
            }
            post {
                success {
                    script {
                        withCredentials([string(credentialsId: 'goldenowl_github_token', variable: 'GITHUB_TOKEN')]) {
                            // Use GitHub API to update build status
                            // This is just a placeholder. Replace with your actual API call.
                            sh 'curl -XPOST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/:owner/:repo/statuses/$(git rev-parse HEAD) -d "{\\"state\\": \\"success\\", \\"target_url\\": \\"${BUILD_URL}\\", \\"description\\": \\"The build has succeeded!\\"}"'
                        }
                    }
                }
                failure {
                    script {
                        withCredentials([string(credentialsId: 'goldenowl_github_token', variable: 'GITHUB_TOKEN')]) {
                            // Use GitHub API to update build status
                            // This is just a placeholder. Replace with your actual API call.
                            sh 'curl -XPOST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/:owner/:repo/statuses/$(git rev-parse HEAD) -d "{\\"state\\": \\"failure\\", \\"target_url\\": \\"${BUILD_URL}\\", \\"description\\": \\"The build has failed.\\"}"'
                        }
                    }
                }
            }
        }

        stage('Building image') {
            // when {
            //     anyOf {
            //         branch 'dev'
            //         branch 'master'
            //     }
            // }
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
            post {
                success {
                    script {
                        withCredentials([string(credentialsId: 'goldenowl_github_token', variable: 'GITHUB_TOKEN')]) {
                            // Use GitHub API to update build status
                            // This is just a placeholder. Replace with your actual API call.
                            sh 'curl -XPOST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/:owner/:repo/statuses/$(git rev-parse HEAD) -d "{\\"state\\": \\"success\\", \\"target_url\\": \\"${BUILD_URL}\\", \\"description\\": \\"The build has succeeded!\\"}"'
                        }
                    }
                }
                failure {
                    script {
                        withCredentials([string(credentialsId: 'goldenowl_github_token', variable: 'GITHUB_TOKEN')]) {
                            // Use GitHub API to update build status
                            // This is just a placeholder. Replace with your actual API call.
                            sh 'curl -XPOST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/:owner/:repo/statuses/$(git rev-parse HEAD) -d "{\\"state\\": \\"failure\\", \\"target_url\\": \\"${BUILD_URL}\\", \\"description\\": \\"The build has failed.\\"}"'
                        }
                    }
                }
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
            post {
                success {
                    script {
                        withCredentials([string(credentialsId: 'goldenowl_github_token', variable: 'GITHUB_TOKEN')]) {
                            // Use GitHub API to update build status
                            // This is just a placeholder. Replace with your actual API call.
                            sh 'curl -XPOST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/:owner/:repo/statuses/$(git rev-parse HEAD) -d "{\\"state\\": \\"success\\", \\"target_url\\": \\"${BUILD_URL}\\", \\"description\\": \\"The build has succeeded!\\"}"'
                        }
                    }
                }
                failure {
                    script {
                        withCredentials([string(credentialsId: 'goldenowl_github_token', variable: 'GITHUB_TOKEN')]) {
                            // Use GitHub API to update build status
                            // This is just a placeholder. Replace with your actual API call.
                            sh 'curl -XPOST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/:owner/:repo/statuses/$(git rev-parse HEAD) -d "{\\"state\\": \\"failure\\", \\"target_url\\": \\"${BUILD_URL}\\", \\"description\\": \\"The build has failed.\\"}"'
                        }
                    }
                }
            }
        }
    }
}