output "archiveFileBase64Sha" {
  value = data.archive_file.python_lambda_package.output_base64sha256
  description = "VPC ID"
}