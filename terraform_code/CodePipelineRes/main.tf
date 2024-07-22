module "pipelineCloudWatch" {
    source = "./cloudWatch"
    repositoryName = var.repositoryName
}

module "ArtifactoryBucket" {
    source = "./s3"
    repositoryName = module.fetchRepoCodeCommit.repositoryName
}

module "iamRole" {
    source = "./iam"
    repositoryName = module.fetchRepoCodeCommit.repositoryName
    s3BucketArn = module.ArtifactoryBucket.s3BucketArn
    cloudWatchLogGroupArn = module.pipelineCloudWatch.cloudWatchLogGroupArn
    s3BucketTerraformBackupArn = module.ArtifactoryBucket.s3BucketTerraformBackupArn
}

module "CodeBuildProjectsDockerBuild" {
    source = "./codeBuild"
    repositoryUrl = module.fetchRepoCodeCommit.repositoryUrl
    branch = "master"
    repositoryName = module.fetchRepoCodeCommit.repositoryName
    codeBuildIamArn = module.iamRole.codeBuildIamArn
    cloudWatchLogGroup = module.pipelineCloudWatch.cloudWatchLogGroupName
    projectList = var.projectList
}

module "CodePipelineProjectsDockerBuild" {
    source = "./codePipeline"
    repositoryUrl = module.fetchRepoCodeCommit.repositoryUrl
    branch = "master"
    repositoryName = module.fetchRepoCodeCommit.repositoryName
    codePipelineIamArn = module.iamRole.codePipelineIamArn
    s3BucketId = module.ArtifactoryBucket.s3BucketId
    DockerBuildProjectName = toset(module.CodeBuildProjectsDockerBuild.DockerBuildProjectName)
    accountID = var.accountID
    region = var.region
    clusterName = var.clusterName
}