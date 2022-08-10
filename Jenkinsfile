pipeline {
    environment {
        DEPLOY = "${env.BRANCH_NAME == "master" || env.BRANCH_NAME == "develop" ? "true" : "false"}"
        NAME = "${env.BRANCH_NAME == "master" ? "example" : "example-staging"}"
        VERSION = "${env.BUILD_ID}"
        DOMAIN = 'localhost'
        REGISTRY = 'devopspractice60/hwdemo'
    }
    agent {
        kubernetes {
            defaultContainer 'jnlp'
            yamlFile 'build.yaml'
        }
    }
    stages {
        stage('Build') {
            steps {
                container('maven') {
                    sh 'mvn package'
                }
            }
        }
        stage('Docker Build') {
            when {
                environment name: 'DEPLOY', value: 'true'
            }
            steps {
                container('docker') {
                    sh "docker build -t ${REGISTRY}:${VERSION} ."
                }
            }
        }
        stage('Docker Publish') {
            when {
                environment name: 'DEPLOY', value: 'true'
            }
            steps {
                container('docker') {
                        withCredentials([string(credentialsId: 'docker-pass', variable: 'docker-creds')]) {
                        sh "docker login -u devopspractice60 -p $docker-creds https://hub.docker.com
                        sh "docker push ${REGISTRY}:${VERSION}"
                     }
                    }
                }
            }
        }
        stage('Kubernetes Deploy') {
            when {
                environment name: 'DEPLOY', value: 'true'
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force --set name=${NAME} --set image.tag=${VERSION} --set domain=${DOMAIN} ${NAME} ./helm"
                }
            }
        }
    }
}
