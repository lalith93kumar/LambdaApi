output "s3BucketId" {
  value = aws_s3_bucket.codeArtifactoryBucket.id
  description = "S3 Bucket ID for Code Build Artifactary"
}

output "s3BucketArn" {
  value = aws_s3_bucket.codeArtifactoryBucket.arn
  description = "S3 Bucket ARN for Code Build Artifactary"
}

output "s3BucketTerraformBackupArn" {
  value = data.aws_s3_bucket.terraformBackupFlaskAPIBucket.arn
  description = "S3 Bucket ID for Terraform Backend Backup"
} 