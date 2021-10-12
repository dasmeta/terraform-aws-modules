# Add HTTP security headers
**CloudFront Functions event type: viewer response**
Terraform module to create a Lambda@Edge function to add best practice security headers and support HSTS preload requirements.

- [Creating a Simple Lambda@Edge Function] ( https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-how-it-works-tutorial.html )

# Usage

**IMPORTANT:** Make sure that you’re in the US-East-1 (N. Virginia) Region (us-east-1). You must be in this Region to create Lambda@Edge functions.

## Step 1: Create a Lambda@Edge using a module `aws-cloudfront-security-headers`

````hcl

module aws-cloudfront-security-headers {
    source                  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
    name                    = "CloudFront-Add-HSTS-Header"
}

```
## Step 2: Add a CloudFront Trigger to Run the Function
Now that you have a Lambda function to update security headers, configure the CloudFront trigger to run your function to add the headers in any response that CloudFront receives from the origin for your distribution.

![](https://github.com/dasmeta/terraform-aws-modules/blob/main/modules/aws-cloudfront-security-headers/cloudfront.gif)