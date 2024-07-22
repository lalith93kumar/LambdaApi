resource "aws_lambda_function" "test_lambda_function" {
    function_name = "lambdaTest"
    filename      = "nametest.zip"
    source_code_hash = var.archiveFileBase64Sha
    role          = var.lambdaAssumRoleARN
    runtime       = "python3.12"
    handler       = "lambdaFunction.lambda_handler"
    timeout       = 10
    environment {
        variables = {
        DynamodbTrackerARN = aws_lambda_function.DynamodbTracker.arn
        }
    }
}

resource "aws_lambda_function" "DynamodbTracker" {
    function_name = "DynamodbTracker"
    filename      = "nametest.zip"
    source_code_hash = var.archiveFileBase64Sha
    role          = var.lambdaAssumRoleARN
    runtime       = "python3.12"
    handler       = "dynamodbWorker.dynamodb_handler"
    timeout       = 10
}