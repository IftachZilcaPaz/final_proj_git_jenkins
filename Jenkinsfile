pipeline {
    agent any

    environment {
        // Define the image name here for reuse in the pipeline
        IMAGE_NAME = "iftachzilka7/myhtmlapp:${env.BUILD_ID}"
        KUBECONFIG = '/home/ubuntu/.kube/config'
        CLUSTER_NAME = 'monitoring'  /// Define the cluster name here
        DEPLOYMENT_NAME = 'myhtmlapp'
        SERVICE_NAME = 'myhtmlapp-service' 
        DEPLOYMENT_EXISTS = 'false'
        HTML_FILE = 'index.html'
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
