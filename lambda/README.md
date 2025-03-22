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

```sh
sam local invoke "SQSFunction" --env-vars env.json
sam local invoke "SQSFunction" --env-vars env.json --event events/event.json
```

## Configuration

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-sqs.html

https://docs.aws.amazon.com/lambda/latest/dg/with-sqs-example.html
