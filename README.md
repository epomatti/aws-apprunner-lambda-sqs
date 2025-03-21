# aws-apprunner-lambda-sqs

Using Lambda and SQS with App Runner for background processing

## Infrastructure Deployment

Copy the variables template files:

```sh
cp infra/config/local.auto.tfvars infra/.auto.tfvars
```

Create the infrastructure:

```sh
terraform -chdir="infra" init
terraform -chdir="infra" apply -auto-approve
```

Build and push the API application to ECR:

```sh
cd api
bash ecrBuildPush.sh
```

Flag the App Runner for deployment and re-apply the infrastructure:

```terraform
enable_app_runner = true
```

## Local Development

> [!TIP]
> Keep the AWS SAM CLI updated.

```sh
./mvnw spring-boot:run
```

## Authentication

The application will use default Spring Security auto-configuration with the following credentials:

| Component | Username | Password |
|-----------|----------|----------|
| Client     | `client`  | `p4ssw0rd`  |
| SQS Lambda | `lambda`  | `p4ssw0rd`  |

## Lambda

```sh
zip lambda.zip app.py
```


## Limitations

Timeouts
Message size
Authentication
Reprocessing / Dead letter queues



https://docs.aws.amazon.com/systems-manager/latest/userguide/ps-integration-lambda-extensions.html
