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

        stage('Deploy to Kubernetes') {
            agent {
                kubernetes {
                     label 'jenkins-slave'
                }
            }
            steps {
                script {
                    withCredentials([string(credentialsId: 'kube-token', variable: 'KUBE_TOKEN')]) {
                        // Dynamically create the deployment.yaml
                        sh """
                        cat <<EOF > deployment.yaml
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                          name: myhtmlapp
                          namespace: jenkins
                        spec:
                          replicas: 2
                          selector:
                            matchLabels:
                              app: myhtmlapp
                          template:
                            metadata:
                              labels:
                                app: myhtmlapp
                            spec:
                              containers:
                              - name: myhtmlapp
                                image: iftachzilka7/myhtmlapp:\${BUILD_ID} # Replace with your image
                                ports:
                                - containerPort: 80
                        EOF
                        """
                        // Apply the deployment
                        sh "kubectl apply -f deployment.yaml --token=\${KUBE_TOKEN} --validate=false"
                }
            }
    }

    post {
        always {
            cleanWs()
        }
    }
}
