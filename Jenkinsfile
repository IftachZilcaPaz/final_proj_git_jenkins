pipeline {
    agent any

    environment {
        // Define the image name here for reuse in the pipeline
        IMAGE_NAME = "iftachzilka7/myhtmlapp:${env.BUILD_ID}"
        KUBECONFIG = '/home/ubuntu/.kube/config'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'Jenkins_git', 
                    url: 'https://github.com/IftachZilcaPaz/final_proj_git_jenkins.git'
            }
        }

        stage('Clean Docker Environment') {
    steps {
        script {
            // Check if there are any containers, and stop them if there are
            def runningContainers = sh(script: "docker ps -q", returnStdout: true).trim()
            if (runningContainers) {
                sh "docker stop ${runningContainers}"
            }
            
            // Check if there are any containers, and remove them if there are
            def allContainers = sh(script: "docker ps -aq", returnStdout: true).trim()
            if (allContainers) {
                sh "docker rm ${allContainers}"
            }
            
            // Check if there are any images, and remove them if there are
            def allImages = sh(script: "docker images -q", returnStdout: true).trim()
            if (allImages) {
                sh "docker rmi -f ${allImages}"
            }
        }
    }
}

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build(IMAGE_NAME)
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'Docker') {
                        dockerImage.push("${env.BUILD_ID}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubernetesDeploy configs: 'deployment.yaml', kubeconfigId: 'kube2'
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
