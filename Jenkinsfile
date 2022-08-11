pipeline {
    environment {
        
        NAME = "${env.BRANCH_NAME }-${env.BUILD_ID}"
        VERSION = "${env.BUILD_ID}"
        DOMAIN = 'localhost'
        REGISTRY_DEV = 'devopspractice60/axiom-demo-dev'
        REGISTRY_QA = 'devopspractice60/axiom-demo-qa'
        REGISTRY_PROD = 'devopspractice60/axiom-demo-prod'

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
        
        stage('Docker Build and Publish to DEV') {
            when {
                 branch "dev"
            }
            steps {
                container('docker') {
                        withCredentials([string(credentialsId: 'pass_registry', variable: 'docker_pass')]) {
                        sh "docker login -u devopspractice60 -p $docker_pass" 
                        sh "docker build -t ${REGISTRY_DEV}:${VERSION} ."   
                        sh "docker push ${REGISTRY_DEV}:${VERSION}"
                        sh "docker rmi ${REGISTRY_DEV}:${VERSION}"
                     }
                    }
                }
            }

        stage('Docker Build and Publish to QA') {
            when {
                 branch "qa"
            }
            steps {
                container('docker') {
                        withCredentials([string(credentialsId: 'pass_registry', variable: 'docker_pass')]) {
                        sh "docker login -u devopspractice60 -p $docker_pass" 
                        sh "docker build -t ${REGISTRY_QA}:${VERSION} ."   
                        sh "docker push ${REGISTRY_QA}:${VERSION}"
                        sh "docker rmi ${REGISTRY_QA}:${VERSION}"
                     }
                    }
                }
            }

        stage('Docker Build and Publish to PROD') {
            when {
                 branch "master"
            }
            steps {
                container('docker') {
                        withCredentials([string(credentialsId: 'pass_registry', variable: 'docker_pass')]) {
                        sh "docker login -u devopspractice60 -p $docker_pass" 
                        sh "docker build -t ${REGISTRY_PROD}:${VERSION} ."   
                        sh "docker push ${REGISTRY_PROD}:${VERSION}"
                        sh "docker rmi ${REGISTRY_PROD}:${VERSION}"
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
                    sh "helm upgrade --install --force -f ./values-dev.yaml --set app.name=${NAME} --set app.imagetag=${VERSION}  ${NAME} ./helm"
                }
            }         
        }

        stage('Kubernetes Deploy to Prod') {
            when {
                 branch "master"
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force -f ./values-prod.yaml --set app.name=${NAME} --set app.imagetag=${VERSION}  ${NAME} ./helm"
                }
            }         
        }
        stage('Kubernetes Deploy to QA') {
            when {
                  branch "qa"
            }
            steps {
                container('helm') {
                    sh "helm upgrade --install --force -f ./values-qa.yaml --set app.name=${NAME} --set app.imagetag=${VERSION}  ${NAME} ./helm"
                }
            }         
        }
    }
}

