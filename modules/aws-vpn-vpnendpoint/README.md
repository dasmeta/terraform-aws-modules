# Terraform AWS Client VPN Endpoint 

Before you start create vpn you should be create vpc peering.If you use many vpc in vpn.
Module source "dasmeta/modules/aws//modules/aws_multi_vpc_peering"

## How to create Application for VPN in AWS Single Sign-On
- Create private certificate in AWS Certificate Manager. 
- Open AWS SSO service page. Select Applications from the sidebar
- Choose Add a new application
- Select Add a custom SAML 2.0 application
- Fill Display name and Description
- Set session duration (VPN session duration) - 12h
- Select "If you don't have a metadata file, you can manually type your metadata values."
- Application ACS URL: http://127.0.0.1:35001
- Application SAML audience: urn:amazon:webservices:clientvpn
- Save changes
- Download AWS SSO SAML metadata file (file for vpn secret)
- Select tab "Attribute mappings":
    - Subject -> ${user:subject} -> emailAddress
    - NameID -> ${user:email} -> basic
    - FirstName -> ${user:name} -> basic
    - LastName -> ${user:familyName} -> basic
- Select tab "Assigned users", if you haven't user you should be create in SSO.
- Assign users or groups created on previous step
- You add AWS Account in AWS SSO, and add create Permission sets.
- Go to IAM Service -> "Identity Providers" and create "Add provider" choose configure provider "SAML", add provider name and upload SSO SAML metadata file.
- Copy saml arn and use in module.

## Example

module network {
    source      = "dasmeta/modules/aws//modules/aws-vpn-vpnendpoint"
    
    # VPN Endpoint
    enable_saml                   = false
    vpc_id                        = "vpc-123456789"
    endpoint_name                 = "module_vpn"
    endpoint_client_cidr_block    = "10.100.0.0/16"
    saml_provider_arn             = "" # SAML Provider ARN
    certificate_arn               = "" # Certificate ARN
    authorization_ingress         = ["192.168.0.0/16","172.31.0.0/16","10.254.0.0/16"] # VPCs CIDRs
    endpoint_subnets              = ["subnet-111111111111111111","subnet-222222222222","subnet-3333333333333"]
    # VPC Create
    create_vpc                      = true
    vpc_name                        = "VPN-vpc"
    cidr                            = "172.254.0.0/16"
    availability_zones              = ["us-east-2a", "us-east-2b", "us-east-2c"]
    private_subnets                 = ["172.254.1.0/24", "172.254.2.0/24", "172.254.3.0/24"]
    public_subnets                  = ["172.254.4.0/24", "172.254.5.0/24", "172.254.6.0/24"]
}
