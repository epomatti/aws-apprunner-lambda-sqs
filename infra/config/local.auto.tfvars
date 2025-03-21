### General ###
aws_region = "us-east-2"
workload   = "litware"

### ECR ###
ecr_image_tag = "latest"

### App Runner ###
enable_app_runner = false
app_runner_cpu    = "2 vCPU"
app_runner_memory = "4 GB"

### Lambda ###
lambda_memory_size         = 256
lambda_timeout             = 600
lambda_sqs_trigger_enabled = false
lambda_username            = ""
lambda_password            = ""
