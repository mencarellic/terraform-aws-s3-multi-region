resource "aws_kms_alias" "bucket-encryption-west-2" {
  name          = "alias/mencarelli-${random_pet.s3-bucket.id}-west-2"
  target_key_id = aws_kms_key.bucket-encryption-west-2.id

  provider = aws.west-2
}

resource "aws_kms_alias" "bucket-encryption-east-2" {
  name          = "alias/mencarelli-${random_pet.s3-bucket.id}-east-2"
  target_key_id = aws_kms_key.bucket-encryption-east-2.id

  provider = aws.east-2
}

resource "aws_kms_key" "bucket-encryption-west-2" {
  description         = "Encryption for mencarelli-${random_pet.s3-bucket.id}-west-2"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.bucket-encryption-kms-policy.json

  provider = aws.west-2
}

resource "aws_kms_key" "bucket-encryption-east-2" {
  description         = "Encryption for mencarelli-${random_pet.s3-bucket.id}-east-2"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.bucket-encryption-kms-policy.json

  provider = aws.east-2
}

data "aws_iam_policy_document" "bucket-encryption-kms-policy" {
  statement {
    sid = "Allow access for Key Administrators"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/terraform"
      ]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "Allow use of the key for cross region replication"
    principals {
      type        = "AWS"
      identifiers = [local.account_id]
    }
    actions = [
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    resources = ["*"]
  }
}
