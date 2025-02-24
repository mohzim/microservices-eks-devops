# microservices-eks-devops
DevOps project to deploy microservices based application on AWS EKS clusters using Jenkins, Helm Charts, ArgoCD, Terraform etc. 

## Overview
This repo provides steps to migrate legacy platform to AWS cloud environment, define architecture following best practices of security and business continuty and implement the solution on AWS Cloud using Kubernetes, Terraform, Jenkins and ArgoCD.   sets up Kubernetes cluster on IONOS Cloud using terraform. It deploys highly available web appliction (wordpress-nginx) with helm charts. Additonally provides instruction to setup Prometheus and Grafana for monitoring as well as Velero for Backup solution for Kubernetes clusters. 

Please note that this repo is for demo purpose only and should not be used in Production environments. 

## Prerequisite
1. [Download](https://docs.ionos.com/cli-ionosctl) and [configure](https://registry.terraform.io/providers/ionos-cloud/ionoscloud/latest/docs) IONOS CLI for your IONOS Account. 
2. [Download](https://git-scm.com/downloads) Git. 
3. [Download](https://developer.hashicorp.com/terraform/install?product_intent=terraform) and install Terraform.
4. [Download](https://helm.sh/docs/intro/install/) and and install Helm. 
5. [Download](https://velero.io/docs/v1.6/basic-install/) and and install Velero CLI

## Steps

### Clone repo and push docker image

1. Clone this GitHub Repo

    `git clone https://github.com/mohzim/wordpress-app-devops`


### Setup reources on IONOS Cloud   

3. Initialize terraform

    `cd terraform-ionos`

    `terraform init`

4. Verify resource creation
        
    `terraform plan -var-file="devops.tfvars"`

5. Create resources in IONOS Cloud
        
    `terraform apply -var-file="devops.tfvars"`

        Note: 
        Please find below sample devops.tfvars that needs to be created in 'wordpress-app-devops/terraform-ionos/'location. 
        Replace values with actual token/username/password. 

            ionos_token = "<Your IONOS Token"
            db_username = "<Maria DB Username"
            db_password = "<Maria DB Password>"

### Setup kubectl to connect to IONOS Kubernetes Cluster

6. Login into IONOS Cloud with your credentials. Go to Containers > Managed Kubernetes > Select your Kubernetes cluster > click Download kubeconfig.yaml

7. Rename your exising config file in ~/.kube/. 

    `mv ~/.kube/config ~/.kube/config_bk`

8. Copy downloaded kubeconfig.yaml to ~/.kube/ and rename it as 'config'

    `mv ~/.kube/kubeconfig.yaml ~/.kube/config`

9. Go to wordpress-app-devops/terraform-ionos folder and check you can access your kuberntes cluster with below command. 

    `cd wordpress-app-devops/terraform-ionos`

    `kubectl get nodes`

### Install nginx-wordpress using Helm Chart

10. Create and install Helm Chart in Kubernetes Cluster

    `cd ..`

    `helm install my-wordpress-v1 helm/myfirstchart `

    `helm list`

    `helm status my-wordpress-v1 --show-resources`

11. Wait and get loadbalancer 'EXTERNAL-IP' with below command.

    `kubectl get service my-wordpress-v1-myfirstchart `

12. Access the wordpress-nginx app with the url: 

    `http://<EXTERNAL-IP>:80/readme.html`

### Install Prometheus and Grafana

13. Install Prometheus and Grafana using Helm Charts

    `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`

    `helm repo add grafana https://grafana.github.io/helm-charts`

    `helm repo update`

    `helm install prometheus prometheus-community/prometheus`

    `helm install grafana grafana/grafana`
    
14. Expose Prometheus and Grafana service using NodePort

    `kubectl apply -f terraform-ionos/manifest/prometheus-service.yaml`

    `kubectl apply -f terraform-ionos/manifest/grafana-service.yaml`

15. Get Node External IP to use in step 11

    `kubectl get nodes -o wide`

16. Get Grafana Password to use in step 11

    `kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

17. Login into grafana

    `http://<Node EXTERNAL IP>:32410`

    Username: admin

    Password: \<Password from above step\>

18. Add Prometheus Datasource and Dashboard.

    a) In grafana, go to Menu > Connections > Data Sources > Add new data source > Select Prometheus. Set Prometheus server URL as http://\<Node EXTERNAL IP\>:32510 and click save.

    b) In grafana, go to Menu > Dashboards > New > New Dashbard > Select Import a dashboard > Enter 315 into Find and import dashboards for common applications and Click Load > Select Prometheus datasource > Click Import.  

    c) In grafana, go to Menu > Dashboards > New > New Dashbard > Select Import a dashboard > Enter 741 into Find and import dashboards for common applications and Click Load > Select Prometheus datasource > Click Import. 

### Setup Velero - Backup and Restore Solution
    (Below steps for Velero have not been tested)

19. [Install](https://github.com/vmware-tanzu/helm-charts/blob/main/charts/velero/README.md) Velero using Helm

        helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts 

        helm install velero vmware-tanzu/velero \
            --namespace <YOUR NAMESPACE> \
            --create-namespace \
            --set-file credentials.secretContents.cloud=<FULL PATH TO FILE> \
            --set configuration.backupStorageLocation[0].name=<BACKUP STORAGE LOCATION NAME> \
            --set configuration.backupStorageLocation[0].provider=<PROVIDER NAME> \
            --set configuration.backupStorageLocation[0].bucket=<BUCKET NAME> \
            --set configuration.backupStorageLocation[0].config.region=<REGION> \
            --set configuration.volumeSnapshotLocation[0].name=<VOLUME SNAPSHOT LOCATION NAME> \
            --set configuration.volumeSnapshotLocation[0].provider=<PROVIDER NAME> \
            --set configuration.volumeSnapshotLocation[0].config.region=<REGION> \
            --set initContainers[0].name=velero-plugin-for-<PROVIDER NAME> \
            --set initContainers[0].image=velero/velero-plugin-for-<PROVIDER NAME>:<PROVIDER PLUGIN TAG> \
            --set initContainers[0].volumeMounts[0].mountPath=/target \
            --set initContainers[0].volumeMounts[0].name=plugins


## Cleanup 

1. Remove Helm Chart

    `helm uninstall my-wordpress-v1`

2. Destroy cloud resources

    `cd terraform-ionos`
    
    `terraform destroy -var-file="devops.tfvars"`


## Challenges
1. Faced issues in merging nginx alpine image with php-fpm. Also in current ubuntu image nginx is not getting response from php-fpm server. Needed more time troubleshooting and marked for later. 
2. Authentication with IONOS API failed through token if using through UI. Should generate using ionosctl.
3. Could not find API documentation for cpu_family string for k8s nodepool creation. (Went to UI and got values from browser request F5)
4. kubectl expose service command throwing error while exposing grafana or prometheus service.   

## To Do List
1. Update docker image to inherit from alpine version and verify CVE.
2. Add Persistent Volume for Prometheus and Grafana. 
3. Setup and verify Velero backup and resoration solution. 
