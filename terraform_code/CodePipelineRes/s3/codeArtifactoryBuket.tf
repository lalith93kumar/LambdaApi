resource "aws_s3_bucket" "codeArtifactoryBucket" {
  bucket = lower("PipelineArtifact${var.repositoryName}")
  force_destroy = true
}