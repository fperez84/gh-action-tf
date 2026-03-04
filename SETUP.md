# Setup Guide

## Prerequisites

- AWS Account with admin access
- GitHub repository (public for free Code Scanning)
- AWS CLI configured locally
- Snyk account ([snyk.io](https://snyk.io))
- Infracost account ([infracost.io](https://infracost.io))
- CodeRabbit account ([coderabbit.ai](https://coderabbit.ai))

---

## Step-by-Step Setup

### 1. AWS Backend Setup

\`\`\`bash
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
\`\`\`

---

### 2. GitHub Configuration

**Secrets** (`Settings → Secrets and variables → Actions → Secrets`):

| Secret | Description | How to obtain |
| :-- | :-- | :-- |
| `AWS_ACCESS_KEY_ID` | AWS access key | AWS IAM Console |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | AWS IAM Console |
| `AWS_DEFAULT_REGION` | Target region (e.g. `us-east-1`) | — |
| `SNYK_TOKEN` | Snyk API token | See section 4 below |
| `INFRACOST_API_KEY` | Infracost API key | See section 5 below |

**Variables** (`Settings → Secrets and variables → Actions → Variables`):

| Variable | Description |
| :-- | :-- |
| `TF_VAR_vpc_id` | Target VPC ID |

Get your default VPC ID:
\`\`\`bash
aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query 'Vpcs[0].VpcId' --output text
\`\`\`

---

### 3. Update Terraform Backend

Edit `terraform/versions.tf`:

\`\`\`hcl
backend "s3" {
  bucket  = "your-bucket-name-here"
  key     = "infrastructure/terraform.tfstate"
  region  = "us-east-1"
  encrypt = true
}
\`\`\`

---

### 4. Snyk Setup

Snyk scans your Terraform code for IaC misconfigurations on every PR.

1. Create a free account at [snyk.io](https://snyk.io) (sign in with GitHub)
2. Go to **Account Settings → General → Auth Token**
3. Copy your API token (or create a Service Account at `Settings → Service Accounts` for CI/CD best practice)
4. Add it as `SNYK_TOKEN` secret in GitHub

> Results are uploaded as SARIF to GitHub Code Scanning and shown as inline annotations on the PR diff. Free for public repositories.

---

### 5. Infracost Setup

Infracost posts cost estimation diffs as PR comments.

1. Create a free account at [infracost.io](https://infracost.io)
2. Run locally to get your API key:
\`\`\`bash
infracost auth login
infracost configure get api_key
\`\`\`
3. Add it as `INFRACOST_API_KEY` secret in GitHub

---

### 6. CodeRabbit Setup

CodeRabbit provides AI-powered code review on every PR automatically.

1. Go to [coderabbit.ai](https://coderabbit.ai) and sign in with GitHub
2. Click **"Add Repositories"** and select your repo
3. The `.coderabbit.yaml` file in the repo root controls review behavior — no further pipeline changes needed

> CodeRabbit is free for public repositories.

---

### 7. Environment Setup (Optional)

Create a GitHub environment for manual approval gate:

`Settings → Environments → New environment`
- **Name**: `dev`
- **Protection rules**: Required reviewers → add yourself

---

### 8. Test Setup

\`\`\`bash
# Create test branch
git checkout -b feature/test-setup

# Make small change
echo "# Test" >> terraform/README.md

# Commit and push
git add .
git commit -m "test: verify workflow setup"
git push -u origin feature/test-setup
\`\`\`

Create a PR and verify all jobs run:
- `terraform-fmt`, `terraform-validate`, `security-scan`, `terraform-lint`
- `snyk-security` — check Security tab for SARIF results
- `infracost` — cost diff comment on PR
- `terraform-plan` — plan cached for deployment
- CodeRabbit — AI review comment appears automatically

---

## Verification Checklist

- [ ] S3 bucket created with encryption and versioning
- [ ] GitHub secrets configured (`AWS_*`, `SNYK_TOKEN`, `INFRACOST_API_KEY`)
- [ ] `TF_VAR_vpc_id` variable set
- [ ] Backend configuration updated in `versions.tf`
- [ ] CodeRabbit app added to repository
- [ ] Test PR shows all workflow jobs passing
- [ ] Snyk annotations visible in PR diff
- [ ] Infracost comment posted on PR
- [ ] CodeRabbit review comment posted on PR
- [ ] Manual approval environment configured (optional)

---

## Next Steps

- Review generated plan in test PR
- Merge PR to trigger deployment
- Verify infrastructure in AWS console
- Test manual workflow with `workflow_dispatch`
