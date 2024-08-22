# KMS Key allowing access from the account 789815788242
resource "aws_kms_key" "external_access" {
  description             = "sap-kms-external-access-eu-north-1"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "external_access" {
  name          = "alias/sap-kms-external-access-eu-north-1"
  target_key_id = aws_kms_key.external_access.key_id
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.external_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_grant" "external_access" {
  key_id            = aws_kms_key.external_access.key_id
  grantee_principal = "arn:aws:iam::789815788242:root"
  operations        = ["Decrypt"]
}
