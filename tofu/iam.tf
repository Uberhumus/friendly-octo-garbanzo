resource "aws_iam_user" "github_automation" {
  name = "github-automation"
}

resource "aws_iam_access_key" "github_automation_access_key" {
  user = aws_iam_user.github_automation.name
}

resource "aws_iam_policy" "github_automation_ecr_policy" {
  name        = "GithubECRAccessPolicy"
  description = "Policy to allow full access to a specific ECR repository"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:UntagResource",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:InitiateLayerUpload",
          "ecr:ReplicateImage",
          "ecr:GetRepositoryPolicy",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetLifecyclePolicy"
        ],
        "Resource" : "arn:aws:ecr:eu-west-1:975050008954:repository/home-assignment-yotam"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetRegistryPolicy",
          "ecr:DescribeRegistry",
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "github_automation_eks_policy" {
  name        = "GithubEKSAccessPolicy"
  description = "Policy to allow full access to a specific EKS cluster"
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "eks:*",
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_secrets_manager_read_policy" {
  name        = "eks_secrets_manager_read_policy_2"
  description = "Policy to allow read-only access to specific secrets"
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action" = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" = "arn:aws:secretsmanager:eu-west-1:975050008954:secret:SuperSecretNASAToken*"
      }
    ]

  })
}

resource "aws_iam_user_policy_attachment" "github_automation_ecr_policy_attachment" {
  user       = aws_iam_user.github_automation.name
  policy_arn = aws_iam_policy.github_automation_ecr_policy.arn
}

resource "aws_iam_user_policy_attachment" "github_automation_eks_policy_attachment" {
  user       = aws_iam_user.github_automation.name
  policy_arn = aws_iam_policy.github_automation_eks_policy.arn
}

resource "aws_iam_user_policy_attachment" "github_automation_secrets_manager_policy_attachment" {
  user       = aws_iam_user.github_automation.name
  policy_arn = aws_iam_policy.eks_secrets_manager_read_policy.arn

}

output "access_key_id" {
  value = aws_iam_access_key.github_automation_access_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.github_automation_access_key.secret
  sensitive = true
}