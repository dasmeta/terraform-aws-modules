# Minimum usage example

This module creates an "example-pool" and a "main" client. Both of them have default values a part of which is described in the variables.tf file. 

```
module "cognito" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/cognito?ref=0.5.0"

  name = "example-pool"
  clients = ["main"]
  auto_verified_attributes = [ "email" ]
}
```


# Usage example

In this example sms and email verification or authentication messages are added. They are properly described in the variables.tf file.

```
module "user-pool" {
    source =  "git::https://github.com/dasmeta/terraform.git//modules/cognito?ref=0.5.0"

    name = "example2-pool"
    clients = ["main-client"]
    email_verification_message = "Email verification message: {####}"
    email_verification_subject = "Your verification code"
    sms_authentication_message = "SMS example: {####}"
    sms_verification_message   = "SMS example: {####}"
    
    verification_message_template = {
        email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##} "
        email_subject_by_link = "Your verification link"
    }
}
```

# Another usage example

Here schemas, lambda_config and sms_configuration are added. Also if you want to generate secrets for app clients, generate_secret have to be set true.

```
module "cognito" {
    source = "../../terraform-aws-modules/modules/cognito-user-pool"  

    name                       = "example3-pool"
    email_verification_message = "Your verification code is {####}. "
    email_verification_subject = "Your verification code"
    sms_authentication_message = "Your verification code is {####}. "
    sms_verification_message   = "Your verification code is {####}. "
    clients = ["client1", "client2"]
    generate_secret = true
    schema = [
      {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints = {
            max_length = "2048"
            min_length = "0"
        }
      },
      {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "location"
        required                 = false

        string_attribute_constraints = {
            max_length = "256"
            min_length = "1"
        }
      },
      {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "phone_number"
        required                 = true

        string_attribute_constraints = {
            max_length = "2048"
            min_length = "0"
        }
     }
    ]

    lambda_config = {
      kms_key_id = "arn:aws:kms:eu-central-1..."
      custom_email_sender = {
          lambda_arn     = "arn:aws:lambda:eu-central-1:..."
          lambda_version = "V1_0"
      }
    }

    sms_configuration = {
      external_id    = "some id"
      sns_caller_arn = "arn:aws:iam::..."
    }
}
```
