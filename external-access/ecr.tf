# ECR repository allowing access from the account 789815788242
resource "aws_ecr_repository" "external_access" {
  name                 = "sap-ecr-external-access-eu-north-1"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "external_access" {
  repository = aws_ecr_repository.external_access.name
  policy     = data.aws_iam_policy_document.ecr.json
}

data "aws_iam_policy_document" "ecr" {
  statement {
    effect = "Allow"
    sid    = "AllowExternalAccess"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    principals {
      type        = "AWS"
      identifiers = [local.external_principal]
    }
  }
}
