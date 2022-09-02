import json
import boto3
import os
import botocore
from datetime import datetime


def lambda_handler(event, context):
    encoding = "utf-8"
    newLine = "\n"
    spaceCharacter = " "
    oldImage = "OldImage"
    dynamoDBString = "dynamodb"
    s3String = "s3"
    print(os.environ['BasketName'])
    for record in event['Records']:
        print(record)
        if record['eventName'] == 'REMOVE':
            bucket_name = os.environ['BasketName']
            ddbARN = record['eventSourceARN']
            ddbTable = ddbARN.split(':')[5].split('/')[1]
            file_name = datetime.now().strftime('%Y%m%d_') + ddbTable + ".txt"
            print(file_name)
            s3 = boto3.resource(s3String)
            uploadS3 = boto3.client(s3String)
            try:
                s3.Object(bucket_name, file_name).load()
            except botocore.exceptions.ClientError as e:
                if e.response['Error']['Code'] == "404":
                    dynamoDbValue = record[dynamoDBString]
                    allItems = dynamoDbValue[oldImage]
                    string = ''
                    heading = ''
                    for image in dynamoDbValue[oldImage]:
                        heading = heading + image + spaceCharacter
                        string = string + str(*allItems.get(image).values()) + spaceCharacter
                        print(*allItems.get(image).values())
                    endString = heading + newLine + string
                    encoded_string = endString.encode(encoding)
                    s3.Bucket(bucket_name).put_object(Key=file_name, Body=encoded_string)
                else:
                    raise
            else:
                dynamoDbValue = record[dynamoDBString]
                allItems = dynamoDbValue[oldImage]
                file_content = uploadS3.get_object(Bucket=bucket_name, Key=file_name)["Body"].read().decode(encoding)
                newEntry = ''
                lines = str(file_content).split(newLine)
                for r in lines:
                    newEntry = newEntry + r + newLine
                for image in dynamoDbValue[oldImage]:
                    newEntry = newEntry + str(*allItems.get(image).values()) + spaceCharacter
                    print(*allItems.get(image).values())
                newEntry = newEntry
                encoded_string = newEntry.encode(encoding)
                uploadS3.delete_object(Bucket=bucket_name, Key=file_name)
                s3.Bucket(bucket_name).put_object(Key=file_name, Body=encoded_string)
    return {
        'statusCode': 200,
        'body': json.dumps('DB backup successful')
    }