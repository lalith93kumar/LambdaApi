import json
from datetime import datetime
from base64 import b64decode
import zlib
import boto3
import os
# Initialize DynamoDB client
lambdaClient = boto3.client('lambda')
def validate_record(record):
    required_fields = ['vehicle_id', 'payload']
    for field in required_fields:
        if field not in record:
            return False, f"Missing required field: {field}"
    try:
        # Decode and decompress payload
        compressed_payload = b64decode(record['payload'])
        decompressed_payload = zlib.decompress(compressed_payload).decode('utf-8')
    except (zlib.error, ValueError) as e:
        return False,f"Invalid payload encoding or compression: {str(e)}"
    

    try:
        # Parse JSON payload
        payload = json.loads(decompressed_payload)
        record['payload'] = payload
    except (json.JSONDecodeError, KeyError) as e:
        return False,f"Invalid JSON payload or missing tracking data: {str(e)}"

    if 'tracking' not in record['payload']:
        return False, f"Missing required field: tracking in payload {str(record['payload'])}"

    for track in record['payload']['tracking']:
        if not isinstance(track, dict):
            return False, "Each tracking item must be a dictionary"
        if 'timestamp' not in track or 'ignition' not in track or 'speed' not in track:
            return False, "Missing required fields in tracking data"
        try:
            datetime.strptime(track['timestamp'], '%Y-%m-%dT%H:%M:%S.%f,%z')
        except ValueError:
            return False, f"Invalid timestamp format: {track['timestamp']}"
        if not isinstance(track['ignition'], int):
            return False, f"Invalid ignition value, must be integer: {track['ignition']}"
        if not isinstance(track['speed'], (int, float)):
            return False, f"Invalid speed value, must be integer or float: {track['speed']}"
    
    return True, record

def manipulateData(event):
    records = event.get('records', [])
    if not records:
        return {
            'statusCode': 400,
            'body': json.dumps({"error": "No records found in the request"})
        }
    result = {     
        'vehicle_speeds' :{},
    }
    for record in records:
        is_valid, error_message_or_payload = validate_record(record)
        if not is_valid:
            return {
                'statusCode': 400,
                'body': json.dumps({"error": error_message_or_payload})
            }
        record = error_message_or_payload
        vehicle_id = record['vehicle_id']
        for tracking in record['payload']['tracking']:
            speed = tracking['speed']
            ignition = tracking['ignition']
            if vehicle_id not in result['vehicle_speeds']:
                result['vehicle_speeds'][vehicle_id] = {}
                result['vehicle_speeds'][vehicle_id]['speed'] = []
                result['vehicle_speeds'][vehicle_id]['parkedCount'] = 0
                result['vehicle_speeds'][vehicle_id]['idlingCount'] = 0
                result['vehicle_speeds'][vehicle_id]['movingCount'] = 0  
            if ignition == 0:
               result['vehicle_speeds'][vehicle_id]['status'] = 'PARKED'
               result['vehicle_speeds'][vehicle_id]['parkedCount'] +=1
            if ignition == 1 and speed == 0:
               result['vehicle_speeds'][vehicle_id]['status'] = 'IDLING'
               result['vehicle_speeds'][vehicle_id]['idlingCount'] +=1   
            if ignition == 1 and speed > 0:
               result['vehicle_speeds'][vehicle_id]['status'] = 'MOVING'
               result['vehicle_speeds'][vehicle_id]['movingCount'] +=1  
            result['vehicle_speeds'][vehicle_id]['speed'].append(speed)
    addDataToDynamodb(records)
    return result

def addDataToDynamodb(records):
    for index in range(0,len(records),500):
        x = slice(index,index+300)
        lambdaClient.invoke(
            FunctionName= os.environ['DynamodbTrackerARN'],
            InvocationType = 'Event',
            Payload = json.dumps({'items':records[x]})
        )

        
def getFastestVehicle(result):
    fastest_vehicle = None
    if result['vehicle_speeds']:
        fastest_vehicle = max(result['vehicle_speeds'], key=lambda k: sum(result['vehicle_speeds'][k]['speed']) / len(result['vehicle_speeds'][k]['speed']))
    return fastest_vehicle

def getLongestVehicle(result,key):
    vehicle = None
    if result['vehicle_speeds']:
        vehicle = max(result['vehicle_speeds'], key=lambda k: result['vehicle_speeds'][k][key] / len(result['vehicle_speeds'][k]['speed']))
    return vehicle
    