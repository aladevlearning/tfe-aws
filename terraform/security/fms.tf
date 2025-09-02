# Firewall Manager Policy with simple, testable WAF rule
/*
resource "aws_fms_policy" "cloudfront_waf_policy" {
  provider = aws.security_use1

  name         = "CloudFront-WAF-Policy"
  resource_type = "AWS::CloudFront::Distribution"

  remediation_enabled = true # Apply to existing resources

  # Apply to all accounts in the organization
  include_map {
    account = [var.workload1_account_id , var.security_account_id]
  }

  security_service_policy_data {
    type                 = "WAFV2"
    managed_service_data = jsonencode({
      type = "WAFV2"

      postProcessRuleGroups = []

      defaultAction = {
        type = "ALLOW"
      }

      overrideCustomerWebACLAssociation = false

      preProcessRuleGroups = [
        {
          ruleGroupArn = null
          excludedRules = []
          ruleGroupType = "ManagedRuleGroup"

          # AWS Managed Rule - Common Rule Set (easily testable)
          managedRuleGroupIdentifier = {
            vendorName           = "AWS"
            managedRuleGroupName = "AWSManagedRulesCommonRuleSet"
          }

          overrideAction = {
            type = "NONE"   # Let rule group's default action take effect (BLOCK)
          }
        }
      ]
    })
  }

  resource_tags = {
    "FMSProtected" = "true"
  }
  exclude_resource_tags = false # False = All regardless of tag
}

 */