# Minimum usage example

This module creates an "example-pool" and a "main" client. Both of them have default values a part of which is described in the variables.tf file.

```
module "cognito" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/cognito?ref=0.5.0"

  name = "example-pool"
  clients = ["main"]
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
