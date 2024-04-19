pipeline {
    agent any

    environment {
        // Define the image name here for reuse in the pipeline
        IMAGE_NAME = "iftachzilka7/myhtmlapp:${env.BUILD_ID}"
        KUBECONFIG = '/home/ubuntu/.kube/config'
    }

    stages {
        stage('Create Namespace') {
            steps {
                script {
                    // Check if the namespace exists
                    sh "kubectl get namespace jenkins || kubectl create namespace jenkins"
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: 'Jenkins_git', 
                    url: 'https://github.com/IftachZilcaPaz/final_proj_git_jenkins.git'
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
