# LambdaApi

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://shields.io/)

This repository contains an AWS Lambda function designed to process vehicle telematics data. The Lambda function receives data from telematics devices, processes the data to determine vehicle statistics, and stores the data in a DynamoDB table.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Running the Application](#running-the-application)
- [Usage](#usage)
- [Terraform](#terraform)
- [ToDo](#todo)

## Features

- Processes compressed and encoded telematics data.
- Validates input data for required fields and correct formats.
- Stores data in an AWS DynamoDB table.
- Computes statistics such as total number of vehicles, the fastest vehicle, and average speed.

## Prerequisites

- AWS Account
- AWS CLI configured with appropriate permissions
- Python 3.x
- boto3 library
- Terraform (for infrastructure setup)

## Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/lalith93kumar/PythonApiSolventum.git
    cd LambdaApi/code
    ```

2. Create a virtual environment and activate it:
    ```bash
    python3 -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3. Install the required dependencies:
    ```bash
    pip install boto3
    ```

## Running the Application

1. Set the Flask environment variables:
    ```bash
    export FLASK_APP=app.py
    export FLASK_ENV=development
    ```

3. Run the Flask application:
    ```bash
    poetry run flask run --host=0.0.0.0
    ```

## Usage

#### Invoke the Lambda Function

You can test the Lambda function by invoking it with a sample payload. Replace `YOUR_FUNCTION_NAME` with the name of your deployed Lambda function.

**AWS command:**
```bash
aws lambda invoke \
    --function-name YOUR_FUNCTION_NAME \
    --payload file://event.json \
    output.json
```
**Example Event Payload:**

```json
{
  "records": [
    {
      "vehicle_id": "13c94c2c-f860-4608-9ba9-8f5596fbdde6",
      "payload": {
        "tracking": [
          {
            "timestamp": "2020-02-19T15:57:01.000,+00:00",
            "ignition": 1,
            "speed": 20
          }
        ]
      }
    },
    {
      "vehicle_id": "13c94c2c-f860-4608-9ba9-8f5596fbdde6",
      "payload": {
        "tracking": [
          {
            "timestamp": "2020-02-19T15:57:01.000,+00:00",
            "ignition": 1,
            "speed": 20
          }
        ]
      }
    }
  ]
}
```

## Terraform

To automate the infrastructure setup for this project, we use Terraform. The following instructions assume that you have Terraform installed and configured.

#### Prerequisites

- `aws config` with admin credentials
- Create s3 Bucket as name `terraform-codepipeline-lambda` 
    Note: If you find any issue with name. Please replace the bucketName in files `/terraform_code/CodePipelineRes/provider.tf` &  `/terraform_code/LambdaTF/provider.tf`
    Since terraform block supports only constant values.


#### CI\CD Pipeline Setup 

1. Clone the repository:
    ```bash
    git clone https://github.com/lalith93kumar/PythonApiSolventum.git
    cd LambdaApi/terraform_code/CodePipelineRes
    ```

2. Set the Code Pipeline Terraform environment variables:
    ```bash
    export AWS_DEFAULT_REGION="xxxx"
    #gitHub repository name 
    export REPOSITORYNAME="LambdaApi"
    export REPOSITORYNAMEURL="/lalith93kumar/LambdaApi"
    ```
3. Run the Terraform command to setup Code Pipeline:
    ```bash
    cd ./terraform_code/CodePipelineRes
    terraform init
    terraform plan -var "repositoryUrl=${REPOSITORYNAMEURL}" -var "repositoryName=${REPOSITORYNAME}" -var "region=${AWS_DEFAULT_REGION}"

    terraform apply -var "repositoryUrl=${REPOSITORYNAMEURL}" -var "repositoryName=${REPOSITORYNAME}" -var "region=${AWS_DEFAULT_REGION}"  --auto-approve
    ```

## Resource Identifications

- API Lambda : ${REPOSITORYNAME}-lambda
- Dynamodb Tracker Lambda : ${REPOSITORYNAME}-DynamodbTracker
- Code Pipeline : ${REPOSITORYNAME}-pipeline
    - Stages
        - ADockerBuild
        - BTerraformPlan
        - CTerraformApply
        - DTerraformDestroy : Manual Approval requireds 

## ToDo

- Naming conventions, Typo & Code standards.
- Configure Route 53 & Certificate to endpoint for HTTPS.
- Add `tfvars` to deploy in multiple workspaces in pipeline.
- Implementation on unit test for Api. 