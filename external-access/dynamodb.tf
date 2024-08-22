# DynamoDB table allowing access from the account 789815788242
resource "aws_dynamodb_table" "external_access" {
  name             = "sap-table-external-access-eu-north-1"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  range_key        = "date"
  stream_enabled   = true
  stream_view_type = "KEYS_ONLY"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }
}

resource "aws_dynamodb_resource_policy" "external_access" {
  resource_arn = aws_dynamodb_table.external_access.arn
  policy       = data.aws_iam_policy_document.table.json
}

# Allow acces to both the table and the stream
data "aws_iam_policy_document" "table" {
  statement {
    actions = [
      "dynamodb:GetItem",
    ]
    resources = [
      aws_dynamodb_table.external_access.arn,
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::789815788242:root"]
    }
  }
}
