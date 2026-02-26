# Terraform AWS CI/CD Pipeline

[![Terraform](https://img.shields.io/badge/Terraform-1.14.3-623CE4?logo=terraform)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Free%20Tier-FF9900?logo=amazon-aws)](https://aws.amazon.com)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions)](https://github.com/features/actions)

Complete GitOps workflow for AWS infrastructure using Terraform and GitHub Actions.

## 🚀 Features

- **PR Validation**: Format, security, and plan checks
- **Plan Approval**: Review changes before deployment  
- **S3 Backend**: Secure state management
- **Manual Operations**: Emergency workflows
- **AWS Integration**: Lambda, S3, CloudWatch

## 📁 Structure
```bash
├── .github/workflows/ # CI/CD pipelines
├── terraform/ # Infrastructure code
├── docs/ # Documentation
└── README.md
```

## ⚡ Quick Start

### 1. Setup AWS Backend
```bash
aws s3 mb s3://your-terraform-state-bucket
aws s3api put-bucket-versioning --bucket your-terraform-state-bucket --versioning-configuration Status=Enabled
```
### 2. Configure GitHub
* Secrets: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
* Variables: TF_VAR_vpc_id

### 3. Update Backend
Edit `terraform/versions.tf` with your S3 bucket name.

### 4. Deploy
1. Create feature branch
2. Make changes
3. Create PR → Review plan
4. Merge → Auto-deploy

## 🔄 Workflows
### PR Workflow
Format check → Validation → Security scan → Plan → Cache

### Main Workflow
Restore cached plan → Manual approval → Apply → Update state

### Manual Workflow
Plan/Apply/Destroy operations on-demand

## 🛡️ Security
* State encrypted in S3
* Plan integrity verification
* IAM least-privilege access
* Security scanning with tfsec

## 📊 Infrastructure
* **Lambda**: Python function with S3 integration
* **S3**: Encrypted bucket with versioning
* **CloudWatch**: Monitoring and alerting
* **IAM**: Minimal permission roles

## 🔧 Configuration
| **Variable** | **Description** | **Example** |
| :-- | :-- | :-- |
| TF_VAR_vpc_id | VPC ID | vpc-12345678 |
| AWS_DEFAULT_REGION | AWS region | us-east-1 |

## 🚨 Troubleshooting
**Cache not found**: Check PR was merged, verify cache keys
**Apply fails**: Check state lock, verify AWS permissions
**Security scan fails**: Review tfsec output, update configs

## 📋 Roadmap
* v0.2.0: AI Agent Code & Infrastructure Scan
* v0.3.0: Integration tests, disaster recovery

**Version:** 0.1.0 | **Terraform:** 1.14.3 | **AWS Provider:** ~> 5.0
