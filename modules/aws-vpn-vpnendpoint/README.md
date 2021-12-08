# Terraform AWS Client VPN Endpoint 

## How to create Application for VPN in AWS Single Sign-On
- Create private certificate in AWS Certificate Manager. Copy arn and use in module
- Open AWS SSO service page. Select Applications from the sidebar
- Choose Add a new application
- Select Add a custom SAML 2.0 application
- Fill Display name and Description
- Set session duration (VPN session duration) - 12h
- Select "If you don't have a metadata file, you can manually type your metadata values."
- Application ACS URL: http://127.0.0.1:35001
- Application SAML audience: urn:amazon:webservices:clientvpn
- Save changes
- Download AWS SSO SAML metadata file.
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
    region                        = "us-east-1"
    enable_saml                   = false
    
    # If you connect many vpc in vpn you should create vpc peering
    create_peering                = true
    peering_vpc_ids               = ["vpc-0bdf97ed6f2d42f37","vpc-063637d7c4597b4cf"]

    # VPN vpc Id
    vpc_id                        = "vpc-041abee1cf26e79dc"
    endpoint_name                 = "module_vpn"
    endpoint_client_cidr_block    = "30.0.0.0/16"
    saml_provider_arn             = "" # SAML Provider ARN
    certificate_arn               = "" # Certificate ARN
    authorization_ingress         = ["10.0.0.0/16","20.0.0.0/16","40.0.0.0/16"] # VPCs CIDRs
    
    endpoint_subnets              = ["subnet-073672353a64692db0148"]
    
    # Add routes in VPN route table 
    additional_routes             = {
                                        first = {
                                                    cidr      = "20.0.0.0/16"
                                                    subnet_id = "subnet-073672353a64692db014"
                                                }
                                        second = {
                                                    cidr      = "40.0.0.0/16"
                                                    subnet_id = "subnet-073672353a64692db014"
                                                }
                                    }
    # Vpn file location and name file extension .ovpn
    vpn_file_download        = "/Users/juliaaghamyan/Documents/vpn.ovpn"
}


