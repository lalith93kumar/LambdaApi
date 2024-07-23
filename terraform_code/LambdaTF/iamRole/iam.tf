data "aws_iam_policy_document" "lambdaAssumRolePolicy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambdaRole" {  
  name = "${var.repositoryName}-lambdaRole-waf"  
  assume_role_policy = data.aws_iam_policy_document.lambdaAssumRolePolicy.json
}

resource "aws_iam_role_policy" "dynamodbAccessPolicy" {
  name   = "${var.repositoryName}-ecrPolicy"
  role   = aws_iam_role.lambdaRole.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        Resource = [
          var.vehicleDynamodbTableArn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}