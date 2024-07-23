variable "region" {
    default = "us-east-1"
    description = "aws region needs to be set "
}

variable "repositoryName" {
    default = "LambdaApi"
    description = "repository name"
}

variable "projectList" {
  default = [
  {"name"="BTerraformPlan","specfile"="pipeline/buildspec_plan.yml"},
  {"name"="CTerraformApply","specfile"="pipeline/buildspec_apply.yml"},
  {"name"="DMannual-approval"},
  {"name"="ETerraformDestroy-approval","specfile"="pipeline/buildspec_destroy.yml"}]
}


variable "repositoryUrl" {
  description = "Repository Url from github with http://github.com"
  default = "lalith93kumar/LambdaApi"
}