.PHONY: build

AWS_ACCOUNT_ID := $(aws sts get-caller-identity --query Account --output text)
AWS_REGION := $(aws configure get region)

build:
		sam build

invoke-local-batch:
		sam local invoke "SQSFunction" --parameter-overrides Architecture=x86_64 --env-vars env.json --event events/batch.json

enqueue-sqs-batch:
		aws sqs send-message-batch --queue-url "https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ACCOUNT_ID}/litware-payments" --entries file://test/sqs/batch10.json
