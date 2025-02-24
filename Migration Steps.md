# Migrating Strategy/Plan for On Prem to AWS Cloud Kubernetes
High level steps to migrate on prem to AWS Cloud Kubernetes. 

## 1. POC
Perfom a POC for you applications. Identify a pilot project from POC. 

## 2. Analysis
Identify which applications are ready for cloud native. These applications can be immediately converted to Docker images. Other applications would require change in code. 
What are my application dependencies - inter and databases. This is required for Architecture design. 
At this point start drafting high level architecture to start with to build on later. Don't change stuff already in place such as already using Jenkins, ELK for observablity, etc. if not a show stopper. Minimize changes. 

## 2. POC
- Perform POC for your applications at small scale but medium complexity.
- Identify show stoppers and potential low risk pilot project. 

## 3. Architecture
- Define Architecture goals - need HA, security, latency, etc. 
- Define architecture for various environments. 
- Minimize changes by keeping components such as Jenkisn, ELK for Observability already being used in the project. 
- Document High Availablity, Security, Networking for the solutions. 
- Identify tools to provide CI, CD, IaC, Observability and Backup
- Identify pilot project

## 4. Pilot Project
- Identify low risk applicaitons to pilot for Kubernetes migration. 
- Deploy in Prod and identify learnings. 
- Provide Docker template with standard usages. For e.g. for 1000 RPS we would need 0.1% CPU with 10 instances, etc.


## 5. Break into Phases
- After successfull pilot, break larger project into phases and deploy in various environment. 


Questions:
- How did you data migration with zero downtime. 
    We did not migrate ElasticSearch to Kubernetes. We kept it on EC2 instances. -


