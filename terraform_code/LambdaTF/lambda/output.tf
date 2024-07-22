output "lambdaFunctionArm" {
  value = aws_lambda_function.test_lambda_function.arn
  description = "VPC ID"
}

output "lambdaFunctionName" {
  value = aws_lambda_function.test_lambda_function.function_name
  description = "VPC ID"
}