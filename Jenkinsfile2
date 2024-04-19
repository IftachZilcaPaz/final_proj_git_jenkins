pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("my-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image("my-app:${env.BUILD_ID}").inside {
                        sh 'echo Running tests inside Docker'
                    }
                }
            }
        }
    }
}
