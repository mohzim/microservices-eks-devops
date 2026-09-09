# Purpose: Create EKS cluster

module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.0"
  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnets

  enable_irsa            = true # IAM roles for service accounts (IRSA) is a feature of Amazon EKS that lets you connect AWS IAM roles to Kubernetes service accounts. This allows applications to use AWS services while running in Kubernetes clusters
  endpoint_public_access = true # Allow public access to the k8s API server

  tags = {
    cluster = "demo"
  }

  vpc_id = module.vpc.vpc_id

  # Define Node groups
  eks_managed_node_groups = {
    node_group = {
      ami_type               = "AL2023_x86_64_STANDARD"
      instance_types         = ["t3.medium"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }
}

