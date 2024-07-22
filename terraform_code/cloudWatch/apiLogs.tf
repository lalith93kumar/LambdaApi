resource "aws_cloudwatch_event_rule" "test-lambda" {
  name                  = "run-lambda-function"
  description           = "Schedule lambda function"
  schedule_expression   = "rate(60 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda-function-target" {
  target_id = "lambda-function-target"
  rule      = aws_cloudwatch_event_rule.test-lambda.name
  arn       = var.lambdaFunctionArm
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = var.lambdaFunctionName
    principal = "events.amazonaws.com"
    source_arn = var.lambdaFunctionArm
}