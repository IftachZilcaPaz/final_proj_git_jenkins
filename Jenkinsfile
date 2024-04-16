pipeline {
    agent any  // Or specify a Kubernetes pod template if using Kubernetes plugin

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'Jenkins_git', url: 'https://github.com/IftachZilcaPaz/final_proj_git_jenkins'
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
