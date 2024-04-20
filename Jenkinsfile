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
        stage('Check and Create Kind Cluster') {
            steps {
                script {
                    // Check if the Kind cluster already exists
                    def existingClusters = sh(script: "kind get clusters", returnStdout: true).trim()
                    if (!existingClusters.tokenize().contains(env.CLUSTER_NAME)) {
                        // Cluster does not exist, so create it
                        echo "Cluster named '${env.CLUSTER_NAME}' does not exist. Creating now..."
                        sh "kind create cluster --name ${env.CLUSTER_NAME} --image kindest/node:v1.23.6 --config /home/ubuntu/Prometheus.lesson/kind.yaml"
                    } else {
                        echo "Cluster named '${env.CLUSTER_NAME}' already exists. No action taken."
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
