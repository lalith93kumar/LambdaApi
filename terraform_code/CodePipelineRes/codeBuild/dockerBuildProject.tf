resource "aws_codebuild_project" "dockerBuildProject" {
  name = join("-",[lookup(var.projectList[count.index],"name","codeBuildSample"),var.repositoryName])
  count = length(var.projectList)  
  service_role = var.codeBuildIamArn
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = var.cloudWatchLogGroup
      stream_name = join("-",[lookup(var.projectList[count.index],"name","codeBuildSample"),var.repositoryName])
    }
  }
  source {
    type            = "CODEPIPELINE"
    location        = var.repositoryUrl
    git_clone_depth = 0
    buildspec       = lookup(var.projectList[count.index],"specfile","codeBuildSample")
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  source_version = var.branch
}