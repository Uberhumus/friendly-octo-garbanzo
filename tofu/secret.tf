module "secrets_manager" {
  source = "terraform-aws-modules/secrets-manager/aws"

  # Secret
  name                    = "SuperSecretNASAToken2"
  description             = "Token for NASA API"
  recovery_window_in_days = 7

  # Policy
  create_policy = false

  # Version
  secret_string = var.supersecret

  tags = {
    Environment = "Development"
    Project     = "home-assignment-yotam"
  }
}