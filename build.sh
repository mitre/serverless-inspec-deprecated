#!/bin/bash

# Build Docker Image
docker build --rm -t rubylambda . 

# Run Docker Image
docker run --name rubylambda rubylambda bash

# Copy Lambda zip file
rm -Rf lambda.zip
docker cp rubylambda:/var/task/lambda.zip .

# Cleanup Docker Container
docker rm rubylambda

# Cleanup Docker Image
docker rmi rubylambda
