module "test-ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "home-assignment-yotam-testing"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_image_tag_mutability = "MUTABLE"

  # Registry Scanning Configuration
  manage_registry_scanning_configuration = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}