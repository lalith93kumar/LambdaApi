output "codeBuildIamArn" {
  value = aws_iam_role.codeBuildServiceRole.arn
  description = "code build Iam role -> arn"
}

output "codePipelineIamArn" {
  value = aws_iam_role.codePipelineSericeRole.arn
  description = "code Pipeline Iam role -> arn"
}