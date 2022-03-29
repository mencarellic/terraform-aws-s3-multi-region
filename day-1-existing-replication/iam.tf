resource "aws_iam_role" "s3-batch-copy" {
  name               = "s3-batch-copy"
  assume_role_policy = data.aws_iam_policy_document.s3-batch-copy-assume-role-policy.json
}

resource "aws_iam_role_policy" "s3-batch-copy" {
  name = "s3-batch-copy"
  role = aws_iam_role.s3-batch-copy.id

  policy = data.aws_iam_policy_document.s3-batch-copy.json

}

data "aws_iam_policy_document" "s3-batch-copy-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["batchoperations.s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3-batch-copy" {
  statement {
    sid = "DestinationBucket"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectLegalHold",
      "s3:PutObjectRetention",
      "s3:GetBucketObjectLockConfiguration"
    ]

    resources = [
      "${aws_s3_bucket.app-artifact-west-2.arn}/*"
    ]
  }

  statement {
    sid = "SourceBucket"
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging"
    ]

    resources = [
      "${aws_s3_bucket.app-artifact-east-2.arn}/*"
    ]
  }

  statement {
    sid = "InventoryBucket"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "${aws_s3_bucket.inventory.arn}/${aws_s3_bucket.app-artifact-east-2.bucket}/EntireBucketDaily/*"
    ]
  }

  statement {
    sid = "ReportPut"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.inventory.arn}/batch-job-reports/*"
    ]
  }

  statement {
    sid = "KMSAccess"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]

    resources = [
      aws_kms_key.bucket-encryption-east-2.arn,
      aws_kms_key.bucket-encryption-west-2.arn
    ]
  }
}