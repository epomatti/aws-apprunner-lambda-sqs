# AWS AppRunner SQS Trigger with Lambda

Using Lambda and SQS with App Runner for background processing

## Infrastructure Deployment

Copy the variables template files:

```sh
cp infra/config/local.auto.tfvars infra/.auto.tfvars
```

Go to the

> [!IMPORTANT]
> Enable Lambda Application Insights

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
> Keep the AWS SAM CLI [updated](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/manage-sam-cli-versions.html).

```sh
./mvnw spring-boot:run
```

Test the API:

```sh
curl -I -u lambda:p4ssw0rd localhost:8080
```


## Authentication

The application will use default Spring Security auto-configuration with the following credentials:

| Component | Username | Password |
|-----------|----------|----------|
| Client     | `client`  | `p4ssw0rd`  |
| SQS Lambda | `lambda`  | `p4ssw0rd`  |

## Lambda

https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html


| Language  | Runtime | Password |
|-----------|----------|----------|
| Java   | `java21`  | `p4ssw0rd`  |
| Python | `python3.13`  | `p4ssw0rd`  |

### Runtimes

#### Java

To recreate the ZIP file:

```sh
zip -r lambda-java.zip io
```

Terraform parameters:

```terraform
lambda_handler_zip = "java/lambda-java.zip"
lambda_runtime     = "java21"
lambda_handler     = "io.pomatti.lambda.Function::handleRequest"
```

#### Python

To recreate the ZIP file:

```sh
zip lambda-python.zip app.py
```

Terraform parameters:

```terraform
lambda_handler_zip = "python/lambda-python.zip"
lambda_runtime     = "python3.13"
lambda_handler     = "app.lambda_handler"
```

## Limitations

Timeouts
Message size
Authentication
Reprocessing / Dead letter queues



https://docs.aws.amazon.com/systems-manager/latest/userguide/ps-integration-lambda-extensions.html
