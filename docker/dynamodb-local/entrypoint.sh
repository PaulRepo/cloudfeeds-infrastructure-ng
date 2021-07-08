#!/bin/bash

echo "Starting DynamoDB on Port: "$PORT  
#Run DynamoDb local jar file in background
nohup java -Djava.library.path=. -jar DynamoDBLocal.jar --sharedDb -inMemory -port $PORT &
#Delay added to start DynamoDB before hitting for the table creation
sleep 2s
echo "DynamoDB started"

#Create Table entries with LSI and GSI
aws dynamodb create-table \
    --table-name entries \
    --attribute-definitions AttributeName=entryId,AttributeType=S AttributeName=dateLastUpdated,AttributeType=S AttributeName=feed,AttributeType=S \
    --key-schema AttributeName=entryId,KeyType=HASH AttributeName=dateLastUpdated,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --local-secondary-indexes \
        "[
            {
                \"IndexName\": \"entryId-feed-index\",
                \"KeySchema\": [
                    {\"AttributeName\": \"entryId\",\"KeyType\":\"HASH\"},
                    {\"AttributeName\": \"feed\",\"KeyType\":\"RANGE\"}
                ],
                \"Projection\": {
                    \"ProjectionType\": \"ALL\"
                }
            }
        ]" \
     --global-secondary-indexes \
        "[
            {
                \"IndexName\": \"global-feed-index\",
                \"KeySchema\": [
                    {\"AttributeName\":\"feed\",\"KeyType\":\"HASH\"}
                ],
                \"Projection\": {
                    \"ProjectionType\":\"ALL\"
                },
                \"ProvisionedThroughput\": {
                    \"ReadCapacityUnits\": 1,
                    \"WriteCapacityUnits\": 1
                }
            }
        ]" \
    --endpoint-url=http://localhost:$PORT 

#To keep the container running
tail -f /dev/null
