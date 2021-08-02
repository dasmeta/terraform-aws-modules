resource "aws_cognito_user_pool" "pool" {
    alias_attributes           = [
        "email",
        "phone_number",
    ]
    auto_verified_attributes   = [
        "email",
        "phone_number",
    ]
    mfa_configuration          = "OPTIONAL"
    name                       = var.name
    sms_authentication_message = "Your verification code is {####}. "
    tags                       = {}
    tags_all                   = {}

    account_recovery_setting {
        recovery_mechanism {
            name     = "verified_email"
            priority = 2
        }
        recovery_mechanism {
            name     = "verified_phone_number"
            priority = 1
        }
    }

    admin_create_user_config {
        allow_admin_create_user_only = false

        invite_message_template {
            email_message = "Your username is {username} and temporary password is {####}. "
            email_subject = "Your temporary password"
            sms_message   = "Your username is {username} and temporary password is {####}. "
        }
    }

    device_configuration {
        challenge_required_on_new_device      = false
        device_only_remembered_on_user_prompt = true
    }

    email_configuration {
        email_sending_account = "COGNITO_DEFAULT"
    }

    # lambda_config {
    #     custom_message = "arn:aws:lambda:eu-central-1:721658514311:function:cognitoCustomEmailLambda"
    # }

    password_policy {
        minimum_length                   = 8
        require_lowercase                = true
        require_numbers                  = true
        require_symbols                  = true
        require_uppercase                = true
        temporary_password_validity_days = 7
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }
    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "phone_number"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }

    # sms_configuration {
    #     external_id    = "b92bc75d-7025-4b90-adc5-e21d0d19a01e"
    #     sns_caller_arn = "arn:aws:iam::721658514311:role/service-role/vonpolldev-SMS-Role"
    # }

    software_token_mfa_configuration {
        enabled = true
    }

    username_configuration {
        case_sensitive = false
    }

    verification_message_template {
        default_email_option  = "CONFIRM_WITH_CODE"
        email_message_by_link = <<-EOT
            Pool -> dev -> Please click the link below to verify your email address.
            Please click here -> {##Click Here##}
        EOT
        email_subject_by_link = "Test"
    }
}