resource "aws_cloudwatch_log_group" "pipelineCloudWatch" {
  name = "codePipelinelogs-${var.repositoryName}"

  tags = {
    Environment = "production"
    Application = "pipeline"
  }
}