resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "this" {
  name = coalesce(var.user_name, var.bucket)
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:PutObject*"]
    resources = ["${aws_s3_bucket.this.arn}/${var.key}"]
  }
}

resource "aws_iam_user_policy" "this" {
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}