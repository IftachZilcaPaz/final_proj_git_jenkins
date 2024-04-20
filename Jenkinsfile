pipeline {
    agent any

    environment {
        // Define the image name here for reuse in the pipeline
        IMAGE_NAME = "iftachzilka7/myhtmlapp:${env.BUILD_ID}"
        KUBECONFIG = '/home/ubuntu/.kube/config'
        CLUSTER_NAME = 'monitoring'  // Define the cluster name here
        DEPLOYMENT_EXISTS = 'false'
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
                    echo "Cluster 'monitoring' exists. Count is 100."
                    }else if (existingClusters.isEmpty()) {
                        echo "empty"
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
                    before proceed please add to cred == kube2== the kubeconfig file and create ns "monitoring"...
                    ''', ok: 'Proceed'
                }
            }
        }

        stage('Check Deployment') {
            steps {
                script {
                    // Check if the deployment already exists
                    def deploymentExists = sh(script: "kubectl get deployment myhtmlapp -n jenkins", returnStatus: true)
                    if (deploymentExists == 0) {
                        echo "Deployment already exists."
                        env.DEPLOYMENT_EXISTS = 'true'
                    } else {
                        echo "Deployment does not exist."
                        env.DEPLOYMENT_EXISTS = 'false'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression { env.DEPLOYMENT_EXISTS == 'false' }
            }
            steps {
                script {
                    // Deployment logic here
                    echo "Deploying application..."
                    kubernetesDeploy configs: 'deployment.yaml', kubeconfigId: 'kube2'
                    // Add your kubectl apply or helm upgrade command here
                }
            }
        }


        stage('Start Port-Forward') {
                steps {
                    script {
                        // Starting port-forward in the background
                        sh "kubectl -n jenkins port-forward svc/myhtmlapp-service 4000:80 --address='0.0.0.0' &"
                        // Store the background job's PID to stop it later
                        sh "echo \$! > port-forward.pid"
                    }
                }
            }

    post {
        always {
            cleanWs()
        }
    }
}
