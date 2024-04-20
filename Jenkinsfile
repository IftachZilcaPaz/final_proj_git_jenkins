pipeline {
    agent any

    environment {
        // Define the image name here for reuse in the pipeline
        IMAGE_NAME = "iftachzilka7/myhtmlapp:${env.BUILD_ID}"
        KUBECONFIG = '/home/ubuntu/.kube/config'
        CLUSTER_NAME = 'monitoring'  // Define the cluster name here
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
                    input message: 'Do you want to proceed?', ok: 'Proceed'
                }
            }
        }

        stage('Add kubeconfig to Jenkins Credentials') {
            steps {
                script {
                    // Read the kubeconfig file
                    def kubeConfigContent = readFile '/home/ubuntu/.kube/config'

                    // Script to create/update credentials
                    def createOrUpdateCredentials = """
                        import com.cloudbees.plugins.credentials.CredentialsScope
                        import com.cloudbees.plugins.credentials.domains.Domain
                        import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
                        import com.cloudbees.plugins.credentials.CredentialsProvider
                        import com.cloudbees.plugins.credentials.domains.DomainSpecification

                        def credsId = 'kubeconfig'
                        def credsDescription = 'Kubernetes config file'
                        def existingCreds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
                            com.cloudbees.plugins.credentials.Credentials.class,
                            Jenkins.instance,
                            null,
                            null
                        ).find { it.id == credsId }

                        if (existingCreds) {
                            existingCreds.secret = new hudson.util.Secret.fromString(\$kubeConfigContent)
                        } else {
                            def newCreds = new org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl(
                                CredentialsScope.GLOBAL,
                                credsId,
                                credsDescription,
                                new hudson.util.Secret.fromString(\$kubeConfigContent)
                            )
                            com.cloudbees.plugins.credentials.CredentialsProvider.lookupStores(Jenkins.instance).iterator().next().addCredentials(Domain.global(), newCreds)
                        }
                    """

                    // Execute the Groovy script within Jenkins
                    def groovyScript = createOrUpdateCredentials.replace("\$kubeConfigContent", kubeConfigContent.escapeJava())
                    Jenkins.instance.doScript(groovyScript)
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
