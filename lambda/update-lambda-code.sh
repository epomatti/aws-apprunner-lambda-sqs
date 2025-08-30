#!/bin/bash

rm -rf dist && mkdir -p dist
sam build
(cd ".aws-sam/build/SQSFunction" && zip -rq "../../../dist/lambda.zip" .)
aws lambda update-function-code --function-name "litware" --zip-file fileb://dist/lambda.zip
