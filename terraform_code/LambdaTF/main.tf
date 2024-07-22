module "dynamodb" {
    source = "./dynamodb"
}

module "iamRole" {
    source = "./iamRole"
    vehicleDynamodbTableArn = module.dynamodb.vehicleDynamodbTableArn
}

module "archiveFile" {
    source = "./archiveZip"
}

module "lambda" {
    source = "./lambda"
    archiveFileBase64Sha = module.archiveFile.archiveFileBase64Sha
    lambdaAssumRoleARN = module.iamRole.lambdaAssumRoleARN
}

module "cloudWatchLogs" {
    source = "./cloudWatch"
    lambdaFunctionArm = module.lambda.lambdaFunctionArm
    lambdaFunctionName = module.lambda.lambdaFunctionName
}