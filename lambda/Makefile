.PHONY: build

AWS_ACCOUNT_ID := $(aws sts get-caller-identity --query Account --output text)
AWS_REGION := $(aws configure get region)

build:
		sam build

local-invoke-batch:
		sam local invoke "SQSFunction" --parameter-overrides Architecture=x86_64 --env-vars env.json --event events/batch.json

sqs-enqueue-batch:
		aws sqs send-message-batch --queue-url "https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ACCOUNT_ID}/litware-payments" --entries file://test/sqs/batch10.json

update-function-code:
		rm -rf dist && mkdir -p dist
		sam build
		(cd .aws-sam/build/SQSFunction && zip -rq "../../../dist/lambda.zip" .)
		aws lambda update-function-code --function-name litware --zip-file fileb://dist/lambda.zip
