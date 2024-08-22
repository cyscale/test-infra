# EFS file system allowing access from the account 789815788242
resource "aws_efs_file_system" "external_access" {
  creation_token = "sap-efs-external-access-eu-north-1"
  encrypted      = true
  kms_key_id     = aws_kms_key.external_access.arn
}

resource "aws_efs_file_system_policy" "external_access" {
  file_system_id = aws_efs_file_system.external_access.id
  policy         = data.aws_iam_policy_document.efs.json
}

data "aws_iam_policy_document" "efs" {
  statement {
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:ClientWrite",
    ]
    resources = [
      aws_efs_file_system.external_access.arn,
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::789815788242:root"]
    }
  }
}
