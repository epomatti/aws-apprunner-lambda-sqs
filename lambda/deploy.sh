#!/bin/bash

cwd=$(echo $PWD)

mkdir -p build
rm build/lambda.zip

sam build

cd .aws-sam/build/SQSFunction/
zip -rq "$cwd/build/lambda.zip" .

cd "$cwd"

aws lambda update-function-code --function-name litware \
  --zip-file fileb://build/lambda.zip
