import json
import statistics
import boto3
from base64 import b64decode
import uuid
from botocore.exceptions import ClientError

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('VehicleData')

def dynamodb_handler(event, context):
    try:
        with table.batch_writer() as writer:
            for record in event['items']:
                for stats in record['payload']['tracking']:
                    writer.put_item(
                        Item={
                            'id': str(uuid.uuid4()),
                            'vehicle_id': record['vehicle_id'],
                            'timestamp': stats['timestamp'],
                            'ignition': stats['ignition'],
                            'speed': stats['speed']
                        }
                    )
    except ClientError as e:
        return {
            "statusCode": 500,
            "body": json.dumps(f"Unable to insert data for vehicle {event}: {e.response['Error']['Message']}")
        }
    return {
        "statusCode": 200,
        "body": "Added ALL entries to Dynamodb"
    }