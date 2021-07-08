# docker build image and run the conatiner
Your current direcotry should be pointing to ***cloudfeeds-infrastructure-ng/docker/dynamodb-local***. 

The the running DynamoDB container will have a table **entries** created by default along with the required **Local** and **Global** Secondary Indexes.

Use the below command to build an image.
```
$docker build --build-arg dynamodb_version=latest -f Dockerfile -t ddb-local:latest .
```
Run a DynamoDb container on default Port 8000
```
$docker run -itd --name ddb-local -p 8000:8000 ddb-local:latest
```
Run a DynamoDb container on a custom container Port

```
$docker run -itd --name ddb-local -p 8000:8001 --env PORT=8001 ddb-local:latest
```
You can explore the **[NoSQL Workbench](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html)** by AWS to connect and manage the DynamoDB local and remote.

Or local DynamoDB can be explored via default shell: http://localhost:8000/shell/




