# Initialize DynamoDB client (replace with your local configuration)
import boto3
import json

dynamodb = boto3.client("dynamodb")


# Define a DynamoDB table name
TABLE_NAME = "cloud-exercise-table"

headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
}


def handle(event, context):
    try:
        response_dynamo = dynamodb.scan(
            TableName=TABLE_NAME,
        )
        items = response_dynamo['Items']
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps(items),
        }
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": headers,
        }