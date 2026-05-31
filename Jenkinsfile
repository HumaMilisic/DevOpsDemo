pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'registry:5000'
        IMAGE_NAME = 'gridsensor'
        HELM_RELEASE = 'gridsensor'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:latest", "-f app/Dockerfile .")
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry("http://${DOCKER_REGISTRY}", '') {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Vulnerability Scan') {
            steps {
                sh "docker exec trivy trivy image --severity HIGH,CRITICAL --exit-code 1 ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "helm upgrade --install ${HELM_RELEASE} ./k8s/helm/gridsensor \
                    --set image.repository=${DOCKER_REGISTRY}/${IMAGE_NAME} \
                    --set image.tag=latest \
                    --wait --timeout 60s"
            }
        }

        stage('Smoke Test') {
            steps {
                sh "curl -s http://localhost:30080/health | grep -q status"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}