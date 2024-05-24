[![MasterHead](https://thecloudlegion.com/images/devops.gif)](https://rishavchanda.io)

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

<p>
<h2> ###   Instruction For Jenkins To Run New Job  ###&nbsp;</h1>
<br/>
<h4>first step:</h4>
in jenkins go to:

Dashboard > Manage Jenkins > Plugin Manager

and install these plugins:

- GitHub, GitHub API Plugin, GitHub Branch Source, GitHub Pull Request Builder, Pipeline: GitHub Groovy Librarie.
- Docker, Docker API Plugin, Docker Commons Plugin, Docker Pipeline.
- Kubernetes, 'Kubernetes :: Pipeline :: DevOps Steps', Kubernetes CLI Plugin, Kubernetes Client API Plugin, Kubernetes Continuous Deploy Plugin, Kubernetes Credentials,Kubernetes Credentials Provider.

<h4>next step:</h4>
create docker hub and k8s credentials.

in jenkins:

Dashboard > Manage Jenkins > Credentials.

click on "global" and the on "add cred" as in the picture :

<img width="663" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/84c8b591-f437-47e4-a80a-e758e5b2f5e8">


then you will see that, this is the type to create docker hub username and password:

<img width="1324" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/751f092d-24ba-4a27-b326-329488227027">

insert all the fields, username and password that you connect with it to "DOCKERHUB"
then give id name like "dockerhub" and description.


<h4>next step:</h4>

in my Jenkinsfile i have the first lines:

<img width="562" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/a346c4d4-bbe3-4576-9f6b-d8b98e08d52f">

change:
- IMAGE_NAME contnet to your user name and repo
- KUBECONFIG to the path of .kube in your master
- if you want to u can change also > CLUSTER_NAME, NAMESPACE as u wish, but need to change it in more places in the code.

<h4>next step:</h4>

run the pipeline, my example of pipeline it will build all even the cluster.

  to run need you will see in the main page in jenkins in left side "build with parameter"
  
  <img width="577" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/bbd7bd64-45d0-4717-b01a-289f7bb6917b">
  
  what thet it means actually is to run with specific branch, why is it good? cuz we dont want any time to run main branch, do you test in custom branch run the pipeline with the code of this costum branch and if all is good merge it into main and then run again and check.
  
  when you will click on "build with parameter" you will see:
  
  <img width="1061" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/de80dee1-f66c-4171-a1f7-f253aebdb22f">
  
  change to you branch name.


- first stage will connect to your branch in the repo
- next stage "Build Docker Image"
- next "Push Image" to your repo this stage will use your dockerhub cred that created prev
- next "Check and Create Kind Cluster" will check if cluster not already exists and create one
- next "Manual Approval" will wait to your approval, before approve do those steps:

    back to "Credentials" and click again on global, and now we will add one for k8s, and keep attention to the type
    (note!! if you dont see kubeconfig type as picture check again that you installed all the plugins above):
    <img width="1310" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/4b20eec6-1685-4f4b-9fc9-f22dcdfc6d82">
    
    - put id and description
    - in your k8s cluster go to master node
    - then nevigate to ~/.kube dir and copy your content of config file
    - paste the content in jenkins cred in the section "kubeconfig", click on the radio button "enter directly" and past it there.
    - then in you cluster create "namespace" called jenkins.
    - then approve the stage and continue
 
- next "Check Deployment" it will check if its exists
- next "Deploy to Kubernetes" will deploy
- next "Check HTML Change" it will check if there is a changes on the html file and only if there is it will deploy it again.
- next "Start Port Forward" this stage will start the access to use the website.

---

&nbsp;
&nbsp;
&nbsp;
&nbsp;

this is the diagram of the stages and proceeses:

```mermaid
flowchart LR
    subgraph GitHub
        direction TB
        A(Pushing Code To Repo)
    end
    subgraph Jenkins
        direction TB
        B(Trigger Jenkins Automation) --> C(Pulling to code from github repo)
    end
    subgraph DockerHub
        direction TB
        D(Uploading_image_to_DockerHub) --> E(Creating_Docker_image_from_code)
    end
    subgraph K8S
        direction TB
        F(Creating_a_deployment_to_check_employee_code)
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

  
