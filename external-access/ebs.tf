# EBS volume based on which the snapshot is created
resource "aws_ebs_volume" "external_access" {
  availability_zone = "eu-north-1a"
  size              = 1
  encrypted         = true
  kms_key_id        = aws_kms_key.external_access.arn
}

# EBS Snapshot allowing access from the account 789815788242
resource "aws_ebs_snapshot" "external_access" {
  volume_id   = aws_ebs_volume.external_access.id
  description = "Snapshot for testing external access"

  tags = {
    Name = "External Access Snapshot"
  }
}

resource "aws_snapshot_create_volume_permission" "external_access" {
  account_id  = "789815788242"
  snapshot_id = aws_ebs_snapshot.external_access.id
}
