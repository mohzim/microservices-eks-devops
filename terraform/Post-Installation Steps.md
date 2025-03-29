1. Add k8s cluster policy to AWS User (Use UI and then add terraform scripts)

2. Add eks cluster to local kubeconfig

    `aws eks update-kubeconfig --region ap-south-1 --name my-cluster`


3. Change current context to eks cluster

    `kubectl config use-context eks-context-name`

4. Run Ansible script to install Prometheus and Grafana

    `ansible-playbook ../ansible/observability.yaml`

4. Get Grafana External IP and Prometheus-server internal ip

    `kubectl get service -n monitoring` 

6. Get Grafana Password to use in step 11

    `kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

7. Login into grafana

    `http://<LOADBALANCER URL>`

    Username: admin

    Password: \<Password from above step\>

8. Add Prometheus Datasource and Dashboard.

    a) In grafana, go to Menu > Connections > Data Sources > Add new data source > Select Prometheus. Set Prometheus server URL as http://ClusterIP and click save.

    b) In grafana, go to Menu > Dashboards > New > New Dashbard > Select Import a dashboard > Enter 315 into Find and import dashboards for common applications and Click Load > Select Prometheus datasource > Click Import. Repeat this step to add Dashboard ID 741 and 15760.
