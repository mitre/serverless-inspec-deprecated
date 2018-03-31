#!/bin/bash

# Build Docker Image
docker build -t rubylambda .

# Run Docker Images
docker rm rubylambda
docker run --name rubylambda rubylambda bash

# Copy Lambda zip file
rm -Rf lambda.zip
docker cp rubylambda:/var/task/lambda.zip .

# Cleanup Docker Containers
docker rm rubylambda
