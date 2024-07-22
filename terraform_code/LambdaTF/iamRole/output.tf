output "lambdaAssumRoleARN" {
  value = aws_iam_role.lambdaRole.arn
  description = "VPC ID"
}