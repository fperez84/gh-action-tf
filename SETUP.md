# Setup Guide

## Prerequisites

- AWS Account with admin access
- GitHub repository 
- AWS CLI configured locally

## Step-by-Step Setup

### 1. AWS Backend Setup

```bash
# Set variables
BUCKET_NAME="terraform-state-$(whoami)-$(date +%s)"
REGION="us-east-1"

# Create bucket
aws s3 mb s3://$BUCKET_NAME --region $REGION

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{
        "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
    }'

# Block public access
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "✅ Bucket created: $BUCKET_NAME"
```
### 2. GitHub Configuration
Secrets (Settings → Secrets and variables → Actions → Secrets)

* AWS_ACCESS_KEY_ID: your_access_key
* AWS_SECRET_ACCESS_KEY: your_secret_key  
* AWS_DEFAULT_REGION: us-east-1
* Variables (Settings → Secrets and variables → Actions → Variables)


TF_VAR_vpc_id: vpc-xxxxxxxxx
Get VPC ID:

```bash
aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query 'Vpcs[1].VpcId' --output text
```
### 3. Update Terraform Backend
Edit terraform/versions.tf:

```hcl

backend "s3" {
  bucket  = "your-bucket-name-here"
  key     = "infrastructure/terraform.tfstate"
  region  = "us-east-1"
  encrypt = true
}
```
### 4. Environment Setup (Optional)
Create GitHub environment for manual approval:

Settings → Environments → New environment
Name: dev
Add protection rules:
Required reviewers: Add yourself
Wait timer : 0 minutes

### 5. Test Setup
```bash
# Create test branch
git checkout -b feature/test-setup

# Make small change
echo "# Test" >> terraform/README.md

# Commit and push
git add .
git commit -m "test: verify workflow setup"
git push -u origin feature/test-setup
```
## Create PR and verify workflows run
**Verification Checklist**
* S3 bucket created with encryption
* GitHub secrets configured
* VPC ID variable set
* Backend configuration updated
* Test PR workflows pass
* Manual approval environment configured

**Next Steps**
* Review generated plan in test PR
* Merge PR to trigger deployment
* Verify infrastructure in AWS console
* Test manual workflows if needed
