module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "home-assignment-yotam"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

    # Registry Scanning Configuration
  manage_registry_scanning_configuration = true
  registry_scan_type                     = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = [
        {
          filter_type = "WILDCARD"
          filter      = "*"
        }
      ]
    }
    ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}