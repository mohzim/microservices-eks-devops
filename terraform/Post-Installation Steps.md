1. Add eks cluster to local kubeconfig

    `aws eks update-kubeconfig --region region-code --name my-cluster`

2. Add k8s cluster policy to AWS User (Use UI and then add terraform scripts)

3. Change current context to eks cluster

    `kubectl config use-context eks-context-name`

3. Run Ansible script to install Prometheus and Grafana

    `ansible-playbook ../ansible/observability.yaml`

4. Expose Prometheus and Grafana service using NodePort

    `kubectl apply -f terraform/manifest/prometheus-service.yaml`

    `kubectl apply -f terraform/manifest/grafana-service.yaml`

5. Get Node External IP to use in step 11

    `kubectl get nodes -o wide`

6. Get Grafana Password to use in step 11

    `kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

7. Login into grafana

    `http://<Node EXTERNAL IP>:32410`

    Username: admin

    Password: \<Password from above step\>

8. Add Prometheus Datasource and Dashboard.

    a) In grafana, go to Menu > Connections > Data Sources > Add new data source > Select Prometheus. Set Prometheus server URL as http://\<Node EXTERNAL IP\>:32510 and click save.

    b) In grafana, go to Menu > Dashboards > New > New Dashbard > Select Import a dashboard > Enter 315 into Find and import dashboards for common applications and Click Load > Select Prometheus datasource > Click Import.  

    c) In grafana, go to Menu > Dashboards > New > New Dashbard > Select Import a dashboard > Enter 741 into Find and import dashboards for common applications and Click Load > Select Prometheus datasource > Click Import. 