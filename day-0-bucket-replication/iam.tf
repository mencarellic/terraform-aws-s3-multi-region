resource "aws_iam_role" "replication" {
  name = "s3-bucket-replication-app-artifact-role"

  assume_role_policy = data.aws_iam_policy_document.s3-bidirectional-replication-assume-role-policy.json
}

data "aws_iam_policy_document" "s3-bidirectional-replication-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3-bidirectional-replication-policy" {
  statement {
    sid = "CrossRegionReplication"
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold",
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = [
      aws_s3_bucket.app-artifact-east-2.arn,
      aws_s3_bucket.app-artifact-west-2.arn,
      "${aws_s3_bucket.app-artifact-east-2.arn}/*",
      "${aws_s3_bucket.app-artifact-west-2.arn}/*",
    ]
    condition {
      test     = "StringLikeIfExists"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms", "AES256"]
    }
    condition {
      test     = "StringLikeIfExists"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values = [
        aws_kms_key.bucket-encryption-west-2.arn,
        aws_kms_key.bucket-encryption-east-2.arn
      ]
    }
  }

  statement {
    sid = "CrossRegionEncryption"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.bucket-encryption-west-2.arn,
      aws_kms_key.bucket-encryption-east-2.arn
    ]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "s3.${aws_s3_bucket.app-artifact-east-2.region}.amazonaws.com",
        "s3.${aws_s3_bucket.app-artifact-west-2.region}.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values = [
        "${aws_s3_bucket.app-artifact-east-2.arn}/*",
        "${aws_s3_bucket.app-artifact-west-2.arn}/*"
      ]
    }
  }
}

resource "aws_iam_role_policy" "s3-bidirectional-replication-policy" {
  name   = "s3-bucket-replication-app-artifact-policy"
  role   = aws_iam_role.replication.name
  policy = data.aws_iam_policy_document.s3-bidirectional-replication-policy.json
}
