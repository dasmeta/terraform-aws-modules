# Terraform AWS Client VPN Endpoint 

## How to create Application for VPN in AWS Single Sign-On
- Create private certificate.
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
- Select tab "Assigned users"
- Assign users or groups created on previous step

## Example

module "vpn" {
  source       = "git::https://github.com/dasmeta/terraform.git//modules/?"
    endpoint_name              = "Name to be used on the Client VPN Endpoint"
    #endpoint_subnets           = ["subnet-zone-1a","subnet-zone-1b","subnet-zone-1c"] #List of IDs of endpoint subnets for network association
    endpoint_vpc_id            = "VPC ID where the VPN will be connected."
    saml_provider_arn          = "The ARN of the IAM SAML identity provider."
    certificate_arn            = "The ARN of the Private certificate"
    authorization_rules = {}
    tags                               = {
        "Name" = "terraform-vpn"
    } 
    # New VPC Settings
    vpc_name                    = "VPN-Network"
    cidr                        = "10.254.0.0/16"
    availability_zones          = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    private_subnets             = ["10.254.0.0/20", "10.254.16.0/20", "10.254.32.0/20"]
    public_subnets              = ["10.254.48.0/20", "10.254.64.0/20", "10.254.80.0/20"]
    public_subnet_tags          = {
    Name = "VPN-public"
    }
    private_subnet_tags         = {
    Name = "VPN-private"
    }
    #New VPC Peering Settings
    peering_vps_ids                = ["vpc-peering-1","vpc-peering-2","peering-N"]
}


