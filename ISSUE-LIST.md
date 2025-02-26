# Issue List
This contains various issues encountered while working on this project



1. Git Error "RPC failed; HTTP 400 curl 22 The requested URL returned error: 400"
    * Error Message: "error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
    send-pack: unexpected disconnect while reading sideband packet"
    * Solution: Increase git buffer with below command
    
        `git config http.postBuffer 524288000`

2. After running terraform scripts, unable to access k8s cluster with local kubectl. Following are the two error recieved:
    * Error Message 1: E0226 20:39:59.087547    7927 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: the server has asked for the client to provide credentials"
    * Error Message 2: Error from server (Forbidden): nodes is forbidden: User "arn:aws:iam::735192208251:user/training_admin" cannot list resource "nodes" in API group "" at the cluster scope
    * Solution: Configure kubectl to access EKS Cluster with these two steps    
        - [Configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html)
        - [Update kubeconfig](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

    