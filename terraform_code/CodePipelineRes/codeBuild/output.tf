output "DockerBuildProjectName" {
  # value = aws_codebuild_project.dockerBuildProject.name
  value = [ for i in aws_codebuild_project.dockerBuildProject: "${i.name}"]
  description = "list of CodeBuild Project Names"
}