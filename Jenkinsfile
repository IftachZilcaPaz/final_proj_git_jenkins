pipeline {
    agent any

    environment {
        // Define the image name here for reuse in the pipeline
        IMAGE_NAME = "iftachzilka7/myhtmlapp:${env.BUILD_ID}"
        KUBECONFIG = '/home/ubuntu/.kube/config'
        CLUSTER_NAME = 'monitoring'  // Define the cluster name here
        DEPLOYMENT_NAME = 'myhtmlapp'
        SERVICE_NAME = 'myhtmlapp-service' 
        DEPLOYMENT_EXISTS = 'false'
        HTML_FILE = 'index.html'
        NAMESPACE = 'jenkins'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: '$BRANCH_NAME', // this name or inside jenkins job config under "This project is parameterized" in General section
                    credentialsId: 'Jenkins_git', 
                    url: 'https://github.com/IftachZilcaPaz/final_proj_git_jenkins.git'
            }
        }
        stage('Check and Install Docker') {
            steps {
                script {
                    // Check if Docker is installed
                    def dockerExists = sh(script: 'command -v docker', returnStatus: true) == 0

                    if (!dockerExists) {
                        echo 'Docker not found, installing...'

                        // Define the script to check and install Docker
                        def installDockerScript = '''
                        #!/bin/bash

                        # Update package list
                        sudo apt update

                        # Install Docker
                        sudo apt install docker.io -y

                        # Start Docker service
                        sudo systemctl start docker

                        # Enable Docker to start on boot
                        sudo systemctl enable docker

                        echo "Docker installed successfully."
                        '''

                        // Write the script to a temporary file
                        writeFile file: 'install_docker.sh', text: installDockerScript

                        // Make the script executable
                        sh 'chmod +x install_docker.sh'

                        // Run the script
                        sh './install_docker.sh'
                    } else {
                        echo 'Docker is already installed.'
                    }
                }
            }
        }
        stage('Check and Install Kind') {
            steps {
                script {
                    // Check if kind is installed
                    def kindExists = sh(script: 'command -v kind', returnStatus: true) == 0

                    if (!kindExists) {
                        echo 'Kind not found, installing...'

                        // Define the script to install Kind
                        def installKindScript = '''
                        #!/bin/bash

                        # Download the kind binary
                        curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

                        # Make the kind binary executable
                        chmod +x ./kind

                        # Move the kind binary to a directory in the PATH
                        sudo mv ./kind /usr/local/bin/kind

                        echo "Kind installed successfully."
                        '''

                        // Write the script to a temporary file
                        writeFile file: 'install_kind.sh', text: installKindScript

                        // Make the script executable
                        sh 'chmod +x install_kind.sh'

                        // Run the script
                        sh './install_kind.sh'
                    } else {
                        echo 'Kind is already installed.'
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
        stage('Check and Create Kind Cluster') {
            steps {
                script {
                    // Check if the Kind cluster already exists
                    def existingClusters = sh(script: "kind get clusters", returnStdout: true).trim()
                        echo "$existingClusters"
                    if (existingClusters == "monitoring") {
                        echo "Cluster 'monitoring' exists."
                    }else if (existingClusters.isEmpty()) {
                        echo "Cluster 'monitoring' does not exists."
                        echo "createing...."
                        sh "kind create cluster --name ${env.CLUSTER_NAME} --image kindest/node:v1.23.6 --config /home/ubuntu/Prometheus.lesson/kind.yaml"

                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    // This will pause the execution and wait for user input
                    input message: '''
                        before proceed please add to cred ==> kube2 <== in credential the kubeconfig file,
                            and then create ns "monitoring" or check if already exists...
                    ''', ok: 'Proceed'
                }
            }
        }

        stage('Check Deployment') {
            steps {
                script {
                    // Check if the deployment already exists
                    def deploymentExists = sh(script: "kubectl get deployment ${env.DEPLOYMENT_NAME} -n ${env.NAMESPACE}", returnStatus: true)
                    if (deploymentExists == 0) {
                        echo "Deployment already exists."
                        writeFile file: 'deploymentExists.txt', text: 'true'
                    } else {
                        echo "Deployment does not exist."
                        writeFile file: 'deploymentExists.txt', text: 'false'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression { readFile('deploymentExists.txt').trim() == 'false' }
            }
            steps {
                script {
                    echo "Deploying application..."
                    kubernetesDeploy configs: 'deployment.yaml', kubeconfigId: 'kube2'
                }
            }
        }

        stage('Check HTML Change') {
            steps {
                script {
                    // Get changes since last build
                    def changedFiles = sh(
                        script: "git diff HEAD^ HEAD --name-only",
                        returnStdout: true
                    ).trim()
                    // Check if the specific HTML file is in the list of changed files
                    if (changedFiles.contains(env.HTML_FILE)) {
                        echo "HTML file has changed. Deleting deployment..."
                        // Command to delete Kubernetes deployment
                        sh "kubectl delete deployment.apps/${env.DEPLOYMENT_NAME} -n jenkins"
                        sh "kubectl delete service/${env.SERVICE_NAME} -n jenkins"
                        sh "sleep 10"
                        echo "Deploying application..."
                        kubernetesDeploy configs: 'deployment.yaml', kubeconfigId: 'kube2'    
                    } else {
                        echo "HTML file has not changed. No action taken."
                    }
                }
            }
        }


        stage('Start Port Forward') {
                steps {
                    script {
                        // Starting port-forward in the background
                            sh "sleep 10"
                            sh "kubectl -n jenkins port-forward svc/myhtmlapp-service 4000:80 --address='0.0.0.0' &"
                        // Store the background job's PID to stop it later
                        // sh "echo \$! > port-forward.pid"
                        try {
                        // Use port-forward here, for example by running some tests
                        // sh "kubectl -n jenkins port-forward svc/myhtmlapp-service 4000:80 --address='0.0.0.0' &"
                        // that communicate with the service through the forwarded port
                        } finally {
                        // Kill the port-forward process
                            echo "Web will be able 40 sec from now then kill..."
                            sh "sleep 40"
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
