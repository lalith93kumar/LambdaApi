output "lambdaAssumRoleARN" {
  value = aws_iam_role.lambdaRole.arn
  description = "VPC ID"
}

output "lambdaAssumRoleName" {
  value = aws_iam_role.lambdaRole.name
  description = "VPC ID"
}