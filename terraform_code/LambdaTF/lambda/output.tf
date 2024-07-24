output "lambdaFunctionArn" {
  value = aws_lambda_function.test_lambda_function.arn
  description = "Lambda Funaction ARN"
}

output "lambdaFunctionInvokeArn" {
  value = aws_lambda_function.test_lambda_function.invoke_arn
  description = "Lambda Funaction Invoke ARN"
}

output "lambdaFunctionName" {
  value = aws_lambda_function.test_lambda_function.function_name
  description = "Lambda Funaction Name"
}