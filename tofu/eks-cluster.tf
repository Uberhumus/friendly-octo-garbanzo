# eks-cluster.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets

  cluster_security_group_id = aws_security_group.eks_cluster.id
  node_security_group_id    = aws_security_group.eks_node.id

  eks_managed_node_group_defaults = {
    ami_type        = "AL2_x86_64"
    instance_type   = var.instance_type
    desired_size    = var.desired_capacity
    min_size        = var.min_capacity
    max_size        = var.max_capacity
    key_name        = var.key_name
    additional_security_group_ids = [aws_security_group.eks_node.id]
  }

  eks_managed_node_groups = {
    eks_nodes = {
      name = "eks-nodes"
    }
  }

  tags = {
    Environment = var.environment
    Name        = var.cluster_name
  }

  # Additional configuration for the cluster
  # Public access should be removed later
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true
}