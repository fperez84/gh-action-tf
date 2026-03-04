# Terraform AWS CI/CD Pipeline

[![Terraform](https://img.shields.io/badge/Terraform-1.14.3-623CE4?logo=terraform)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Free%20Tier-FF9900?logo=amazon-aws)](https://aws.amazon.com)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions)](https://github.com/features/actions)
[![Snyk](https://img.shields.io/badge/Snyk-IaC%20Security-4C4A73?logo=snyk)](https://snyk.io)
[![CodeRabbit](https://img.shields.io/badge/CodeRabbit-AI%20Reviews-F97316?logo=rabbit)](https://coderabbit.ai)
[![Infracost](https://img.shields.io/badge/Infracost-Cost%20Estimation-45A4FF)](https://infracost.io)

Complete GitOps workflow for AWS infrastructure using Terraform and GitHub Actions.

## 🚀 Features

- **PR Validation**: Format, security, lint, and plan checks
- **AI Code Review**: Automated review with CodeRabbit on every PR
- **IaC Security Scanning**: Snyk and tfsec vulnerability detection with SARIF reporting
- **Cost Estimation**: Infracost diff comments on every PR
- **Plan Approval**: Review changes before deployment
- **S3 Backend**: Secure state management
- **Manual Operations**: Emergency workflows
- **AWS Integration**: Lambda, S3, CloudWatch

## 📁 Structure

\`\`\`bash
├── .github/workflows/     # CI/CD pipelines
│   ├── main.yml           # Deployment pipeline (push to main)
│   ├── pull-requests.yml  # PR validation pipeline
│   └── manual.yml         # Manual operations workflow
├── terraform/             # Infrastructure code
├── docs/                  # Documentation
├── .coderabbit.yaml       # CodeRabbit AI review configuration
└── README.md
\`\`\`

## ⚡ Quick Start

### 1. Setup AWS Backend
\`\`\`bash
aws s3 mb s3://your-terraform-state-bucket
aws s3api put-bucket-versioning --bucket your-terraform-state-bucket --versioning-configuration Status=Enabled
\`\`\`

### 2. Configure GitHub
**Secrets** (`Settings → Secrets and variables → Actions → Secrets`):
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `SNYK_TOKEN` — [Generate at app.snyk.io](https://app.snyk.io/account)
- `INFRACOST_API_KEY` — [Generate at infracost.io](https://www.infracost.io/docs/)

**Variables**:
- `TF_VAR_vpc_id`

### 3. Configure CodeRabbit
1. Sign in at [coderabbit.ai](https://coderabbit.ai) with your GitHub account
2. Add your repository from the dashboard
3. The `.coderabbit.yaml` file in the repo root controls review behavior

### 4. Update Backend
Edit `terraform/versions.tf` with your S3 bucket name.

### 5. Deploy
1. Create feature branch
2. Make changes
3. Create PR → AI review + security scan + cost diff + plan
4. Merge → Auto-deploy

## 🔄 Workflows

### PR Workflow (`pull-requests.yml`)
Format check → Validate → tfsec → TFLint → **Snyk IaC scan** → Plan → Cache plan
> CodeRabbit AI review runs automatically in parallel via GitHub App

### Main Workflow (`main.yml`)
Restore cached plan → Verify hashes → Manual approval → Apply → Update state

### Manual Workflow (`manual.yml`)
Plan/Apply/Destroy operations on-demand via `workflow_dispatch`

## 🛡️ Security

- State encrypted in S3
- Plan integrity verification with SHA256 hashing
- IAM least-privilege access
- Security scanning with **tfsec** and **Snyk IaC**
- SARIF reports uploaded to GitHub Code Scanning
- Inline vulnerability annotations on PRs

## 💰 Cost Management

Infracost runs on every PR and posts a comment with:
- Monthly cost breakdown per resource
- Diff between base branch and PR branch
- Total cost impact of the proposed changes

## 🤖 AI Code Review

CodeRabbit reviews every PR automatically with instructions tuned for:
- Terraform IaC best practices and security
- IAM overly-permissive policies detection
- Lambda function error handling and security
- Resource naming conventions

## 📊 Infrastructure

- **Lambda**: Python function with S3 integration
- **S3**: Encrypted bucket with versioning
- **CloudWatch**: Monitoring and alerting
- **IAM**: Minimal permission roles

## 🔧 Configuration

| **Variable** | **Description** | **Example** |
| :-- | :-- | :-- |
| `TF_VAR_vpc_id` | VPC ID | `vpc-12345678` |
| `AWS_DEFAULT_REGION` | AWS region | `us-east-1` |
| `SNYK_TOKEN` | Snyk API token | `snyk_...` |
| `INFRACOST_API_KEY` | Infracost API key | `ico_...` |

## 🚨 Troubleshooting

| **Error** | **Solution** |
| :-- | :-- |
| Cache not found | Check PR was merged, verify cache keys |
| Apply fails | Check state lock, verify AWS permissions |
| Snyk scan fails | Review SARIF output in Security tab, check `SNYK_TOKEN` secret |
| Infracost no comment | Verify `INFRACOST_API_KEY` secret and `pull-requests: write` permission |
| CodeRabbit skips review | Check `.coderabbit.yaml` path_filters, ensure PR has changes in `terraform/` |

## 📋 Roadmap

- ~~v0.2.0: AI Agent Code & Infrastructure Scan~~ ✅
- v0.3.0: Integration tests, disaster recovery

---

**Version:** 0.2.0 | **Terraform:** 1.14.3 | **AWS Provider:** ~> 5.0
