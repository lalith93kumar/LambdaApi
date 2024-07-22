variable "codePipelineIamArn" {
  description = "code build Iam role -> arn"
}

variable "repositoryUrl" {
  description = "Repository Url from codeCommit"
}

variable "branch" {
  description = "Repository branch name"
}


variable "repositoryName" {
  description = "Repository name"
}


variable "DockerBuildProjectName" {
  type = set(string)
  description = "Code Build Project Name list"
}

variable "s3BucketId" {
  description = "s3 artifact bucket ID"
}


variable "accountID" {
    description = "AWS AccountID"
}

variable "region" {
    description = "aws region needs to be set"
}

variable "clusterName" {
    description = "Cluster Name"
}