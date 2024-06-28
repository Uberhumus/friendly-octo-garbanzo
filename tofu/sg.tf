# security-groups.tf
resource "aws_security_group" "eks_cluster" {
  name        = "eks-cluster-sg"
  description = "EKS Cluster security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow communication within the cluster"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_security_group" "eks_node" {
  name        = "eks-node-sg"
  description = "EKS Node security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow communication with the cluster API server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [
      aws_security_group.eks_cluster.id,
    ]
  }

  ingress {
    description = "Allow communication within the VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  # This is for debug and should be removed once the connectivity is verified
  ingress {
    description = "Allow all access from my IP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}