data "aws_s3_bucket" "terraformBackupFlaskAPIBucket" {
  bucket = lower("terraform-codepipeline-api")
}