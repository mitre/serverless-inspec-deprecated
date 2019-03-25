#!/bin/bash

# Install docker & nano
sudo yum -y install docker nano

# Setup node.js repo
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -

# Install node.js
sudo yum -y install nodejs

# Installing the serverless cli
npm install -g serverless

# Build gem dependencies
docker run --rm -it -v $PWD:/var/gem_build -w /var/gem_build lambci/lambda:build-ruby2.5 bundle install --path=.

#
serverless create -t aws-ruby -p scrapeservice

sls deploy

