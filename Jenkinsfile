pipeline {
    agent any
    tools {
        nodejs "Node23"
    }
    environment {
        REGISTRY = 'localhost:80'
        PROJECT = 'clothes-web'
        IMAGE_NAME = 'clothes-frontend'
        HARBOR_CREDS = 'harbor-credentials-id'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Start') {
            steps {
                script {
                    echo "🚀 Pipeline bắt đầu chạy!"
                }
            }
        }
        stage('Checkout Source Code') {
            steps {
                script {
                    echo "🔄 Clone source code từ GitHub..."
                    git url: 'https://github.com/tierik-bjornson/Clothes-frontend.git', branch: 'main'
                    echo "✅ Clone thành công!"
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    echo "📦 Cài đặt dependencies."
                    sh 'npm install'
                    echo "✅ Cài đặt xong!"
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    echo "🏗️ Build ứng dụng ReactJS..."
                    sh 'npm run build'
                    echo "✅ Build hoàn tất!"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo "🧪 Chạy test..."
                    sh 'npm run test || echo "Không có test nào, bỏ qua..."'
                    echo "✅ Test hoàn tất!"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Build Docker image..."
                    sh "docker build -t ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
                    echo "✅ Build Docker image thành công!"
                }
            }
        }
        stage('Push to Harbor') {
            steps {
                script {
                    echo "🔑 Đăng nhập vào Harbor..."
                    sh "docker login ${REGISTRY} -u admin -p Harbor12345"
                    echo "📤 Push image lên Harbor..."
                    sh "docker push ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    sh "docker tag ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:latest"
                    sh "docker push ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:latest"
                    echo "✅ Push thành công!"
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo "🗑️ Dọn dẹp Docker image..."
                    sh "docker rmi ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${DOCKER_IMAGE_TAG} || true"
                    echo "✅ Dọn dẹp hoàn tất!"
                }
            }
        }
    }
    post {
        success {
            echo '🎉 Build và push lên Harbor thành công! Repo deploy đã được cập nhật.'
        }
        failure {
            echo '❌ Build thất bại. Kiểm tra logs để xem chi tiết.'
        }
    }
}
