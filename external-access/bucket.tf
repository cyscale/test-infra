# S3 bucket allowing access from the account 789815788242
resource "aws_s3_bucket" "external_access" {
  bucket = "sap-bucket-external-access-eu-north-1"
}

resource "aws_s3_bucket_policy" "external_access" {
  bucket = aws_s3_bucket.external_access.id
  policy = data.aws_iam_policy_document.bucket.json
}

data "aws_iam_policy_document" "bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::sap-bucket-external-access-eu-north-1/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::789815788242:root"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "external_access" {
  bucket                  = aws_s3_bucket.external_access.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
