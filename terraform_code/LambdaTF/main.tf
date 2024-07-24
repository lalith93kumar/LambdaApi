module "dynamodb" {
    source = "./dynamodb"
}

module "iamRole" {
    source = "./iamRole"
    vehicleDynamodbTableArn = module.dynamodb.vehicleDynamodbTableArn
    repositoryName = var.repositoryName
}

module "archiveFile" {
    source = "./archiveZip"
}

module "lambda" {
    source = "./lambda"
    archiveFileBase64Sha = module.archiveFile.archiveFileBase64Sha
    lambdaAssumRoleARN = module.iamRole.lambdaAssumRoleARN
    repositoryName = var.repositoryName
}

module "cloudWatchLogs" {
    source = "./cloudWatch"
    lambdaFunctionArn = module.lambda.lambdaFunctionArn
    lambdaFunctionName = module.lambda.lambdaFunctionName
    repositoryName = var.repositoryName
}

module "apiGateway" {
    source = "./apiGateway"
    lambdaFunctionInvokeArn = module.lambda.lambdaFunctionInvokeArn
    lambdaFunctionName = module.lambda.lambdaFunctionName
    lambdaAssumRoleName = module.iamRole.lambdaAssumRoleName
    repositoryName = var.repositoryName
}