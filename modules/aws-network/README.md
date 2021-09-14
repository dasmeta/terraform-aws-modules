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

module network {
    source      = "git::https://github.com/dasmeta/terraform.git//modules/newtwork?="
    
    #VPC Peering
    create_vpc_peering = false
    main_vpc_id        = "vpc-1234567889"
    peering_vpc_id     = "vpc-1234456789"
    peering_tags                = {
        Name        = "Peering Main to Slave"#
        Environment = "Hello"
    }
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