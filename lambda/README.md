# Lambda

## Invoke Locally

Install the compatible Java version, currently Java 21:

```sh
sdk install java 21-tem
sdk install gradle
```

Copy the parameters file template, and set the values accordingly:

```sh
cp config/local.env.json env.json
```

Build the function:

```bash
sam build
```

Invoke it:

> [!TIP]
> Make sure Docker is running locally

> [!NOTE]
> You must be logged in to AWS in your console to authorize Secrets Manager calls

```sh
sam local invoke "SQSFunction" --parameter-overrides Architecture=x86_64 --env-vars env.json --event events/500.json
```

## Post

```sh
aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/80398EXAMPLE/MyQueue --message-body '{"httpResponseStatus":200}'
```

## Package

```sh
aws lambda update-function-code --function-name litware \
  --zip-file fileb://myFunction.zip
```

```sh
sam package --region us-east-2 --s3-bucket "bucket-litware-lambda-deploy-local" --s3-key aaa --no-resolve-s3 --force-upload
```

```sh
aws lambda update-function-code --function-name litware \
--s3-bucket "bucket-litware-lambda-deploy-local" --s3-key myFileName.zip
```

`resolve_s3` has been set to false

```
[default.package.parameters]
resolve_s3 = false
```

sam deploy --template-file template.yaml \
  --stack-name MyLambdaStack \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides S3BucketName=my-bucket S3KeyName=my-folder/my-code.zip

## Error Handling
// https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-errorhandling.html

## Configuration

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-sqs.html

https://docs.aws.amazon.com/lambda/latest/dg/with-sqs-example.html

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html#serverless-sam-cli-using-invoke-environment-file

https://docs.powertools.aws.dev/lambda/java/

https://docs.freefair.io/gradle-plugins/8.13/reference/

https://docs.powertools.aws.dev/lambda/java/#install

https://github.com/aws/aws-lambda-java-libs/blob/main/aws-lambda-java-log4j2/README.md

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-package.html

https://docs.aws.amazon.com/lambda/latest/dg/java-package.html
