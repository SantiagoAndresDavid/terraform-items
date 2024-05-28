# Initialize DynamoDB client (replace with your local configuration)

from random import randint
import boto3
import json
import os

dynamodb = boto3.client("dynamodb")
s3_client = boto3.client('s3')

# Define a DynamoDB table name
TABLE_NAME = "cloud-exercise-table"

headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
}


def handle(event, context):
    id = str(randint(0, 10))
    title = event["title"]
    body = event["body"]
    file_name = str(title + "-" + id + ".json")
    data = json.dumps({"title": title,"body": body})
    target_file = 'data/'+ file_name
    try:
        s3_client.put_object(Bucket='items-01', Key=target_file, Body=data)
        response_dynamo = dynamodb.put_item(
            TableName=TABLE_NAME,
            Item={
                "id": {"N": id},
                "title": {"S": title},
                "body": {"S": body},
            },
        )
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps(
                {
                    "id": id,
                    "title": title,
                    "body": body,
                }
            ),
        }
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": headers,
        }
