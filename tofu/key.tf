module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = var.key_name
  create_private_key = true
}

output "private_key" {
  value = module.key_pair.private_key_pem
  sensitive = true
}