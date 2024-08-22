# SNS topic allowing access from the account 789815788242
resource "aws_sns_topic" "external_access" {
  name              = "sap-topic-external-access-eu-north-1"
  display_name      = "External Access"
  kms_master_key_id = aws_kms_key.external_access.id
}

resource "aws_sns_topic_policy" "external_access" {
  arn    = aws_sns_topic.external_access.arn
  policy = data.aws_iam_policy_document.topic.json
}

data "aws_iam_policy_document" "topic" {
  statement {
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.external_access.arn,
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::789815788242:root"]
    }
  }
}
