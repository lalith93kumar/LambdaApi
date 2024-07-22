resource "aws_iam_role" "codeBuildServiceRole" {
  name               = "codeBuild-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_role_policy" "codeBuildServiceCloudWatchPolicy" {
  name   = "codeBuildLogsRolePolicy"
  role   = aws_iam_role.codeBuildServiceRole.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = [
            "${var.cloudWatchLogGroupArn}",
            "${join(":", [var.cloudWatchLogGroupArn, "*"])}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "codeBuildServiceS3Policy" {
  name   = "codeBuildS3RolePolicy"
  role   = aws_iam_role.codeBuildServiceRole.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Resource = [
            var.s3BucketArn,
            var.s3BucketTerraformBackupArn
          ],
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        }
      ]
    }
  )
}