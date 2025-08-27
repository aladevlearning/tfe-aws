# tfe-aws

This repository provides Terraform deployment capabilities from a centralized CICD account to multiple AWS Organization accounts.  
It enables secure cross-account deployments using IAM roles and environment-specific configuration.

---

## Use case
Use case is described in my [Medium article](https://alatech.medium.com/enterprise-cloud-patterns-from-the-trenches-centralized-waf-for-cloudfront-d81a9b524840).

<img width="1906" height="1200" alt="image" src="https://github.com/user-attachments/assets/c803cb42-e6c1-4f67-8956-c7e100d204cb" />

## Requirements

- **AWS Account IDs** for all target accounts.
- **GitHub Secrets**:
    - `CICD_IAM_ROLE_ARN` — IAM role used by the CICD pipeline.
    - `TFVARS_FILE` — Terraform variable definitions for target accounts and roles.

---

## TFVARS_FILE Example

Define your `TFVARS_FILE` as follows (all strings must be in double quotes):

```hcl
workload1_account_id                  = "ACCOUNT_ID"
security_account_id                   = "ACCOUNT_ID"
xyz_account_id                        = "ACCOUNT_ID"

iam_role_workload1_tf_deployer_arn   = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
iam_role_security_tf_deployer_arn    = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
iam_role_xyz_tf_deployer_arn         = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
