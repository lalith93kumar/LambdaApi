import json
import statistics
import boto3
from base64 import b64decode
import os
from libs.requestHandler import validate_record,manipulateData
# Initialize DynamoDB client
lambdaClient = boto3.client('lambda')

def lambda_handler(event, context):

    lambdaClient.invoke(
        FunctionName= os.environ['DynamodbTrackerARN'],
        InvocationType = 'Event',
        Payload = json.dumps(event)
    )
    response = {
        "total_vehicles": 0,
        "fastest_vehicle": None,
        "average_speed": 0
    }
    
    try:
        result = manipulateData(event)
        if('statusCode' in result):
            return result
        
        total_vehicles = len(result['vehicle_speeds'])
        response['total_vehicles'] = total_vehicles
        if result['total_records'] > 0:
            response['average_speed'] = result['total_speed'] / result['total_records']
        
        if result['vehicle_speeds']:
            fastest_vehicle = max(result['vehicle_speeds'], key=lambda k: sum(result['vehicle_speeds'][k]) / len(result['vehicle_speeds'][k]))
            response['fastest_vehicle'] = fastest_vehicle
        
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({"error": str(e)})
        }