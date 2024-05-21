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
<h4>click on "Build With Parameters"</h4>
<br/>
<img width="603" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/97f8fad0-9c9a-4497-a446-8926e47470f5">
<br/>
<h4> then insert your branch name and click on "build" </h4>
<br/>
<img width="1061" alt="image" src="https://github.com/IftachZilcaPaz/final_proj_git_jenkins/assets/151572520/de80dee1-f66c-4171-a1f7-f253aebdb22f">
</p>
<br/>

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

  
