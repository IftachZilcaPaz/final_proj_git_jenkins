pipeline {
    agent any  // Or specify a Kubernetes pod template if using Kubernetes plugin

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-credentials-id', url: 'https://github.com/your-repo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("myrepo/myhtmlapp:${env.BUILD_ID}")
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-registry-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
