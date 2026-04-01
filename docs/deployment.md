# Deployment Setup

This document explains how to set up the automated deployment pipeline for ARDaC Data Dictionary releases.

## Deployment Overview

The deployment workflow is triggered automatically when a new semantic version tag (e.g., `1.2.3`) is pushed to the repository. The workflow performs the following steps:
1. Checks out the code for the tagged release.
2. Configures AWS credentials using GitHub Secrets.
3. Uploads the `schema.json` file to the configured S3 bucket under a directory named after the release tag (e.g., `s3://my-bucket/v1.2.3/schema.json`).

## Prerequisites

To enable this workflow, you must configure the following:

1. An AWS S3 bucket to host the schema files.
2. An AWS IAM User with permissions to write to that bucket.
3. GitHub Secrets with the AWS credentials and configuration.

## AWS Configuration

The following script creates the S3 bucket, IAM policy, and IAM user using the AWS CLI. Set the variables at the top, then run the whole block.

```bash
# ── Configuration ────────────────────────────────────────────────────────────
BUCKET_NAME="your-bucket-name"       # e.g. ardac-dictionary-releases
AWS_REGION="us-east-1"
USER_NAME="github-actions-deploy"
POLICY_NAME="ARDaCDictionaryDeployPolicy"
GITHUB_REPO="org/repo"               # e.g. Su-informatics-lab/ardac-dict
# ─────────────────────────────────────────────────────────────────────────────

# 1. Create the S3 bucket
aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"

# 2. Create the IAM policy
POLICY_ARN=$(aws iam create-policy \
    --policy-name "$POLICY_NAME" \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [{
            \"Effect\": \"Allow\",
            \"Action\": \"s3:PutObject\",
            \"Resource\": \"arn:aws:s3:::${BUCKET_NAME}/*\"
        }]
    }" \
    --query 'Policy.Arn' \
    --output text)

echo "Policy ARN: $POLICY_ARN"

# 3. Create the IAM user
aws iam create-user --user-name "$USER_NAME"

# 4. Attach the policy to the user
aws iam attach-user-policy \
    --user-name "$USER_NAME" \
    --policy-arn "$POLICY_ARN"

# 5. Create access keys and capture output
KEYS=$(aws iam create-access-key \
    --user-name "$USER_NAME" \
    --query 'AccessKey.{KeyId:AccessKeyId,Secret:SecretAccessKey}' \
    --output json)

ACCESS_KEY_ID=$(echo "$KEYS" | python3 -c "import sys,json; print(json.load(sys.stdin)['KeyId'])")
SECRET_ACCESS_KEY=$(echo "$KEYS" | python3 -c "import sys,json; print(json.load(sys.stdin)['Secret'])")

echo "Access Key ID:     $ACCESS_KEY_ID"
echo "Secret Access Key: $SECRET_ACCESS_KEY"
```

> **Important:** Save the `SECRET_ACCESS_KEY` value — it cannot be retrieved again after this step.

## GitHub Configuration

Use the `gh` CLI to add the required secrets to your repository:

```bash
# Uses the variables set in the AWS Configuration block above
gh secret set AWS_ACCESS_KEY_ID     --body "$ACCESS_KEY_ID"     --repo "$GITHUB_REPO"
gh secret set AWS_SECRET_ACCESS_KEY --body "$SECRET_ACCESS_KEY" --repo "$GITHUB_REPO"
gh secret set AWS_REGION            --body "$AWS_REGION"        --repo "$GITHUB_REPO"
gh secret set AWS_S3_BUCKET         --body "$BUCKET_NAME"       --repo "$GITHUB_REPO"
```

The four secrets expected by the workflow are:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Access key ID for the `github-actions-deploy` IAM user. |
| `AWS_SECRET_ACCESS_KEY` | Secret access key for the IAM user. |
| `AWS_REGION` | AWS region where the S3 bucket lives (e.g., `us-east-1`). |
| `AWS_S3_BUCKET` | Name of the S3 bucket (e.g., `ardac-dictionary-releases`). |

## Triggering a Deployment

To trigger a deployment, simply create and push a new tag:

```bash
git tag v1.2.3
git push origin v1.2.3
```

The workflow will run automatically. You can monitor its progress in the **Actions** tab of the repository.
