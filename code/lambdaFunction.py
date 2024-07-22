import json
import statistics
import boto3
from base64 import b64decode
import os
# Initialize DynamoDB client
lambdaClient = boto3.client('lambda')

def lambda_handler(event, context):
    # Validate input
    if 'vehicle_id' not in event or 'payload' not in event:
        return {
            "statusCode": 400,
            "body": json.dumps("Invalid input: Missing vehicle_id or payload.")
        }
    
    # try:
    #     # Decode and decompress payload
    #     compressed_payload = b64decode(event['payload'])
    #     decompressed_payload = zlib.decompress(compressed_payload).decode('utf-8')
    # except (zlib.error, ValueError) as e:
    #     return {
    #         "statusCode": 400,
    #         "body": json.dumps(f"Invalid payload encoding or compression: {str(e)}")
    #     }

    try:
        # Parse JSON payload
        payload = event['payload']
        vehicles = payload['tracking']
    except (json.JSONDecodeError, KeyError) as e:
        return {
            "statusCode": 400,
            "body": json.dumps(f"Invalid JSON payload or missing tracking data: {str(e)}")
        }

    # Validate vehicle tracking data
    if not isinstance(vehicles, list) or len(vehicles) == 0:
        return {
            "statusCode": 400,
            "body": json.dumps("Invalid tracking data: Must be a non-empty list.")
        }

    lambdaClient.invoke(
        FunctionName= os.environ['DynamodbTrackerARN'],
        InvocationType = 'Event',
        Payload = json.dumps(event)
    )


    # Get vehicle_id
    vehicle_id = event['vehicle_id']

    # Extract speeds and validate each entry
    speeds = []
    for record in vehicles:
        if 'timestamp' not in record or 'ignition' not in record or 'speed' not in record:
            return {
                "statusCode": 400,
                "body": json.dumps("Invalid record: Missing timestamp, ignition, or speed.")
            }
        if not isinstance(record['speed'], (int, float)):
            return {
                "statusCode": 400,
                "body": json.dumps("Invalid speed: Must be a number.")
            }
        speeds.append(record['speed'])

    if len(speeds) == 0:
        return {
            "statusCode": 400,
            "body": json.dumps("No valid speed records found.")
        }

    # Calculate average speed
    average_speed = statistics.mean(speeds)

    # Determine the vehicle status
    if average_speed == 0:
        status = "stopped"
    elif average_speed <= 10:
        status = "idle"
    elif average_speed <= 20:
        status = "moving_slow"
    else:
        status = "moving_fast"

    # Construct response
    response = {
        "total_vehicles": 1,  # Since each event corresponds to one vehicle
        "fastest_vehicle": vehicle_id,  # As we're processing one vehicle at a time
        "vehicle_statuses": {
            vehicle_id: status
        }
    }

    return {
        "statusCode": 200,
        "body": json.dumps(response)
    }