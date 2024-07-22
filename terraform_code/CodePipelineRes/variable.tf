variable "region" {
    description = "aws region needs to be set "
}

variable "accountID" {
    description = "aws AccountID needs to be set "
}

variable "repositoryName" {
    description = "repository name"
}

variable "projectList" {
  default = [{"name"="ADockerBuild","specfile"="pipeline/buildspec_build.yml"},
  {"name"="BTerraformPlan","specfile"="pipeline/buildspec_plan.yml"},
  {"name"="CTerraformApply","specfile"="pipeline/buildspec_apply.yml"},
  {"name"="DTerraformDestroy-approval","specfile"="pipeline/buildspec_destroy.yml"}]
}

variable "clusterName" {
    description = "Cluster Name"
}