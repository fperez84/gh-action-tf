# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2026-03-04

### 🤖 AI & Security Tooling Release

#### Added
- **Snyk IaC Security Scanning**
  - `snyk/actions/iac@master` integrated in `pull-requests.yml`
  - SARIF report generation and upload to GitHub Code Scanning
  - Inline vulnerability annotations on PR diffs
  - Severity threshold configurable via `--severity-threshold`
  - Blocks PR pipeline on detected vulnerabilities

- **CodeRabbit AI Code Review**
  - Automatic AI-powered review on every PR via GitHub App
  - `.coderabbit.yaml` configuration file added to repo root
  - Path-specific review instructions for `.tf` files and `lambda_function.py`
  - Tuned for IaC security: IAM permissions, security groups, encryption, naming

- **Infracost Cost Estimation**
  - Cost diff comment posted automatically on every PR
  - Baseline generated from base branch, compared against PR branch
  - Monthly cost breakdown per AWS resource
  - Uses `infracost/actions` in `pull-requests.yml`

- **New GitHub Secrets Required**
  - `SNYK_TOKEN`: Snyk API token (personal or service account)
  - `INFRACOST_API_KEY`: Infracost API key

#### Changed
- `pull-requests.yml`: `snyk-security` job added; `terraform-plan` and `infracost` jobs now depend on it via `needs`
- `README.md`: Updated badges, features, setup instructions, and troubleshooting table
- `SETUP.md`: Added setup sections for Snyk, Infracost, and CodeRabbit

#### Security
- Snyk IaC scanner now catches misconfigurations before merge (IMDSv1, open SSH, unencrypted EBS, etc.)
- SARIF results visible in repo `Security → Code Scanning` tab (free for public repos)

### 🔧 Technical Details
- **Terraform Version**: 1.14.3
- **AWS Provider**: ~> 5.0
- **Target Environment**: dev
- **Backend**: S3 with encryption

### 📊 Metrics
- **Workflows**: 3 (PR, Main, Manual)
- **Jobs**: 10 total across all workflows (+2 from v0.1.0)
- **Security Checks**: Format, validation, tfsec, tflint, **Snyk IaC**
- **AWS Resources**: ~8 resources deployed

---

## [0.1.0] - 2024-02-26

### 🎉 Initial Release

#### Added
- **GitHub Actions Workflows**
  - PR validation pipeline with format, security, and plan checks
  - Main deployment pipeline with plan caching and manual approval
  - Manual operations workflow for emergency procedures

- **Terraform Infrastructure**
  - AWS Lambda function with S3 integration
  - S3 bucket with versioning and encryption
  - CloudWatch monitoring and alerting
  - IAM roles with least-privilege permissions

- **Security Features**
  - S3 backend for state management
  - Plan integrity verification with hash checking
  - Security scanning with tfsec
  - Encrypted state storage

- **Documentation**
  - Complete setup instructions
  - Workflow documentation
  - Troubleshooting guide

#### Infrastructure Components
- Lambda function (Python 3.9)
- S3 bucket with security controls
- CloudWatch logs and metrics
- IAM execution roles

#### Workflow Features
- Plan caching between PR and deployment
- Manual approval gates
- Automated security scanning
- State persistence in S3

### 🔧 Technical Details
- **Terraform Version**: 1.14.3
- **AWS Provider**: ~> 5.0
- **Target Environment**: dev
- **Backend**: S3 with encryption

### 📊 Metrics
- **Workflows**: 3 (PR, Main, Manual)
- **Jobs**: 8 total across all workflows
- **Security Checks**: Format, validation, tfsec, tflint
- **AWS Resources**: ~8 resources deployed

---

## Template for Future Releases

### [Unreleased]

#### Added
#### Changed
#### Deprecated
#### Removed
#### Fixed
#### Security
