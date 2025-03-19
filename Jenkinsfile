pipeline {
    agent { label 'Node23' } 

    environment {

        HARBOR_REGISTRY = 'localhost:80' 
        HARBOR_PROJECT = 'clothes-web'
        IMAGE_NAME = "${HARBOR_REGISTRY}/${HARBOR_PROJECT}/clothes-frontend"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        HARBOR_CRED = credentials('harbor-credentials-id') 
    }

    stages {
        stage('Checkout') {
            steps {
                
                git branch: 'main', url: 'https://github.com/tierik-bjornson/Clothes-frontend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
        
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Harbor') {
            steps {
                script {
                 
                    docker.withRegistry("https://${HARBOR_REGISTRY}", 'harbor-credentials-id') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                  
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push('latest')
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
               
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        always {
           
            echo 'Pipeline completed!'
        }
        success {
            echo 'Image successfully pushed to Harbor!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
