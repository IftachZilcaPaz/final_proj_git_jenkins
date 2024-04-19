pipeline {
    agent any  // Specifies that this pipeline can run on any available agent

    stages {
        // Stage for checking out source code from Git
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'Jenkins_git', 
                    url: 'https://github.com/IftachZilcaPaz/final_proj_git_jenkins.git'
            }
        }

        // Stage for building the Docker image
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image and tag it with the Jenkins BUILD_ID
                    dockerImage = docker.build("iftachzilka7/myhtmlapp:${env.BUILD_ID}")
                }
            }
        }

        // Stage for pushing the Docker image to Docker Hub
        stage('Push Image') {
            steps {
                script {
                    // Log in to Docker Hub and push the built image
                    docker.withRegistry('https://registry.hub.docker.com', 'Docker') {
                        // Push the image tagged with BUILD_ID
                        dockerImage.push("${env.BUILD_ID}")
                        // Optionally push the 'latest' tag as well
                        dockerImage.push("latest")
                    }
                }
            }
        }

        // Stage for pulling the latest Docker image
        stage('Pull Image') {
            steps {
                script {
                    // Pulling the latest image from Docker Hub
                    sh 'docker pull iftachzilka7/myhtmlapp:latest'
                }
            }
        }

        // Stage for running the Docker image
        stage('Run Image') {
            steps {
                script {
                    // Running the Docker image
                    sh 'docker run -d -p 80:80 iftachzilka7/myhtmlapp:latest'
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
