resource "aws_iam_user" "github_automation" {
  name = "github-automation"
}

resource "aws_iam_access_key" "github_automation_access_key" {
  user = aws_iam_user.github_automation.name
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ECRFullAccessPolicy"
  description = "Policy to allow full access to a specific ECR repository"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ecr:*",
        Resource = "arn:aws:ecr:eu-west-1:975050008954:repository/${var.cluster_name}"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_policy" {
  name        = "EKSFullAccessPolicy"
  description = "Policy to allow full access to a specific EKS cluster"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "eks:*",
        Resource = "arn:aws:eks:eu-west-1:975050008954:cluster/${var.cluster_name}"
      }
    ]
  })
}

resource "aws_iam_policy" "secrets_manager_read_policy" {
  name        = "secrets_manager_read_policy"
  description = "Policy to allow read-only access to specific secrets"
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

resource "aws_iam_user_policy_attachment" "ecr_policy_attachment" {
  user       = aws_iam_user.github_automation.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_iam_user_policy_attachment" "eks_policy_attachment" {
  user       = aws_iam_user.github_automation.name
  policy_arn = aws_iam_policy.eks_policy.arn
}

output "access_key_id" {
  value = aws_iam_access_key.github_automation_access_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.github_automation_access_key.secret
  sensitive = true
}