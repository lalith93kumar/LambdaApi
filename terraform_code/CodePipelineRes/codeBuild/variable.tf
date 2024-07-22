variable "repositoryName" {
    description = "repository name"
}

variable "codeBuildIamArn" {
  description = "code build Iam role -> arn"
}

variable "branch" {
  description = "Repository branch name"
}

variable "cloudWatchLogGroup" {
  description = "cloud watch log Group"
}

variable "projectList" {
  default = []
}