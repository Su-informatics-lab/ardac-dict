# AWS CodePipeline

This code will create a CodePipeline that automatically deploys the dictionary to a specified S3 bucket.

## Deployment

> [!IMPORTANT]
> Before deploying the pipeline, you have to create a CodeStar connection to the GitHub repository. The connection name must be included in your variables.

1. Copy the pipeline.auto.tfvars.template file to pipeline.auto.tfvars and edit all of the variables.

2. To deploy the pipeline, run the following commands:

```bash
terraform init
terraform apply
```

