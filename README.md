![image](https://github.com/IftachZilcaPaz/ci_cd_github_action_aws/assets/151572520/c4b1a850-020a-42af-942a-37f0a8796a49)

---

<p>
<h1> Hey Again &nbsp;<img src="https://raw.githubusercontent.com/MartinHeinz/MartinHeinz/master/wave.gif" height="45" width="45"/>&nbsp;&nbsp;Welcome To My "final_proj_git_jenkins" &nbsp;=)</h1>
</p>
<br/>

## 💻 Languages and Tools:

![Jenkins](https://img.shields.io/badge/jenkins-%232C5263.svg?style=flat&logo=jenkins&logoColor=white) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white) ![Github](https://img.shields.io/badge/github-235835CC.svg?style=flat&logo=github&logoColor=white&label=.) ![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=flat&logo=kubernetes&logoColor=white)




---

&nbsp;
&nbsp;
&nbsp;
&nbsp;

# Instruction For Jenkins To Run New Job

## Table of Contents
1. [Step 1: Install Required Plugins](#step-1-install-required-plugins)
2. [Step 2: Create Docker Hub and Kubernetes Credentials](#step-2-create-docker-hub-and-kubernetes-credentials)
3. [Step 3: Update Jenkinsfile](#step-3-update-jenkinsfile)
4. [Step 4: Run the Pipeline](#step-4-run-the-pipeline)
5. [Pipeline Diagram](#pipeline-diagram)

## Step 1: Install Required Plugins

In Jenkins, go to:

**Dashboard > Manage Jenkins > Plugin Manager**

Install the following plugins:

- **GitHub Plugins**: GitHub, GitHub API Plugin, GitHub Branch Source, GitHub Pull Request Builder, Pipeline: GitHub Groovy Libraries.
- **Docker Plugins**: Docker, Docker API Plugin, Docker Commons Plugin, Docker Pipeline.
- **Kubernetes Plugins**: Kubernetes, 'Kubernetes :: Pipeline :: DevOps Steps', Kubernetes CLI Plugin, Kubernetes Client API Plugin, Kubernetes Continuous Deploy Plugin, Kubernetes Credentials, Kubernetes Credentials Provider.

## Step 2: Create Docker Hub and Kubernetes Credentials

In Jenkins, go to:

**Dashboard > Manage Jenkins > Credentials**

Click on "Global" and then "Add Credentials" as shown in the image below:

![Add Credentials](https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/84c8b591-f437-47e4-a80a-e758e5b2f5e8)

For Docker Hub, select the type for username and password credentials and fill in the required fields:

![Docker Hub Credentials](https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/751f092d-24ba-4a27-b326-329488227027)

- **Username**: Your Docker Hub username
- **Password**: Your Docker Hub password
- **ID**: dockerhub
- **Description**: Docker Hub credentials

## Step 3: Update Jenkinsfile

In your Jenkinsfile, update the following lines:

![Jenkinsfile Configuration](https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/a346c4d4-bbe3-4576-9f6b-d8b98e08d52f)

- **IMAGE_NAME**: Your Docker Hub username and repository name
- **KUBECONFIG**: Path to the .kube directory on your master node

Optional: Update **CLUSTER_NAME** and **NAMESPACE** as needed, but ensure consistency throughout the code.

## Step 4: Run the Pipeline

To run the pipeline, go to the main Jenkins page and click "Build with Parameters" on the left side:

![Build with Parameters](https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/bbd7bd64-45d0-4717-b01a-289f7bb6917b)

Select the desired branch to test before merging into the main branch:

![Branch Selection](https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/de80dee1-f66c-4171-a1f7-f253aebdb22f)

The pipeline stages include:

1. **Connect to Branch**: Connects to your selected branch in the repository.
2. **Build Docker Image**: Builds the Docker image.
3. **Push Image**: Pushes the image to your Docker Hub repository using the previously created credentials.
4. **Check and Create Kind Cluster**: Checks if the cluster exists and creates one if necessary.
5. **Manual Approval**: Waits for your approval before proceeding. Follow these steps:
   - Add Kubernetes credentials by navigating to **Credentials > Global** and selecting the kubeconfig type:
   
     ![Kubernetes Credentials](https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/4b20eec6-1685-4f4b-9fc9-f22dcdfc6d82)
   
   - Paste the content of your kubeconfig file from the master node's ~/.kube directory.
   - Create a namespace called jenkins in your cluster.
   - Approve the stage to continue.
6. **Check Deployment**: Checks if the deployment exists.
7. **Deploy to Kubernetes**: Deploys the application to Kubernetes.
8. **Check HTML Change**: Checks for changes in the HTML file and redeploys if necessary.
9. **Start Port Forward**: Starts port forwarding to access the website.

## Pipeline Diagram

The following diagram illustrates the stages and processes:

```mermaid
flowchart LR
    subgraph GitHub
        direction TB
        A(Checkout to specific branch)
        A(Start Port Forward)
    end
    subgraph Jenkins
        direction TB
        B(Trigger Jenkins Automation) --> C(Pulling to code from github repo)
    end
    subgraph DockerHub
        direction TB
        D(Check and Install Docker) --> E(Check and Install Kind)
        F(Build Docker Image) --> G(Push Image)
    end
    subgraph K8S
        direction TB
        H(Check and Create Kind Cluster) --> I(Check Deployment)
        I(Check Deployment) --> J(Deploy to Kubernetes)
        J(Deploy to Kubernetes) --> K(Creating_a_deployment_to_check_employee_code)
        K(Creating_a_deployment_to_check_employee_code) --> L(Check HTML Change)
    end
    %% ^ These subgraphs are identical, except for the links to them:

    %% Link *to* subgraph1: subgraph1 direction is maintained
    
    id1(((Devops Engineer))) --> GitHub
    GitHub --> Jenkins
    Jenkins --> DockerHub
    DockerHub --> K8S
    K8S --> id2(((Final Step)))
    %% Link *within* subgraph2:
    %% subgraph2 inherits the direction of the top-level graph (LR)
    %% outside ---> top2
```


  
