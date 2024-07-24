output "lambdaAssumRoleARN" {
  value = aws_iam_role.lambdaRole.arn
  description = "Iam Role ARN to attach to Lamda function"
}

output "lambdaAssumRoleName" {
  value = aws_iam_role.lambdaRole.name
  description = "Iam Role Name to attach to Lamda function"
}