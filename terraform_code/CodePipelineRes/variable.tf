variable "region" {
    default = "us-east-1"
    description = "aws region needs to be set "
}

variable "repositoryName" {
    default = "LambdaApi"
    description = "repository name"
}

variable "projectList" {
  default = [{"name"="BTerraformPlan","specfile"="pipeline/buildspec_plan.yml"}]
}