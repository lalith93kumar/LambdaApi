# LambdaApi

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://shields.io/)

This repository contains an AWS Lambda function designed to process vehicle telematics data. The Lambda function receives data from telematics devices, processes the data to determine vehicle statistics, and stores the data in a DynamoDB table.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Running the Application](#running-the-application)
- [Usage](#usage)
- [Explanation of Function Output](#explanation-of-function-output)
- [Reasoning for Implementation](#reasoning-for-implementation)
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
    git clone git@github.com:lalith93kumar/LambdaApi.git
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


## Explanation of Function Output

The Lambda function processes vehicle telematics data and generates the following output:

- Total Number of Vehicles: The function calculates and outputs the total number of unique vehicles in the input data.

- Fastest Vehicle on Average: The function determines and outputs the vehicle with the highest average speed based on the tracking data provided.

- Longest Idling Vehicle : To determine the longest idling vehicle, we need to analyze the data and find the vehicle with the longest continuous period where the ignition is on (ignition value is 1), and the speed is 0.

- Longest Parked Vehicle : To determine the longest idling vehicle, we need to analyze the data and find the vehicle with the longest continuous period where the ignition is on (ignition value is 0).

- Longest Moving Vehicle : To determine the longest idling vehicle, we need to analyze the data and find the vehicle with the longest continuous period where the ignition is on (ignition value is 1), and the speed is 1+.

## Reasoning for Implementation

The implementation is structured to address the problem requirements efficiently:

- Validation of Input Data:

  - The function first validates the input data to ensure all necessary fields are present and correctly formatted. This prevents errors during data processing.
  - It checks for the presence of vehicle_id, payload, and within payload, the tracking array. Each tracking item is checked for timestamp, ignition, and speed.

- Processing Each Record:

  - For each valid record, the function extracts the vehicle_id and iterates through the tracking data to extract individual tracking points.
  - Each tracking point includes a timestamp, ignition, and speed.

- Storing Data in DynamoDB:

  - The function stores each tracking point in a DynamoDB table. The table schema uses vehicle_id as the partition key and timestamp as the sort key, allowing efficient querying by vehicle and time.

- Calculating Statistics:

  - Total Number of Vehicles: The function maintains a set of unique vehicle_ids to determine the total number of vehicles.
  - Fastest Vehicle on Average: It maintains a dictionary to store the speeds for each vehicle and calculates the average speed for each vehicle. The vehicle with the highest average speed is identified as the fastest.
  - Average Speed of All Vehicles: It calculates the overall average speed by summing the speeds of all tracking points and dividing by the total number of points.

- Error Handling:

  - The function includes comprehensive error handling to catch and report any issues that arise during data validation, processing, or storage.

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
    git clone git@github.com:lalith93kumar/LambdaApi.git
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
4. Activate the github connection under URl `http://{AWS_Console}/codesuite/settings/connections` & retry the stages in pipeline for first time only
Hit Post call with terraform output api endpoint with json body specified.

## Resource Identifications

- CodePipeline Connections : gitHubConnection (Please activate it for first time)
- API Gateway : ${REPOSITORYNAME}-api 
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