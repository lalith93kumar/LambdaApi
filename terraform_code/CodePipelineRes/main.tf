module "pipelineCloudWatch" {
    source = "./cloudWatch"
    repositoryName = var.repositoryName
}

module "ArtifactoryBucket" {
    source = "./s3"
    repositoryName = var.repositoryName
}

module "iamRole" {
    source = "./iam"
    repositoryName = var.repositoryName
    s3BucketArn = module.ArtifactoryBucket.s3BucketArn
    cloudWatchLogGroupArn = module.pipelineCloudWatch.cloudWatchLogGroupArn
    s3BucketTerraformBackupArn = module.ArtifactoryBucket.s3BucketTerraformBackupArn
}

module "CodeBuildProjectsDockerBuild" {
    source = "./codeBuild"
    branch = "main"
    repositoryName = var.repositoryName
    codeBuildIamArn = module.iamRole.codeBuildIamArn
    cloudWatchLogGroup = module.pipelineCloudWatch.cloudWatchLogGroupName
    projectList = var.projectList
}

module "CodePipelineProjectsDockerBuild" {
    source = "./codePipeline"
    branch = "main"
    repositoryName =var.repositoryName
    codePipelineIamArn = module.iamRole.codePipelineIamArn
    s3BucketId = module.ArtifactoryBucket.s3BucketId
    DockerBuildProjectName = toset(module.CodeBuildProjectsDockerBuild.DockerBuildProjectName)
    region = var.region
    repositoryUrl = var.repositoryUrl
}