output "cloudWatchLogGroupName" {
  value = aws_cloudwatch_log_group.pipelineCloudWatch.name
  description = "Repository Url from codeCommit"
}

output "cloudWatchLogGroupArn" {
  value = aws_cloudwatch_log_group.pipelineCloudWatch.arn
  description = "Repository Url from codeCommit"
}