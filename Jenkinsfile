pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    // Example of building a Docker image
                    def dockerImage = docker.build("my-image:${env.BUILD_ID}")
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Example of running a Docker container
                    dockerImage.inside {
                        sh 'echo "Running tests inside Docker"'
                    }
                }
            }
        }
    }
}
