resource "aws_iam_role" "codePipelineSericeRole" {
  name               = "codePipelineSericeRole"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect : "Allow",
          Principal : {
            Service : "codepipeline.amazonaws.com"
          },
          Action : [
            "sts:AssumeRole"
          ]
        }
      ]
    }
  )
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_role_policy" "code-pipeline-logs" {
  name   = "codePipelineLogsRolePolicy"
  role   = aws_iam_role.codeBuildServiceRole.id
  policy = aws_iam_role_policy.codeBuildServiceCloudWatchPolicy.policy
}

resource "aws_iam_role_policy" "code-pipeline-s3" {
  name   = "codePipelineS3RolePolicy"
  role   = aws_iam_role.codeBuildServiceRole.id
  policy = aws_iam_role_policy.codeBuildServiceS3Policy.policy
}