import json
import statistics
import boto3
from base64 import b64decode
import os
from libs.requestHandler import manipulateData,getFastestVehicle,getLongestVehicle
# Initialize DynamoDB client
lambdaClient = boto3.client('lambda')

def lambda_handler(event, context):

    response = {
        "total_vehicles": 0,
        "longest_Parked_vehicle": None,
        "longest_idling_vehicle": None,
        "longest_moving_vehicle": None,
        "fastest_vehicle": None,
    }
    
    try:
        result = manipulateData(event)
        lambdaClient.invoke(
            FunctionName= os.environ['DynamodbTrackerARN'],
            InvocationType = 'Event',
            Payload = json.dumps(event)
        )
        if('statusCode' in result):
            return result
        
        total_vehicles = len(result['vehicle_speeds'])
        response['total_vehicles'] = total_vehicles
        response['fastest_vehicle'] = getFastestVehicle(result)
        response['longest_Parked_vehicle'] = getLongestVehicle(result,'parkedCount')
        response['longest_idling_vehicle'] = getLongestVehicle(result,'idlingCount')
        response['longest_moving_vehicle'] = getLongestVehicle(result,'movingCount')
        
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({"error": str(e)})
        }