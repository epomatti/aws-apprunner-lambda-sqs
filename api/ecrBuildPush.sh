#!/bin/bash

account=$(aws sts get-caller-identity --query "Account" --output text)
region="us-east-2"
tag="latest"
name="easybank"
repositoryUrl=$account.dkr.ecr.$region.amazonaws.com
repositoryImage=$repositoryUrl/$name:$tag

docker build -t $name .
docker tag $name $repositoryImage
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $repositoryUrl
docker push $repositoryImage
