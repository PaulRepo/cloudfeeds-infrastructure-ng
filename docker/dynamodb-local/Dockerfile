FROM adoptopenjdk/openjdk8:alpine-slim

ARG dynamodb_version=latest
ENV DYNAMODB_VERSION=${dynamodb_version} \
    PORT=8000 

RUN mkdir -p /app
WORKDIR /app

COPY entrypoint.sh .
#COPY awscliv2.zip dynamodb_local_latest.tar.gz .
RUN apk --no-cache add bash curl unzip tar && \
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && ./aws/install && \
    curl -O https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_${DYNAMODB_VERSION}.tar.gz && \
    tar zxvf dynamodb_local_${DYNAMODB_VERSION}.tar.gz && \
    rm dynamodb_local_${DYNAMODB_VERSION}.tar.gz && \
    aws configure set aws_access_key_id sample && \
    aws configure set aws_secret_access_key sample && \
    aws configure set region localhost && \
    chmod +x entrypoint.sh

EXPOSE $PORT
ENTRYPOINT ["/bin/bash", "-c", "/app/entrypoint.sh"]
