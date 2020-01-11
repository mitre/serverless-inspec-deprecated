#!/bin/bash

# Cleanup ruby directory
rm -Rf ruby

# Build ruby gems
sudo docker run --rm -v $PWD:/var/gem_build -w /var/gem_build lambci/lambda:build-ruby2.5 bundle install --path=.

# Copy gems
mkdir -p code/layer/ruby/gems/2.5.0/
cp -Rf ruby/2.5.0/* code/layer/ruby/gems/2.5.0/