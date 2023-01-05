# Terraform AWS Client VPN Endpoint

## example with SSO

### How to create Application for VPN in AWS Single Sign-On

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
- When module completely create you can download aws client vpn. https://aws.amazon.com/vpn/client-vpn-download/
- Add vpn profile and add ovpn file.

### module setup for SSO

```hcl
module network {
    source  = "dasmeta/modules/aws//modules/aws-vpn-vpnendpoint"
    version = "0.36.4"

    # If you connect many vpc in vpn you should create vpc peering
    peering_vpc_ids               = ["vpc-0bdf97ed6f2d42f37","vpc-063637d7c4597b4cf"]

    # VPN vpc Id
    vpc_id                        = "vpc-041abee1cf26e79dc"
    endpoint_name                 = "module_vpn"
    endpoint_client_cidr_block    = "30.0.0.0/16"
    saml_provider_arn             = "" # SAML Provider ARN
    certificate_arn               = "" # Certificate ARN
    authorization_ingress         = ["0.0.0.0/0"] # VPCs CIDRs

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
}
```

## example with client certificate

In order to use VPN with client certificate one have to instal openvpn and easy-rsa
here is simple steps for

### how to create CA certificate server and client keys using easy-rsa tool

```sh
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3
./easyrsa init-pki
./easyrsa build-ca nopass # type yes for build success
./easyrsa build-server-full server nopass # create server
./easyrsa build-client-full client1.domain.tld nopass # create an client
mkdir ./custom_folder/
cp pki/ca.crt ./custom_folder/
cp pki/issued/server.crt ./custom_folder/
cp pki/private/server.key ./custom_folder/
cp pki/issued/client1.domain.tld.crt ./custom_folder
cp pki/private/client1.domain.tld.key ./custom_folder/
cd ./custom_folder/

```

### upload generated server and client certificates into aws CM (it will output certificate arm)

```sh
aws acm import-certificate --certificate fileb://server.crt --private-key fileb://server.key --certificate-chain fileb://ca.crt
aws acm import-certificate --certificate fileb://client1.domain.tld.crt --private-key fileb://client1.domain.tld.key --certificate-chain fileb://ca.crt
```

### download .ovpn from vpn endpoint and edit it by adding the following in end of file

cert /path/client1.domain.tld.crt
key /path/client1.domain.tld.key

### module setup

```hcl

module "vpn_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "my_vpn_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.10.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
}

module "vpn" {
  source  = "dasmeta/modules/aws//modules/aws-vpn-vpnendpoint/"
  version = "0.36.4"

  # VPN Endpoint
  vpc_id                     = module.vpn_vpc.vpc_id
  endpoint_name              = "my_test"
  endpoint_client_cidr_block = "30.0.0.0/16"
  saml_provider_arn          = ""
  certificate_arn            = "arn:aws:acm:eu-central-1:xxxxx:certificate/yyy-yyyy-yyyy-yyyy-yyyyyyyyyyyyy"
  client_certificate_arn     = "arn:aws:acm:eu-central-1:yyyyy:certificate/zzz-zzzz-zzzz-zzzz-zzzzzzzzzzzzz"

  // Accept traffic to cidrs
  authorization_ingress = ["172.17.0.0/16", "0.0.0.0/0"]
  endpoint_subnets = [
    module.vpn_vpc.private_subnets[0]
  ]
  additional_routes = {
    test = {
        cidr      = "172.17.0.0/16"
        subnet_id = module.vpn_vpc.private_subnets[0]
    }
  }

  split_tunnel    = false
  peering_vpc_ids = ["vpc-xxxxxxxxxxxxx"]
  vpn_port        = 1194

  providers = {
    aws      = aws
    aws.peer = aws
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 0.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_multi_peering"></a> [vpc\_multi\_peering](#module\_vpc\_multi\_peering) | ../aws-multi-vpc-peering/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ec2_client_vpn_authorization_rule.my-vpn_sso_to_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.my-vpn_sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.my-vpn_sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.my-vpn_sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_security_group.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_routes"></a> [additional\_routes](#input\_additional\_routes) | A map where the key is a subnet ID of endpoint subnet for network association and value is a cidr to where traffic should be routed from that subnet. Useful in cases if you need to route beyond the VPC subnet, for instance peered VPC | `any` | `{}` | no |
| <a name="input_authorization_ingress"></a> [authorization\_ingress](#input\_authorization\_ingress) | Add authorization rules to grant clients access to the networks. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate arn | `string` | n/a | yes |
| <a name="input_client_certificate_arn"></a> [client\_certificate\_arn](#input\_client\_certificate\_arn) | Client Certificate arn when we setup certificate-authentication type vpn | `string` | `""` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | Specifies the ARN of the CMK to use when encrypting log data. | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_name_prefix"></a> [cloudwatch\_log\_group\_name\_prefix](#input\_cloudwatch\_log\_group\_name\_prefix) | Specifies the name prefix of CloudWatch Log Group for VPC flow logs. | `string` | `"/aws/client-vpn-endpoint/"` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPN connection logs. | `number` | `30` | no |
| <a name="input_dns_server"></a> [dns\_server](#input\_dns\_server) | n/a | `list(string)` | `[]` | no |
| <a name="input_endpoint_client_cidr_block"></a> [endpoint\_client\_cidr\_block](#input\_endpoint\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater. | `string` | `"10.100.100.0/22"` | no |
| <a name="input_endpoint_name"></a> [endpoint\_name](#input\_endpoint\_name) | Name to be used on the Client VPN Endpoint | `string` | n/a | yes |
| <a name="input_endpoint_subnets"></a> [endpoint\_subnets](#input\_endpoint\_subnets) | List of IDs of endpoint subnets for network association | `list(string)` | n/a | yes |
| <a name="input_peering_vpc_ids"></a> [peering\_vpc\_ids](#input\_peering\_vpc\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_saml_provider_arn"></a> [saml\_provider\_arn](#input\_saml\_provider\_arn) | The ARN of the IAM SAML identity provider. | `string` | `""` | no |
| <a name="input_split_tunnel"></a> [split\_tunnel](#input\_split\_tunnel) | n/a | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpn_port"></a> [vpn\_port](#input\_vpn\_port) | n/a | `number` | `443` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
