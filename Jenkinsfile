pipeline {
    environment {
        DEPLOY = "${env.BRANCH_NAME == "master" || env.BRANCH_NAME == "dev" ? "true" : "false"}"
        NAME = "${env.BRANCH_NAME }-${env.BUILD_ID}"
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
        
        stage('Docker Build and Publish') {
            when {
                environment name: 'DEPLOY', value: 'true'
            }
            steps {
                container('docker') {
                        withCredentials([string(credentialsId: 'pass_registry', variable: 'docker-pass')]) {
                        sh "docker login -u devopspractice60 -p Samsung@135" 
                        sh "docker build -t ${REGISTRY}:${VERSION} ."   
                        sh "docker push ${REGISTRY}:${VERSION}"
                        sh "docker rmi ${REGISTRY}:${VERSION}"
                     }
                    }
                }
            }
        
        stage('Kubernetes Deploy to Dev') {
            when {
                 branch "dev"
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force value-dev.yaml --set name=${NAME} --set imagetag=${VERSION}  ${NAME} ./helm"
                }
            }         
        }

        stage('Kubernetes Deploy to Prod') {
            when {
                 branch "master"
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force value-prod.yaml --set name=${NAME} --set imagetag=${VERSION}  ${NAME} ./helm"
                }
            }         
        }
        stage('Kubernetes Deploy to QA') {
            when {
                  branch "qa"
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force value-qa.yaml --set name=${NAME} --set imagetag=${VERSION}  ${NAME} ./helm"
                }
            }         
        }
    }
}

