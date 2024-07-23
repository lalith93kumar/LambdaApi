resource "aws_codepipeline" "example" {
  name = "${var.repositoryName}-pipeline"

  role_arn = var.codePipelineIamArn

  artifact_store {
    location = var.s3BucketId
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      configuration = {
        ConnectionArn = aws_codestarconnections_connection.gitHubConnection.arn
        FullRepositoryId = var.repositoryUrl
        BranchName     = var.branch
      }

      output_artifacts = ["source_artifact"]
    }
  }

  dynamic stage {
    for_each = var.DockerBuildProjectName
    content {
      name = split("-",stage.value)[0]
      dynamic action {
        for_each = strcontains(lower(split("-",stage.value)[1]),"approval") ? [1] : []
        content {
          name     = "Approval"
          category = "Approval"
          owner    = "AWS"
          provider = "Manual"
          version  = "1"
        }
      }
      dynamic action {
        for_each = strcontains(lower(split("-",stage.value)[1]),"approval") ? [] : [1]
        content {
          name            = split("-",stage.value)[0]
          category        = "Build"
          owner           = "AWS"
          provider        = "CodeBuild"
          version         = "1"
          input_artifacts = ["source_artifact"]
          configuration = {
            ProjectName = stage.value,
            EnvironmentVariables = jsonencode([
              {
                name  = "AWS_DEFAULT_REGION"
                type  = "PLAINTEXT"
                value = "${var.region}"
              },
              {
                name  = "REPOSITORYNAME"
                type  = "PLAINTEXT"
                value = "${var.repositoryName}"
              }
              ])
          }
        }
      }
    }
  }
}

resource "aws_codestarconnections_connection" "gitHubConnection" {
  name          = "gitHubConnection"
  provider_type = "GitHub"
}