### General ###
aws_region = "us-east-2"
workload   = "litware"

### ECR ###
ecr_image_tag = "latest"

### App Runner ###
enable_app_runner = false
app_runner_cpu    = "2 vCPU"
app_runner_memory = "4 GB"

### NAT Gateway ###
create_nat_gateway = false

### Lambda ###
lambda_memory_size         = 1024
lambda_timeout             = 119
lambda_sqs_trigger_enabled = true
lambda_username            = "lambda"
lambda_password            = "p4ssw0rd"
lambda_architectures       = ["arm64"]
lambda_handler_zip         = "java/lambda-java.zip"
lambda_runtime             = "java21"
lambda_handler             = "io.pomatti.lambda.Function::handleRequest"
