variable "repositoryName" {
    description = "repository name"
}

variable "s3BucketArn" {
    description = "arn s3 bucket for pipeline"
}

variable "cloudWatchLogGroupArn" {
    description = "arn cloudWatch Arn for pipeline"
}

variable "s3BucketTerraformBackupArn" {
    description = "arn s3 Arn for Terraform BackUp"
}