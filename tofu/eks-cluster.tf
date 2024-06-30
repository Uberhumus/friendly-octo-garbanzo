# eks-cluster.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets

  eks_managed_node_group_defaults = {
    ami_type        = "AL2_x86_64"
    instance_type   = var.instance_type
    desired_size    = var.desired_capacity
    min_size        = var.min_capacity
    max_size        = var.max_capacity
    key_name        = var.key_name
  }

  eks_managed_node_groups = {
    eks_nodes = {
      name = "eks-nodes"
    }
  }

  iam_role_additional_policies = [
    {
      policy_name = "secrets_manager_read_policy"
      policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": "arn:aws:secretsmanager:eu-west-1:975050008954:secret:SuperSecretNASAToken*"
        }
    ]
}
EOF
    }
  ]

  node_security_group_additional_rules = {
    open_app_port = {
      description              = "Allow inbound traffic on port 30001"
      from_port                = 30001
      to_port                  = 30001
      protocol                 = "tcp"
      type                     = "ingress"
      cidr_blocks              = ["0.0.0.0/0"]
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